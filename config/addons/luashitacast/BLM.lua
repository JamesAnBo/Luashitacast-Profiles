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
    Idle_Staff = {
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
    Cure_Precast = {
    },
    Enhancing_Precast = {
    },
    Stoneskin_Precast = {
    },


    Cure = {--I cap is 50, II cap is 30
    },
    Self_Cure = {--cap 30
    },
    Regen = {
    },
    Cursna = {
    },

    Enhancing = {
    },
    Self_Enhancing = {},
    Skill_Enhancing = {},
    Stoneskin = {
    },
    Phalanx = {},
    Refresh = {
    },
    Self_Refresh = {},

    Enfeebling = {
    },
    Macc = {
    },

    Drain = {
    },

    Nuke = {
    },
    NukeACC = {
    },
    Burst = {
    },
    Helix = {
    },
    Death = {
    },
    Af_Body = {Body = ''},
    EmpyLegs = {Legs =''},

    Preshot = {
    },
    Midshot = {
    },

    Ws_Default = {--myrkr mostly
    },
    Ws_Hybrid = {
    },
    Ws_Acc = {
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
    {Name = 'Apple Pie', Quantity = 'all'},
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
	
    local player = gData.GetPlayer();

    if (gcdisplay.GetToggle('Death') == true) and (player.MPP > 50) then
        gFunc.EquipSet(sets.Death);
        return;
    end

    gFunc.EquipSet(sets.Idle_Default);
	
	if (gcdisplay.GetCycle('IdleSet') ~= 'Default') then gFunc.EquipSet('Idle_' .. gcdisplay.GetCycle('IdleSet')) end;

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetCycle('Weapon') == 'Staff') then
        gFunc.EquipSet(sets.Idle_Staff);
    end
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();

    if (gcdisplay.GetToggle('Death') == true) then
        gFunc.EquipSet(sets.Death);
    else
        gFunc.EquipSet(sets.Precast)

        if (spell.Skill == 'Enhancing Magic') then
            gFunc.EquipSet(sets.Enhancing_Precast);

            if string.contains(spell.Name, 'Stoneskin') then
                gFunc.EquipSet(sets.Stoneskin_Precast);
            end
        elseif (spell.Skill == 'Healing Magic') then
            gFunc.EquipSet(sets.Cure_Precast);
        end

        gcinclude.CheckCancels();
        if (gcdisplay.GetCycle('Weapon') == 'Staff') then
            gFunc.EquipSet(sets.Idle_Staff);
        end
    end
end

profile.HandleMidcast = function()
    local player = gData.GetPlayer();
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    local mw = gData.GetBuffCount('Manawell');

    if (gcdisplay.GetToggle('Death') == true) then
        gFunc.EquipSet(sets.Death);
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    else
        if (spell.Skill == 'Enhancing Magic') then
            gFunc.EquipSet(sets.Enhancing);
            if (target.Name == me) then
                gFunc.EquipSet(sets.Self_Enhancing);
            end

            if string.match(spell.Name, 'Phalanx') then
                gFunc.EquipSet(sets.Phalanx);
            elseif string.match(spell.Name, 'Stoneskin') then
                gFunc.EquipSet(sets.Stoneskin);
            elseif string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
            elseif string.contains(spell.Name, 'Refresh') then
                gFunc.EquipSet(sets.Refresh);
                if (target.Name == me) then
                    gFunc.EquipSet(sets.Self_Refresh);
                end
            end
        elseif (spell.Skill == 'Healing Magic') then
            gFunc.EquipSet(sets.Cure);
            if (target.Name == me) then
                gFunc.EquipSet(sets.Self_Cure);
            end
            if string.match(spell.Name, 'Cursna') then
                gFunc.EquipSet(sets.Cursna);
            end
        elseif (spell.Skill == 'Elemental Magic') then
            gFunc.EquipSet(sets.Nuke);

            if (gcdisplay.GetCycle('NukeSet') == 'Macc') then
                gFunc.EquipSet(sets.NukeACC);
            end
            if (gcdisplay.GetToggle('Burst') == true) then
                gFunc.EquipSet(sets.Burst);
            end
            if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
                gFunc.Equip('Waist', 'Hachirin-no-Obi');
            end
            if string.match(spell.Name, 'helix') then
                gFunc.EquipSet(sets.Helix);
                if (gcdisplay.GetToggle('Burst') == true) then
                    gFunc.EquipSet(sets.Burst);
                end
            end
            if (player.MPP <= 40) and (mw == 0) then
                gFunc.EquipSet(sets.Af_Body);
            end
            if string.contains(spell.Name, 'ja') then
                gFunc.EquipSet(sets.EmpyLegs);
            end
        elseif (spell.Skill == 'Enfeebling Magic') then
            gFunc.EquipSet(sets.Enfeebling);
            if (gcdisplay.GetCycle('NukeSet') == 'Macc') then
                gFunc.EquipSet(sets.Macc);
            end
        elseif (spell.Skill == 'Dark Magic') then
            gFunc.EquipSet(sets.Macc);
            if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
                gFunc.EquipSet(sets.Drain);
            end
        end

        if (gcdisplay.GetCycle('Weapon') == 'Staff') then
            gFunc.EquipSet(sets.Idle_Staff);
        end
    end
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
   
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.Chant_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Chant_' .. gcdisplay.GetCycle('MeleeSet')); end
	    elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;
