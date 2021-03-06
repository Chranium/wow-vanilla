local PLAYER_EVENT_ON_LOGIN = 3
local PLAYER_EVENT_ON_CHANNEL_CHAT = 22

local channelName = "Lithium"
local channelId = 1
local duration = 5 -- in seconds
local WorldChannelChat = {}

local colors = { -- colors for names and misc
    [0] = "|cff3399FF", -- Color for Alliance Name
    [1] = "|cffE91E63", -- Color for Horde Name
    [2] = "|cffFFC0C0", -- Color for Normal Chat
    [3] = "|cffE91E63", -- Color for Bad Response
    [4] = "|cff7030A0", -- Color for GM level 1: Moderator
    [5] = "|cffCC00FF", -- Color for GM level 2: Gamemaster
    [6] = "|cffF400A1" -- Color for GM level 3: Administrator
}

local gmRank = {
    [0] = "jugador",
    [1] = "moderador",
    [2] = "GM",
    [3] = "admin"
}

local function Login(event, player)
    player:SendBroadcastMessage("Usa /join Lithium para unirte al Chat Global, usa /4 para conversar.")
end

local function ChatSystem(event, player, msg, Type, lang, channel)
    local id = player:GetGUIDLow()

    if not (WorldChannelChat[id]) then
        WorldChannelChat[id] = {
            time = GetGameTime() - duration,
            lastMessage = "",
            isGmEnabled = false
        }
    end

    if (channel == channelId) then
        if (lang ~= -1) then
            if (msg ~= "") then
                if (msg ~= "Away") then
                    if (player:GetGMRank() > 0 and WorldChannelChat[id].isGmEnabled) then
                        if (msg == ".gm off") then
                            WorldChannelChat[id].isGmEnabled = false
                            player:SendBroadcastMessage("Modo GM en Canal Global desactivado.")
                        elseif (string.sub(msg, 1, 1) == ".") then
                            player:SendBroadcastMessage("Estás en canal global, no te deja usar comandos GM.")
                        else
                            local t = table.concat {colors[player:GetGMRank() + 3], "[", channelName, "][",
                                                    player:GetName(), "][", gmRank[player:GetGMRank()], "]: ", msg, "|r"}
                            SendWorldMessage(t)
                        end
                    else
                        if (player:GetGMRank() > 0 and msg == ".gm on") then
                            WorldChannelChat[id].isGmEnabled = true
                            player:SendBroadcastMessage("Modo GM en Canal Global activado.");
                            return false
                        end

                        local time = GetGameTime()
                        if (msg ~= WorldChannelChat[id].lastMessage) then
                            if ((time - WorldChannelChat[id].time >= duration)) then
                                local t = table.concat {colors[2], "[", channelName, "]|r", colors[player:GetTeam()],
                                                        "[", "|Hplayer:", player:GetName(), "|h", player:GetName(),
                                                        "|h][", player:GetLevel(), "]|r", colors[2], ": ", msg, "|r"}
                                SendWorldMessage(t)
                                WorldChannelChat[id].time = time
                                WorldChannelChat[id].lastMessage = msg
                            else
                                player:SendBroadcastMessage(colors[6] ..
                                                                "Se activó el temporizador de spam para el chat global.|r")
                            end
                        else
                            player:SendBroadcastMessage(colors[6] .. "Se detectó spam en el chat global.|r")
                        end
                    end
                end
            end
        end
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, Login)
RegisterPlayerEvent(PLAYER_EVENT_ON_CHANNEL_CHAT, ChatSystem)
print("Lithium Chat Channel loaded.")