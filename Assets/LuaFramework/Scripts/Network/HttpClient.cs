
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using LuaInterface;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.Networking;

namespace LuaFramework
{
    public class HttpClient: MonoBehaviour {
    public string baseUrl = "";
    public Dictionary<string, string> headers = new Dictionary<string, string>();
    // Start is called before the first frame update

    private struct ReponseCode
    {
        public static int success = 1; // 成功
        public static int rqsFailed = 2; // 请求失败
        public static int noUsableNet = 3; // 网络问题
    }

    public void Get(string url ,LuaFunction action)
    {
        StartCoroutine(_Get(url, action));
    }
    public void Delete(string url, LuaFunction action)
    {
        StartCoroutine(_Delete(url, action));
    }
    public void Put(string url, string data, LuaFunction action)
    {
        StartCoroutine(_Put(url, data,action));
    }
    public void Post(string url, string postData, LuaFunction action)
    {
        StartCoroutine(_Post(url, postData, action));
    }

    public void GetTexture(string url, LuaFunction action)
    {
        StartCoroutine(_GetTexture(url, action));
    }
    
    public void GetAssetBundle(string url, LuaFunction actionResult)
    {
        StartCoroutine(_GetAssetBundle(url, actionResult));
    }
    
    public void GetAudioClip(string url, LuaFunction actionResult, AudioType audioType = AudioType.WAV)
    {
        StartCoroutine(_GetAudioClip(url, actionResult, audioType));
    }
    
    /// <summary>
    /// 通过PUT方式将字节流传到服务器
    /// </summary>
    /// <param name="url">服务器目标地址 like 'http://www.my-server.com/upload' </param>
    /// <param name="contentBytes">需要上传的字节流</param>
    /// <param name="resultAction">处理返回结果的委托</param>
    /// <returns></returns>
    public void UploadByPut(string url, string filePath, LuaFunction actionResult ,string contentType)
    {
        StartCoroutine(_UploadByPut(url, filePath, actionResult,contentType));
    }

    public void SetHeads(string heads)
    {
        this.headers.Clear();
        if (heads != null)
        {
            this.headers = JsonConvert.DeserializeObject<Dictionary<string, string>>(heads);
        }
    }

    private void _SetHeaders(UnityWebRequest unityWebRequest)
    {
        foreach (var item in headers)
        {
            unityWebRequest.SetRequestHeader(item.Key, item.Value);
        }
    }
    //"http://www.my-server.com"
    IEnumerator _Get(string url, LuaFunction callback)
    {
        UnityWebRequest www = UnityWebRequest.Get(url);
        //www.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
        _SetHeaders(www);
        yield return www.SendWebRequest();

        HandleResult(callback, www);
    }
    // IEnumerator _Get(string method, LuaFunction callback)
    // {
    //     UnityWebRequest www = UnityWebRequest.Get(method);
    //     //www.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
    //     _SetHeaders(www);
    //     yield return www.SendWebRequest();
    //     
    //     HandleResult(callback, www);
    // }
    //"http://www.my-server.com"
    IEnumerator _Delete(string url, LuaFunction callback)
    {
        UnityWebRequest www = UnityWebRequest.Delete(url);
        _SetHeaders(www);
        yield return www.SendWebRequest();
        HandleResult(callback, www);
    }

    //"http://www.my-server.com/image.png"
    IEnumerator _GetTexture(string url,LuaFunction callback)
    {
        UnityWebRequest www = UnityWebRequestTexture.GetTexture(url);
        _SetHeaders(www);
        yield return www.SendWebRequest();

        if (www.isNetworkError || www.isHttpError)
        {
            Debug.Log(www.error);
        }
        else
        {
            Texture myTexture = DownloadHandlerTexture.GetContent(www);
            if (callback != null)
            {
                callback.Call(1,myTexture);
            }
        }
    }
    //"http://www.my-server.com/myform"
     IEnumerator _UploadFile(string url, byte[] bytes, LuaFunction callback)
    {
        UnityWebRequest www = new UnityWebRequest(url, "POST");
        www.uploadHandler = (UploadHandler)new UploadHandlerRaw(bytes);
        www.downloadHandler = (DownloadHandler)new DownloadHandlerBuffer();
        www.SetRequestHeader("Content-Type", "application/octet-stream");
        string token;
        headers.TryGetValue("Authorization", out token);
        www.SetRequestHeader("Authorization", token); //if your server need token
        yield return www.SendWebRequest();
        if (www.isDone)
        {
            HandleResult(callback, www);
        }
    }
     
     /// <summary>
     /// 下载文件
     /// </summary>
     /// <param name="url">请求地址</param>
     /// <param name="downloadFilePathAndName">储存文件的路径和文件名 like 'Application.persistentDataPath+"/unity3d.html"'</param>
     /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求对象</param>
     /// <returns></returns>
     IEnumerator _DownloadFile(string url,string downloadFilePathAndName,LuaFunction actionResult)
     {
         var uwr = new UnityWebRequest(url, UnityWebRequest.kHttpVerbGET);
         uwr.downloadHandler = new DownloadHandlerFile(downloadFilePathAndName);
         yield return uwr.SendWebRequest();
         if (actionResult != null)
         {
             if (actionResult != null)
             {
                 actionResult.Call(uwr);
             }
         }
     }
     
     IEnumerator _Post(string url, string postData, LuaFunction callback)
    {
        /*byte[] myData = System.Text.Encoding.UTF8.GetBytes("This is some test data");*/
        UnityWebRequest www = new UnityWebRequest(url, UnityWebRequest.kHttpVerbPOST);
        //直接使用post会encode params ，导致后台报错，所以采用上方这种方式解决
        //UnityWebRequest www = UnityWebRequest.Post(url, postData);
        www.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(postData));
        www.downloadHandler = new DownloadHandlerBuffer();
        _SetHeaders(www);
        yield return www.SendWebRequest();
        HandleResult(callback, www);
   
    }
    void HandleResult(LuaFunction callback, UnityWebRequest www)
    {
        if (www.isNetworkError || www.isHttpError)
        {
            Debug.Log(www.error);
            if (callback != null)
            {
                callback.Call(ReponseCode.rqsFailed);
            }
        }
        else
        {
            string result = www.downloadHandler.text;
            if (callback != null)
            {
                callback.Call(ReponseCode.success,result);
            }
        }
    }
    
    //"http://www.my-server.com/upload"
    IEnumerator _Put(string url, string data, LuaFunction callback)
    {
        /*byte[] myData = System.Text.Encoding.UTF8.GetBytes("This is some test data");*/
        byte[] myData = UnityWebRequest.SerializeSimpleForm(JsonConvert.DeserializeObject<Dictionary<string,string>>(data));
        UnityWebRequest www = UnityWebRequest.Put(url, myData);
        _SetHeaders(www);
        yield return www.SendWebRequest();
        HandleResult(callback, www);
    }
    
    /// <summary>
    /// 请求AssetBundle
    /// </summary>
    /// <param name="url">AssetBundle地址,like 'http://www.my-server.com/myData.unity3d'</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AssetBundle</param>
    /// <returns></returns>
    IEnumerator _GetAssetBundle(string url,LuaFunction actionResult)
    {
        UnityWebRequest www = new UnityWebRequest(url);
        DownloadHandlerAssetBundle handler = new DownloadHandlerAssetBundle(www.url, uint.MaxValue);
        www.downloadHandler = handler;
        yield return www.SendWebRequest();
        AssetBundle bundle = null;
        if (!(www.isNetworkError || www.isHttpError))
        {
            bundle = handler.assetBundle;
        }
        if (actionResult != null)
        {
            actionResult.Call(bundle);
        }
    }
    
    /// <summary>
    /// 请求服务器地址上的音效
    /// </summary>
    /// <param name="url">没有音效地址,like 'http://myserver.com/mysound.wav'</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AudioClip</param>
    /// <param name="audioType">音效类型</param>
    /// <returns></returns>
    IEnumerator _GetAudioClip(string url,LuaFunction actionResult, AudioType audioType = AudioType.WAV)
    {
        using (var uwr = UnityWebRequestMultimedia.GetAudioClip(url, audioType))
        {
            yield return uwr.SendWebRequest();
            if (!(uwr.isNetworkError || uwr.isHttpError))
            {
                if (actionResult != null)
                {
                    actionResult.Call(DownloadHandlerAudioClip.GetContent(uwr));
                }
            }
        }
    }
    
    /// <summary>
    /// 通过PUT方式将字节流传到服务器
    /// </summary>
    /// <param name="url">服务器目标地址 like 'http://www.my-server.com/upload' </param>
    /// <param name="contentBytes">需要上传的字节流</param>
    /// <param name="resultAction">处理返回结果的委托</param>
    /// <param name="resultAction">设置header文件中的Content-Type属性</param>
    /// <returns></returns>
    IEnumerator _UploadByPut(string url,string path, LuaFunction actionResult,string contentType= "application/octet-stream")
    {
        UnityWebRequest uwr = new UnityWebRequest(url);
        FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
        byte[] contentBytes = new byte[fs.Length];

        fs.Read(contentBytes, 0, contentBytes.Length);
        fs.Close();
        UploadHandler uploader = new UploadHandlerRaw(contentBytes);

        // Sends header: "Content-Type: custom/content-type";
        uploader.contentType = contentType;

        uwr.uploadHandler = uploader;

        yield return uwr.SendWebRequest();

        bool res = true;
        if (uwr.isNetworkError || uwr.isHttpError)
        {
            res = false;
        }
        if (actionResult != null)
        {
            actionResult.Call(res); 
        }
    }

    }
}