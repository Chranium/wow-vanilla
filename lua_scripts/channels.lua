local function OnPlayerCommands(evento, jugador, comando)
    jugador:SendAreaTriggerMessage("Mi primer Script en LUA");
end

RegisterPlayerEvent(42, OnPlayerCommands)