---
--- Created by apple.
--- DateTime: 2017/10/20 下午7:18
---
Base64 = {}
local string = string

Base64.__code = {
    'p','q','a','b','c','d','e','A','B','C','D','E','F','G','H','I','J','K','L',
    'k','l','m','M','N','O','P','Q','R','S','3','4','T','U','V','W','X','8',
    'Y','Z','f','g','h','i','j','n','o','r','+','s','t','u','v','w','x','y',
    'z','0','1','2','5','6','7','9','/'
};
Base64.__decode = {}
Base64.__decode_char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

for k,v in pairs(Base64.__code) do
    --Base64.__decode_char = Base64.__decode_char..tostring(v)
    Base64.__decode[string.byte(v,1)] = k - 1
end

function Base64.encode(text)
    local len = string.len(text)
    local left = len % 3
    len = len - left
    local res = {}
    local index  = 1
    for i = 1, len, 3 do
        local a = string.byte(text, i )
        local b = string.byte(text, i + 1)
        local c = string.byte(text, i + 2)
        -- num = a<<16 + b<<8 + c
        local num = a * 65536 + b * 256 + c
        for j = 1, 4 do
            --tmp = num >> ((4 -j) * 6)
            local tmp = math.floor(num / (2 ^ ((4-j) * 6)))
            --curPos = tmp&0x3f
            local curPos = tmp % 64 + 1
            res[index] = Base64.__code[curPos]
            index = index + 1
        end
    end

    if left == 1 then
        Base64.__left1(res, index, text, len)
    elseif left == 2 then
        Base64.__left2(res, index, text, len)
    end
    return table.concat(res)
end

function Base64.__left2(res, index, text, len)
    local num1 = string.byte(text, len + 1)
    num1 = num1 * 1024 --lshift 10
    local num2 = string.byte(text, len + 2)
    num2 = num2 * 4 --lshift 2
    local num = num1 + num2

    local tmp1 = math.floor(num / 4096) --rShift 12
    local curPos = tmp1 % 64 + 1
    res[index] = Base64.__code[curPos]

    local tmp2 = math.floor(num / 64)
    curPos = tmp2 % 64 + 1
    res[index + 1] = Base64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 2] = Base64.__code[curPos]

    res[index + 3] = "="
end

function Base64.__left1(res, index,text, len)
    local num = string.byte(text, len + 1)
    num = num * 16

    tmp = math.floor(num / 64)
    local curPos = tmp % 64 + 1
    res[index ] = Base64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 1] = Base64.__code[curPos]

    res[index + 2] = "="
    res[index + 3] = "="
end

function Base64.decode(text)
    local len = string.len(text)
    local left = 0
    if string.sub(text, len - 1) == "==" then
        left = 2
        len = len - 4
    elseif string.sub(text, len) == "=" then
        left = 1
        len = len - 4
    end

    local res = {}
    local index = 1
    local decode = Base64.__decode
    for i =1, len, 4 do
        local a = decode[string.byte(text,i    )]
        local b = decode[string.byte(text,i + 1)]
        local c = decode[string.byte(text,i + 2)]
        local d = decode[string.byte(text,i + 3)]

        --num = a<<18 + b<<12 + c<<6 + d
        if a == nil or b == nil or c == nil or d == nil then
            -- break
            --__G__TRACKBACK__(text)
            --if device.platform == "android" then
            --    print("callJavaFunction")
            --    local sigs = "(Ljava/lang/String;)V"
            --    local luaj = require "cocos.cocos2d.luaj"
            --    local className = "com/tljm110/third/ThirdSDK"
            --    local msg = string.format("recvBuffer:%s",text)
            --    local ok,ret = luaj.callStaticMethod(className, "reportError", {msg}, sigs)
            if domainName ~= defaultDomainName and domainName ~= defaultDomainName2 then
                local params =
                {
                    errorInfo = text,
                    channel = getChannelName(),
                    platform = device.platform
                }
                ProtocalSender:sendAppData(PROTOCOL_AREA.HALL,PROTOCOL_CMD_APP.error_msg_push_ios,params)
            end
            return false
        end
        local num = a * 262144 + b * 4096 + c * 64 + d

        local e = string.char(num % 256)
        num = math.floor(num / 256)
        local f = string.char(num % 256)
        num = math.floor(num / 256)
        res[index ] = string.char(num % 256)
        res[index + 1] = f
        res[index + 2] = e
        index = index + 3
    end

    if left == 1 then
        Base64.__decodeLeft1(res, index, text, len)
    elseif left == 2 then
        Base64.__decodeLeft2(res, index, text, len)
    end
    return table.concat(res)
end

function Base64.__decodeLeft1(res, index, text, len)
    local decode = Base64.__decode
    local a = decode[string.byte(text, len + 1)]
    local b = decode[string.byte(text, len + 2)]
    local c = decode[string.byte(text, len + 3)]
    local num = a * 4096 + b * 64 + c

    local num1 = math.floor(num / 1024) % 256
    local num2 = math.floor(num / 4) % 256
    res[index] = string.char(num1)
    res[index + 1] = string.char(num2)
end

function Base64.__decodeLeft2(res, index, text, len)
    local decode = Base64.__decode
    local a = decode[string.byte(text, len + 1)]
    local b = decode[string.byte(text, len + 2)]
    local num = a * 64 + b
    num = math.floor(num / 16)
    res[index] = string.char(num)
end

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function Base64.enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function Base64.decode_binary(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end