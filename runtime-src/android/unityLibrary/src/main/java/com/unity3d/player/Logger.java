package com.unity3d.player;

import android.util.Log;

public class Logger {

	public static void i(String str)
	{
		if(!Constants.isTracer)
		{
			return;
		}
		
		Log.i(Constants.TAG, str);
	}
	
	public static void e(String str)
	{
		if(!Constants.isTracer)
		{
			return;
		}
		Log.e(Constants.TAG, str);
	}
}
