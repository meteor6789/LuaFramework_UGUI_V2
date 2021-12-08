---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/8/28 下午1:36
---
local AddressManager = class("AddressManager")

local gameBakAdrsList = {}

function AddressManager:ctor()
    self.curHost = nil
    self.curHttpHost = nil

    self.curSocketPort = nil
    self.curHttpPort = nil

    self.gameSheildSocketHost = nil
    self.gameSheildHttpHost = nil
    self.gameSheildSocketPort = nil
    self.gameSheildHttpPort = nil
    self.hotUpdateHost = nil
    self.hotUpdatePort = nil


    self.isRqsDatating = false
    self.curRqsFailedTime = 0
    self.lastRqsTime = 0
    self:init()
end

function AddressManager:init()
    self.__socketConnectFailedCount = 0
    self.__httpConnectFailedCount = 0
    self.__loginFailedCount = 0
    self.curBakIndex = 0

    local isNewPlayer = PlayerPrefs.GetInt(LocalStorage.account.newPlayer,1)
    if  not isNewPlayer and domainName == defaultDomainName then
        domainName = defaultDomainName2
    end

    self:resetAdrs()
end

function AddressManager:requestGameShieldData(callBack)
    local socketResult = false
    local httpResult = false
    local updateResult = false
    if useGameShield and device.platform ~= "windows" then
        socketResult = self:requestShieldSocketData()
        httpResult = self:requestGameHttpData()
        --if getChannelName() ~= "qujing" then
        --    updateResult = self:requestHotUpdateData()
        --end
    end
    local result = socketResult and httpResult
    if callBack ~= nil then
        callBack(result)
    end
    return result
end

function AddressManager:getGroupName()
    if domainName ~= defaultDomainName and domainName ~= defaultDomainName2 then
        return "qixiTest"
    end
    return "qixiGame"
end

function AddressManager:getHotUpdateGroupName()
    return "qixi_game_hotUpdate"
end

function AddressManager:requestHotUpdateData()
    local gameGroupName = self:getHotUpdateGroupName()
    local jsonData =  gameUtil.callPlatformFun(PLATFORM_DATA_TYPE.get_game_sheild_data,{groupName = gameGroupName,port = 80})
    if jsonData == nil then
        self.hotUpdateHost = nil
        self.hotUpdatePort = nil
        return
    end
    local hotUpdateData =  json.decode(jsonData)
    dump(hotUpdateData,"hotUpdateData")
    self.hotUpdateHost = hotUpdateData.ServerIP
    self.hotUpdatePort = hotUpdateData.ServerPort
    return self.hotUpdateHost ~= nil and  self.hotUpdatePort ~= nil
end

function AddressManager:requestGameHttpData()
    local gameGroupName = self:getGroupName()
    local jsonData =  gameUtil.callPlatformFun(PLATFORM_DATA_TYPE.get_game_sheild_data,{groupName = gameGroupName,port = httpConst.port})
    if jsonData == nil then
        self.gameSheildHttpHost = nil
        self.gameSheildHttpPort = nil
        return
    end
    local httpAddrsData =  json.decode(jsonData)
    dump(httpAddrsData,"httpAddrsData")
    self.gameSheildHttpHost = httpAddrsData.ServerIP
    self.gameSheildHttpPort = httpAddrsData.ServerPort
    return self.gameSheildHttpHost ~= nil and  self.gameSheildHttpPort ~= nil
end


function AddressManager:requestShieldSocketData()
    local gameGroupName = self:getGroupName()
    local jsonData =  gameUtil.callPlatformFun(PLATFORM_DATA_TYPE.get_game_sheild_data,{groupName = gameGroupName,port = SocketManager.port})
    if jsonData == nil then
        self.gameSheildSocketHost = nil
        self.gameSheildSocketPort = nil
        return
    end
    local socketAddrsData =  json.decode(jsonData)
    dump(socketAddrsData,"socketAddrsData")
    self.gameSheildSocketHost = socketAddrsData.ServerIP
    self.gameSheildSocketPort = socketAddrsData.ServerPort
    return self.gameSheildSocketHost ~= nil and  self.gameSheildSocketPort ~= nil
end

function AddressManager:resetAdrs()
    self:setHost(domainName)
    self:setSocketPort(SocketManager.port)
    self:setHttpPort(httpConst.port)
end

function AddressManager:resetSocketCount()
    self.__socketConnectFailedCount = 0
end

function AddressManager:resetLoginCount()
    self.__loginFailedCount = 0
end

function AddressManager:resetHttpCount()
    self.__httpConnectFailedCount = 0
end

function AddressManager:addLoginFailedCount()
    if useGameShield then
        return
    end
    self.__loginFailedCount = self.__loginFailedCount + 1
    printInfo(string.format("登录连接失败，次数%s",self.__loginFailedCount))
    if self.curHost ~= domainName or self.__loginFailedCount >= 1 then
        local useSuceess = self:useBakAdrs()
        if useSuceess then
            self.__loginFailedCount = 0
        end
    end
end

function AddressManager:addSocketConnectFailedCount()
    if useGameShield then
        return
    end
    self.__socketConnectFailedCount = self.__socketConnectFailedCount + 1
    printInfo(string.format("socket 连接失败，次数%s",self.__socketConnectFailedCount))
    if self.curHost ~= domainName or self.__socketConnectFailedCount >= 1 then
        local useSuceess = self:useBakAdrs()
        if useSuceess then
            self.__socketConnectFailedCount = 0
        end
    end
end

function AddressManager:addHttpConnectFailedCount()
    if useGameShield then
        return
    end
    self.__httpConnectFailedCount = self.__httpConnectFailedCount + 1
    printInfo(string.format("http 连接失败，次数%s",self.__httpConnectFailedCount))
    if self.curHost ~= domainName or self.__httpConnectFailedCount >= 1 then
        local useSuceess = self:useBakAdrs()
        if useSuceess then
            self.__httpConnectFailedCount = 0
        end
    end
end

function AddressManager:useBakAdrs()
    local gameBakAdrsListLen = #gameBakAdrsList
    if gameBakAdrsListLen == 0 then
        if not self.isRqsDatating then
            self:rqsBakAdrs()
        end
        return false
    else
        self:changeToBakAdrs()
        return true
    end
end

function AddressManager:getGameId()
    local gameId = 0
    if domainName ~= defaultDomainName and domainName ~= defaultDomainName2 then
        gameId = gameId + 10000
    end
    return gameId
end

function AddressManager:rqsBakAdrs()
    printInfo("请求备用地址...")
    gameBakAdrsList = {}
    --checkStatus 应用宝访问境外IP/域名的行为
    if checkStatus or (self.lastRqsTime ~= 0 and os.time() - self.lastRqsTime < 1) then
        return
    end
    self.isRqsDatating = true

    local rqsBakAdrsCallBack = function(code,response)
        self.lastRqsTime = os.time()
        if code == httpConst.reponseCode.success then
            local jsonRes = json.decode(response)
            local resultCode = jsonRes.code
            self.isRqsDatating = false
            if resultCode == RESPONSE_CODE.success then
                self.curRqsFailedTime = 0
                local configs = jsonRes.data.configs
                self:setBakAdrs(configs)
            end
        end
    end
    local gameId = self:getGameId()
    local sendData =
    {
        gameId = gameId
    }
    local params = {["url"] = httpConst.url_defence_ddos_atk_config,
                    ["sendData"] = sendData,
                    ["maxTryTimes"] = 30,
                    ["tryDuration"] = 0.1,
                    ["callBackFunc"] = rqsBakAdrsCallBack,
                    ["sign"] = httpConst.SIGNKEY_DEFENCE_DDOS}
    httpRequestManager:sendRequest(params)
end

function AddressManager:changeToBakAdrs()
    local gameBakAdrsListLen = #gameBakAdrsList
    if self.curBakIndex ~= 0 then
        self.curBakIndex = (self.curBakIndex + 1)
    else
        self.curBakIndex = 1
    end

    if self.curBakIndex > gameBakAdrsListLen then
        gameBakAdrsListLen = {}
        if not self.isRqsDatating then
            self:rqsBakAdrs()
        end
        self.curBakIndex = 0
    end

    if self.curBakIndex == 0 then
        printInfo("尝试使用默认地址")
        self:resetAdrs()
    else
        local curAdrsData = gameBakAdrsList[self.curBakIndex]
        printInfo(string.format("尝试使用备用地址,id:%s",curAdrsData.id))
        self:setHost(curAdrsData.address)
        self:setSocketPort(curAdrsData.socketPort)
        self:setHttpPort(curAdrsData.httpPort)
    end
end

function AddressManager:setHost(host)
    self.curHost = host
end

function AddressManager:setSocketPort(port)
    self.curSocketPort = port
end

function AddressManager:setHttpHost(host)
    self.curHttpHost = host
end

function AddressManager:setHttpPort(port)
    self.curHttpPort = port
end

function AddressManager:setBakAdrs(data)
    gameBakAdrsList = {}
    local gameId = self:getGameId()
    if data then
        for i = 1,#data do
            local tempData = data[i]
            if tempData.gameId == gameId and tempData.type == 1 then
                table.insert(gameBakAdrsList,tempData)
            end
        end
    end
    printInfo("获得备用地址:")
    dump(gameBakAdrsList)
end

function AddressManager:getHost()
    if not useGameShield or self.gameSheildSocketHost == nil then
        return self.curHost
    end
    return self.gameSheildSocketHost
end

function AddressManager:getHttpHost()
    if not useGameShield or self.gameSheildHttpHost == nil then
        return self.curHost
    end
    return self.gameSheildHttpHost
end

function AddressManager:getSocketPort()
    if not useGameShield or self.gameSheildSocketPort == nil then
        return self.curSocketPort
    end
    return self.gameSheildSocketPort
end

function AddressManager:getHttpPort()
    if not useGameShield or self.gameSheildHttpPort == nil then
        return self.curHttpPort
    end
    return self.gameSheildHttpPort
end

function AddressManager:getHotUpdateHost()
    return self.hotUpdateHost
end

function AddressManager:setHotUpdateHost(hotUpdateHost)
    self.hotUpdateHost = hotUpdateHost
end

function AddressManager:getHotUpdatePort()
    return self.hotUpdatePort
end

function AddressManager:setHotUpdatePort(hotUpdatePort)
    self.hotUpdatePort = hotUpdatePort
end

return AddressManager


