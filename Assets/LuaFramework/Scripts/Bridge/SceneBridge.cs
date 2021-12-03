using System.Collections;
using System.Collections.Generic;
using LuaFramework;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace LuaFramework
{
    public class SceneBridge : Base
    {
        [Header("GameObject")]
        [Tooltip("当前场景名称")]
        public string sceneName;
        // Start is called before the first frame update
        void Start()
        {
            LuaManager.DoFile(string.Format("Scene/{0}",this.sceneName));
            gameObject.name = sceneName;
            gameObject.AddComponent<LuaBehaviour>();
            // Button skipButton = GameObject.Find("SkipButton").GetComponent<Button>();
            // skipButton.onClick.AddListener(this.clickEvent);

        }

        // private void clickEvent()
        // {
        //     Util.Log("clickEvent");
        // }

        // LuaManager.Do
        // Update is called once per frame
        void Update()
        {
        
        }
    }
}

