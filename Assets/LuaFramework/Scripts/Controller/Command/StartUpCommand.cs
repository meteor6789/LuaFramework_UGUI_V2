using UnityEngine;
using System.Collections;
using LuaFramework;

public class StartUpCommand : ControllerCommand {

    public override void Execute(IMessage message) {
        if (!Util.CheckEnvironment()) return;

        GameObject gameMgr = GameObject.Find("GlobalGenerator");
        if (gameMgr != null) {
            AppView appView = gameMgr.AddComponent<AppView>();
        }
        //-----------------关联命令-----------------------
        AppFacade.Instance.RegisterCommand(NotiConst.DISPATCH_MESSAGE, typeof(SocketCommand));

        //-----------------初始化管理器-----------------------
        AppFacade.Instance.AddComponent<LuaManager>(ComponentName.Lua);
        AppFacade.Instance.AddComponent<PanelManager>(ComponentName.Panel);
        AppFacade.Instance.AddComponent<SoundManager>(ComponentName.Sound);
        AppFacade.Instance.AddComponent<TimerManager>(ComponentName.Timer);
        AppFacade.Instance.AddComponent<NetworkManager>(ComponentName.Network);
        AppFacade.Instance.AddComponent<ResourceManager>(ComponentName.Resource);
        AppFacade.Instance.AddComponent<ThreadManager>(ComponentName.Thread);
        AppFacade.Instance.AddComponent<ObjectPoolManager>(ComponentName.ObjectPool);
        AppFacade.Instance.AddComponent<GameManager>(ComponentName.Game);
        AppFacade.Instance.AddComponent<HttpClient>(ComponentName.HttpClient);
        AppFacade.Instance.AddComponent<PlatformInvoke>(ComponentName.PlatformInvoke);
    }
}