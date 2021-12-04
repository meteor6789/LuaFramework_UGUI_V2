using UnityEngine;

namespace LuaFramework
{
    public class PlatformInvoke
    {
        public static void CallJavaFunc(string clsName,string javaFuncName, params object[] args)
        {
            try
            {
                //获取到AndroidJavaClass，至于这里为什么调用这个类，我也不是很清楚
                using (AndroidJavaClass jc = new AndroidJavaClass(clsName))
                {
                    //获取到Activity
                    using (AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity"))
                    {
                        //调用Java方法
                        jo.Call(javaFuncName, args);
                    }
                }
            }
            catch (System.Exception ex)
            {
                Debug.Log("callSdk error:" + ex.Message);
            }
        }
    }
}