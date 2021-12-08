---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by loon.
--- DateTime: 2019-10-08 14:04
---
local HttpRequestManager = class("HttpRequestManager")
package.loaded["app.net.HttpRequest"] = nil
local httpRequest = require("app.net.HttpRequest")
function HttpRequestManager:ator()

end

function HttpRequestManager:sendRequest(params)
    local rqs = httpRequest.new()
    rqs:request(params)
end

--获取游戏服务器http请求全地址
function HttpRequestManager:getFullUrl(url)
    local host = AddressManager:getHttpHost()
    local port = AddressManager:getHttpPort()
    return string.format("http://%s:%s/%s",host,port,url)
end

function HttpRequestManager:getUrlByGameName(url)
    return string.format(url,gameAreaName)
end

--获取后台服务器http请求全地址
function HttpRequestManager:getSocialFullUrl(url)
    return string.format("http://%s/%s",httpDomainName,url)
end

function HttpRequestManager:getProxyFullUrl(url)
    return string.format("http://%s/%s",httpProxyDomainName,url)

end

function HttpRequestManager:getVoiceFullUrl(url)
    return string.format("http://%s/%s",httpVoiceDomainName,url)
end

--获取口罩服务器http请求全地址
function HttpRequestManager:getKouZhaoUrl(url)
    return string.format("http://%s:8091/%s",httpKouZhaoDomainName,url)
end

--获取Saas Http请求全地址
function HttpRequestManager:getSaasUrl(url)
    return string.format("http://%s/%s",httpSAASName,url)
end
--获取春节活动请求地址
function HttpRequestManager:getTsfUrl(url)
    return string.format("http://%s:8093/%s", "activity-collectcard.qixiyx.cn", url)
end

-- 获取俱乐部签名图片上传 请求全地址
function HttpRequestManager:getClubSignUploadUrl(url)
    return string.format("http://%s:%s/%s", httpClubSignDomainName, httpClubSignUploadPort, url)
end

-- 获取俱乐部签名协议图片下载 请求全地址
function HttpRequestManager:getClubSignImageViewDownloadUrl(url)
    return string.format("http://%s:%s/%s", httpClubSignDomainName, httpClubSignImageViewDownloadUrlPort, url)
end

return HttpRequestManager