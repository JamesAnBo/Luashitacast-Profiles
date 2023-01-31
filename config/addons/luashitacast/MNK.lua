local profile = {};
gcdisplay = gFunc.LoadFile('common\\gcdisplay.lua');
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gckeybinds = gFunc.LoadFile('common\\gckeybinds.lua');

--[[
	Sets with _Priority allow for level sync options. Gear will be equipped in the order listed if you are of the appropriate level.
	
	Example:
	Tp_Default_Priority = {
		Main = { 'Level 25 Weapon', 'Level 20 Weapon', 'Level 18 Weapon' },
	},
	
	This will equip the level 25 weapon if you are level 25 or higher. If you level sync to 22, the level 20 weapon will be equipped and so on.
]]--

local sets = {
    Idle_Default_Priority = {
	},
    Resting_Priority = {
	},
    Idle_Regen = {
	},
    Idle_Refresh = {
	},
	Idle_Defense = {
	},
    Town = {
    },

    Dt = {
    },

    Tp_Default_Priority = {
    },
    Tp_Hybrid = {
    },
    Tp_Acc = {
    },


    Precast = {
    },

    Preshot = {
    },
    Midshot = {
    },

    Ws_Default = {
    },
    Ws_Hybrid = {
    },
    Ws_Acc = {
    },

    Victory_Default = {
    },
    Victory_Hybrid = {},
    Victory_Acc = {},

    Shijin_Default = {
    },
    Shijin_Hybrid = {},
    Shijin_Acc = {},

    Impetus = {
    },

    TH = {--/th will force this set to equip for 10 seconds
	},
    Movement = {
	},
};
profile.Sets = sets;

local Settings = {
	CurrentLevel = 0; --Leave this at 0
};

profile.Packer = {
    --{Name = 'Chonofuda', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.SetCommands(args);
end

profile.HandleDefault = function()
    local myLevel = AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel();
    if (myLevel ~= Settings.CurrentLevel) then
        gFunc.EvaluateLevels(profile.Sets, myLevel);
        Settings.CurrentLevel = myLevel;
    end
	
    gFunc.EquipSet(sets.Idle_Default);
    local impetus = gData.GetBuffCount('Impetus');
	
    local player = gData.GetPlayer();

    if (gcdisplay.GetCycle('IdleSet') ~= 'Default') then gFunc.EquipSet('Idle_' .. gcdisplay.GetCycle('IdleSet')) end;
    
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default);
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
        if (impetus >= 1) then gFunc.EquipSet(sets.Impetus) end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if string.match(ability.Name, 'Provoke') then gFunc.EquipSet(sets.Enmity) end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast);

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet')) end

	    if string.match(ws.Name, 'Victory Smite') then
            gFunc.EquipSet(sets.Victory_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Victory_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Shijin Spiral') then
            gFunc.EquipSet(sets.Shijin_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Shijin_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;
