---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by loon.
--- DateTime: 2021/12/6 10:58 上午
---

local TestObject = class("TestObject")
function TestObject:ctor()


    printInfo("TestObject ctor")

end

function TestObject:testFunc()
    printInfo("TestObject testFunc")
end

return TestObject