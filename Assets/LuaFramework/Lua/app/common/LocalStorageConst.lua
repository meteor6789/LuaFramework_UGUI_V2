---
--- Created by apple.
--- DateTime: 2017/9/18 下午9:04
---

cc.exports.LocalStorage = LocalStorage or {}

LocalStorage.update =
{
    lastHotUpdateAppVersion = "lastHotUpdateAppVersion"
}

LocalStorage.kouzhao =
{
    share_kouzhao = "share_kouzhao",
    guide_kouzhao_address = "guide_kouzhao_address"
}

LocalStorage.setting =
{
    GameMusicOn = "GameMusicOn",              --背景音乐
    GameEffectOn = "GameEffectOn",             --音效
    forbid_emotion = "forbid_emotion",--屏蔽道具
    forbid_voice = "forbid_voice",--屏蔽语音
    video_volume = "video_volume",--视频开关
    club_desk_mode = "club_desk_mode",--俱乐部牌桌模式
    click_effect_mode = "click_effect_mode",--点击效果模式
    portraitLayoutOn = "portraitLayoutOn",      --游戏中的横竖版模式
    firstInGame = "firstInGame",      --首次进游戏
}

LocalStorage.account =
{
    wxId = "wxUid",
    deviceId = "deviceUId",
    lastLoginId = "lastLoginId_new",
    lastLoginWxTime = "lastLoginWxTime",
    lastLoginVersion = "lastLoginVersionNumber",
    lastLoginType = "lastLoginType",
    sexy = "gender",
    declare_login = "declare_login",
    declare_create_room = "declare_create_room",
    lastGameId = "lastGameId",
    newPlayer = "newPlayer",
    smsLoginId = "smsLoginId",
    loginPhoneNum = "loginPhoneNum",
    provinceId = "cityProvinceId",
    cityAreaId = "cityAreaId",
    countiesAreaId = "countiesAreaId",
    saveCityAreaId = "saveCityAreaId",
}

LocalStorage.recordsSet = {
    records_is_show_name = "records_is_show_name",
    records_is_show_score = "records_is_show_score",
    records_is_show_id = "records_is_show_id",
    records_is_show_partner = "records_is_show_partner",
}

LocalStorage.topMatchRecordsSet = {
    records_is_show_name = "topMatch_records_is_show_name",
    records_is_show_score = "topMatch_records_is_show_score",
    records_is_show_id = "topMatch_records_is_show_id",
    records_is_show_partner = "topMatch_records_is_show_partner",
}

LocalStorage.blessShowSet = {
    flower_show_type = "flower_show_type",
}

LocalStorage.SaasSet = {
    terms_of_service = "terms_of_service",
}
