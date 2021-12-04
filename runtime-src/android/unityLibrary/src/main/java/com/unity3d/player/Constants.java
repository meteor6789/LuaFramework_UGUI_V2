package com.unity3d.player;

public class Constants {

	public final static String TAG = "Unity-print-java";
	public final static String fileSharedPreferences = "qh_mahjong";
	public final static boolean isTracer = true;
	
	public final static int MSG_LUA_INIT_FINISH = 0;
	public final static int MSG_TYPE_APP_INFO = 1;
	public final static int MSG_TYPE_APP_BATTERY = 2;
	public final static int MSG_TYPE_APP_NETWORK_SINGALE = 3;
	public final static int MSG_TYPE_CHECK_NETWORK = 4;
	public final static int MSG_TYPE_SHARE_RESULT = 5;
	public final static int MSG_TYPE_SHARE_INVITE = 6;
	public final static int MSG_TYPE_ROOM_NUM = 7;
	public final static int MSG_TYPE_OPEN_IN_WEBVIEW = 8;
	public final static int MSG_TYPE_COPY = 9;
	public final static int MSG_TYPE_OPEN_IN_BROWER = 10;
	public final static int MSG_TYPE_GPS_LOCATION = 11;
	public final static int MSG_TYPE_VIBRATOR = 12;//震动
	public final static int MSG_TYPE_CREATE_QRCODE = 13;//创建二维码
	public final static int MSG_TYPE_DIRECT_SHARE = 14;//指定分享到某个应用
	public final static int MSG_TYPE_SAVE_PIC = 15;//保存图片到本地
	
	public final static int MSG_TYPE_PICK_PHOTO = 17;//选择本地图片
	public final static int MSG_TYPE_PASTE_CLIP_TEXT = 18;//获取粘贴板内容
	public final static int MSG_TYPE_GET_GAME_SHEILD = 19;//获取游戏盾数据
	public final static int MSG_TYPE_WRITE_SHARE_PREFERENCES = 20;//写存档
	public final static int MSG_TYPE_READ_SHARE_PREFERENCES = 21;//读存档
	public final static int MSG_VOICE = 22;//语音相关
	public final static int MSG_TYPE_READ_PHONE_NUMBER = 23;//读取手机号码
	
	public final static int MSG_TYPE_SET_ORIENTATION = 24;//设置手机的旋转方向
	
	public final static int MSG_INIT_PERMISSION = 50;//初始化需要的手机权限
	
	public final static int MSG_VOICE_REGIST = 100;//注册语音
	public final static int MSG_VOICE_START_RECORD = 101;//开始录音
	public final static int MSG_VOICE_STOP_RECORD = 102;//停止录音
	public final static int MSG_VOICE_PLAY = 103;//播放录音
	public final static int MSG_VOICE_STOP = 104;//停止播放录音
	
	public final static int CODE_SUCCESS = 1;
	public final static int CODE_ERROR_UNSUPPORT_WX = 11;
	public final static int CODE_ERROR_NETWORK_ERROR = 12;
	public final static int CODE_ERROR_WX_CANCEL = 13;
	public final static int CODE_ERROR_FAILED = 14;
	
	
	public final static int HANDLER_ID_COPY = 1;
	public final static int HANDLER_H5_PAY = 2;
	public final static int HANDLER_LOCATION = 3;
	public final static int HANDLER_ID_PASTE = 4;
	
	public final static int REQUEST_CODE_CONTACT = 101;
	public static final int BAIDU_READ_PHONE_STATE = 100;//定位权限请求
	public static final int AUDIO_STATE = 102;//录音权限
	public static final int READ_PHONE_STATE = 103;//手机号码权限
	public static final int ACCESS_FINE_LOCATION = 104;//定位
	public static final int LOCATION_PERMISSON_REQUESTCODE = 105;
}
