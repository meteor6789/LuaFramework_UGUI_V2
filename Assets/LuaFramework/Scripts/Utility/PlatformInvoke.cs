using System;
using UnityEngine;

namespace LuaFramework
{
    public class PlatformInvoke : MonoBehaviour
    {
        private string cls_name_android = "com.unity3d.player.Function4Unity";

        public int LuaCallAndroid(int type,string content)
        {
            Util.Log("LuaCallAndroid CalledByUnity3d");
#if  UNITY_ANDROID
            try
            {
                // using (AndroidJavaClass jc = new AndroidJavaClass(cls_name_android))
                // {
                //     //获取到Activity
                //     using (AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity"))
                //     {
                //         //调用Java方法
                //         return jo.Call<int>("CalledByUnity3d",new object[] {type,content});
                //     }
                // }
                
                // var javaClass = new AndroidJavaObject(cls_name_android);
                // return javaClass.Call<int>("CalledByUnity3d",type,content);
                
                AndroidJavaObject androidJavaObject = new AndroidJavaObject(cls_name_android);
                return androidJavaObject.Call<int>("CalledByUnity3d",type,content);
            }
            catch (System.Exception ex)
            {
                Debug.Log("callSdk error:" + ex.Message);
            }      
#endif
            return 0;
        }

        public int AndroidCallLua(string content)
        {
            Util.CallMethod("Game", "CalledByPlatform", content);
            return 0;
        }
    }
}