--package.cpath = package.cpath .. ';/Users/loon/Library/Application Support/JetBrains/IntelliJIdea2020.1/plugins/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9966)

if UnityEngine.Application.isEditor then
	local debugger = require("mobdebug")
	debugger.start();
end

require("Common.config")
require("Common.Base64")

function Main()
	print("#Main start! !!!!!#")

	UpdateBeat:Add(Update, self)
end

function Update()
	--log("Update")
	if Input.GetKeyDown(KeyCode.Escape) then
		log("按下返回键")
		print("UnityEngine.Application.platform:" .. tostring(UnityEngine.Application.platform))
		if UnityEngine.Application.isEditor then
			print("当前为编辑器模式")
		else
			UnityEngine.Application.Quit()
		end
	end
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
	print("OnLevelWasLoaded:" .. level);
end

function OnApplicationQuit()
end