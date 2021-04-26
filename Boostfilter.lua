Boostfilter = {}

Boostfilter.Channels = {
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_YELL",
    "CHAT_MSG_SAY",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_DND",
    "CHAT_MSG_AFK",
}

Boostfilter.Enabled = true
BoostfilterIsEnabledBool = true

local filters = {
    ".*wts.*boost",
    ".*wts.*buffs",
    ".*dmt.*buffs",
    ".*sm.*boost",
    ".*boost.*sm.*",
    ".*mara.*boost",
    ".*wts.*dmt"
}

local function spamFilter(frame, event, message, sender, ...)
    local res = false
    for f=1, #filters do
        if string.find(message:lower(),filters[f]) ~= nil then
            res = true
            break
        end
    end
    return res, message, sender, ...
end

function Boostfilter:IsEnabled()
    local enabledStr = "enabled"
    if Boostfilter.Enabled == false then
        enabledStr = "disabled"
    end
    return enabledStr
end

function Boostfilter:Init()
    print("Boostfilter initialized. SpamFilter is "..Boostfilter:IsEnabled())
    print("Type '/boostfilter toggle' or '/bf toggle' to toggle")
    if Boostfilter.Enabled then
        Boostfilter:RegisterChannels()
    end
end

function Boostfilter:RegisterChannels()
    for i=1, #Boostfilter.Channels do
        ChatFrame_AddMessageEventFilter(Boostfilter.Channels[i], spamFilter)
    end
end

function Boostfilter:UnregisterChannels()
    for i=1, #Boostfilter.Channels do
        ChatFrame_RemoveMessageEventFilter(Boostfilter.Channels[i], spamFilter)
    end
end

function Boostfilter:Toggle()
    if Boostfilter.Enabled == true then
        print("Boostfilter: disabling spam-filter")
        Boostfilter.Enabled = false
        Boostfilter:UnregisterChannels()
    else
        print("Boostfilter: enabling spam-filter")
        Boostfilter.Enabled = true
        Boostfilter:RegisterChannels()
    end
end

SLASH_BOOSTFILTER1 = "/boostfilter"
SLASH_BOOSTFILTER2 = "/bf"
function SlashCmdList.BOOSTFILTER(cmd)
    if cmd:lower() == "toggle" then
        Boostfilter:Toggle()
    end
end

local function OnLoad(self, event, addonName, ...)
    if event == "ADDON_LOADED" and addonName == "Boostfilter" then
        Boostfilter.Enabled = BoostfilterIsEnabledBool
        Boostfilter:Init()
    elseif event == "PLAYER_LEAVING_WORLD" then
        BoostfilterIsEnabledBool = Boostfilter.Enabled
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:SetScript("OnEvent", OnLoad)