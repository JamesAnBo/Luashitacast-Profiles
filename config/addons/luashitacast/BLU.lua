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

    Evasion = {
    },
	
	Dt = {
	},
	
	Tp_Default = {
    },
	Tp_Hybrid = {
    },
	Tp_Acc = {
    },
	
	Precast = {
    },
    Stoneskin_Precast = {
        Waist = 'Siegel Sash',
    },

    Cure = {--I cap is 50, II cap is 30
    },
    WhiteWind = {--HP+ go!
    },
    BluSkill = {
    },
    BluMagical = {
    },
    BluDark = {
    },
    BluMagicAccuracy = {
    },
    CJmid = {--same as macc set but with weapons since in CJmode we idle in eva swords
    },
    BluStun = {
    },
    BluPhysical = {
    },
    CMP = {
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
    Chant_Default = {
    },
    Chant_Hybrid = {
    },
    Chant_Acc = {
    },
    Savage_Default = {
    },
    Savage_Hybrid = {
    },
    Savage_Acc = {
    },
    Expiacion_Default = {
    },
    Expiacion_Hybrid = {
    },
    Expiacion_Acc = {
    },
    Requiescat_Default = {
    },
    Requiescat_Hybrid = {
    },
    Requiescat_Acc = {
    },
	
    Ca = {
    },
    Ba = {
    },
    Diffusion = {
    },

    Enmity = {
    },

    TH = {
	},
    Salvage = {
	},
	Movement = {
	},
};
profile.Sets = sets;

local Settings = {
	CurrentLevel = 0; --Leave this at 0
};

profile.Packer = {
    {Name = 'Tropical Crepe', Quantity = 'all'},
    {Name = 'Rolan. Daifuku', Quantity = 'all'},
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
	
    local zone = gData.GetEnvironment();
	local player = gData.GetPlayer();
	if (gcdisplay.GetCycle('IdleSet') ~= 'Default') then gFunc.EquipSet('Idle_' .. gcdisplay.GetCycle('IdleSet')) end;
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
			gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (gcdisplay.GetToggle('CJmode') == true) then
		gFunc.EquipSet(sets.Evasion);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    if (gcdisplay.GetToggle('CJmode') ~= true) then
        gcinclude.CheckDefault ();
    end
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    --lazy equip weapons for salvage runs
    if (zone.Area:contains('Remnants')) then
        gFunc.EquipSet(sets.Salvage);
    end
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

    if string.contains(spell.Name, 'Stoneskin') then
        gFunc.EquipSet(sets.Stoneskin_Precast);
    end 

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local diff = gData.GetBuffCount('Diffusion');
    local ca = gData.GetBuffCount('Chain Affinity');
    local ba = gData.GetBuffCount('Burst Affinity');
    local spell = gData.GetAction();

    gFunc.EquipSet(sets.BluMagical);
    if (gcinclude.BluMagDebuff:contains(spell.Name)) then gFunc.EquipSet(sets.BluMagicAccuracy)
    elseif (gcinclude.BluMagStun:contains(spell.Name)) then gFunc.EquipSet(sets.BluStun);
    elseif (gcinclude.BluMagBuff:contains(spell.Name)) then gFunc.EquipSet(sets.CMP);
    elseif (gcinclude.BluMagSkill:contains(spell.Name)) then gFunc.EquipSet(sets.BluSkill);
    elseif (gcinclude.BluMagCure:contains(spell.Name)) then gFunc.EquipSet(sets.Cure);
    elseif (gcinclude.BluMagEnmity:contains(spell.Name)) then gFunc.EquipSet(sets.Enmity);
    elseif string.match(spell.Name, 'White Wind') then gFunc.EquipSet(sets.WhiteWind);
    elseif string.match(spell.Name, 'Evryone. Grudge') or string.match(spell.Name, 'Tenebral Crush') then gFunc.EquipSet(sets.BluDark);
    end

    if (ca>=1) then gFunc.EquipSet(sets.Ca) end
    if (ba>=1) then gFunc.EquipSet(sets.Ba) end
    if (diff>=1) then gFunc.EquipSet(sets.Diffusion) end
    
    if (gcdisplay.GetToggle('CJmode') == true) then
        gFunc.EquipSet(sets.CJmid);
    end

    if (gcinclude.BluMagTH:contains(spell.Name)) and (gcdisplay.GetToggle('TH') == true) then
        gFunc.EquipSet(sets.TH);
    end
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
   
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.Chant_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Chant_' .. gcdisplay.GetCycle('MeleeSet')) end
	    elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')) end
        elseif string.match(ws.Name, 'Expiacion') then
            gFunc.EquipSet(sets.Expiacion_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Expiacion_' .. gcdisplay.GetCycle('MeleeSet')) end
        elseif string.match(ws.Name, 'Requiescat') then
            gFunc.EquipSet(sets.Requiescat_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Requiescat_' .. gcdisplay.GetCycle('MeleeSet')) end
        end
    end
end

return profile;