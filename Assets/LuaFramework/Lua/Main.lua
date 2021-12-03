--package.cpath = package.cpath .. ';/Users/loon/Library/Application Support/JetBrains/Rider2021.1/plugins/EmmyLua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9966)

--local debugger = require("mobdebug")
--debugger.start();
--主入口函数。从这里开始lua逻辑

require("Common/config")

function Main()
	print("#Main start!#")
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
	print("OnLevelWasLoaded:" .. level);
end

function OnApplicationQuit()
end