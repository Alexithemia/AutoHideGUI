AutoHideGUI = {
    enabled = true,
    lastTick = 0,
}

function AutoHideGUI.Update(_, tickCount)

    -- Check if in-game
    if not (GetGameState() == FFXIV.GAMESTATE.INGAME) then
        return
    end

    -- NYI: too lazy to build GUI right now
    if not AutoHideGUI.enabled then
        return
    end

    -- Throttle calls
    if tickCount - AutoHideGUI.lastTick >= 100 then
        AutoHideGUI.lastTick = tickCount

        local inCutscene = (Player and (Player.onlinestatus == 15 or Player.onlinestatus == 18))
        local inDialogue =
            IsControlOpen("Talk") or          -- NPC speech
            IsControlOpen("SelectString") or  -- dialogue choices
            IsControlOpen("SelectYesno") or   -- yes/no prompts
            IsControlOpen("JournalResult")    -- quest accept/complete

        local inCombat = Player and Player.incombat
        local validDialogue = inDialogue and not inCombat

        local shouldHide = inCutscene or validDialogue

        -- HIDE
        if shouldHide and IsGUIVisible() then
            ToggleGUI()
        end

        -- SHOW
        if not shouldHide and not IsGUIVisible() then
            ToggleGUI()
        end
    end
end


RegisterEventHandler("Gameloop.Update", AutoHideGUI.Update, "[AutoHideGUI] Update")
