package com.unity3d.player;

public class Function4Unity {

    public int CalledByUnity3d(final int type, final String content){
        Logger.i(String.format("type: %d content: %s",type,content));
        Logger.i("start call UnitySendMessage");
        UnityPlayer.UnitySendMessage("GameManager","AndroidCallLua","im from android");
        return 1;
    }

}
