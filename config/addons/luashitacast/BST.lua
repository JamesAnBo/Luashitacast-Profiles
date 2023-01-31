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
    Pet_Dt = {
	},
	
	Tp_Default_Priority = {
    },
	Tp_Hybrid = {
    },
	Tp_Acc = {
    },
    Pet_Only_Tp = {
    },

    Precast = {
    },

    Enhancing = {
    },
    Phalanx = {
    },
    Stoneskin = {
    },
    Refresh = {
    },

    Cure = {
    },

    Enfeebling = {
    },

	Ws_Default = {
    },
    Ws_Hybrid = {
    },
    Ws_Acc = {
    },
    Aedge_Default = {
    },
    Aedge_Hybrid = {
    },
    Aedge_Acc = {
    },
	
	Call = {
	},
	Reward = {
		Ammo = 'Pet Food Theta',
	},
    Killer = {
	},
    Spur = {
	},
    Ready = {
	},
	PetReadyDefault = {
	},
	PetAttack = {},
	PetMagicAttack = {},
	PetMagicAccuracy = {},
	
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
    {Name = 'Pet Food Alpha', Quantity = 'all'},
    {Name = 'Fish Broth', Quantity = 'all'},
};

local function HandlePetAction(PetAction)
    gFunc.EquipSet(sets.PetReadyDefault);

	if (gcinclude.BstPetAttack:contains(PetAction.Name)) then
        gFunc.EquipSet(sets.PetAttack);
	elseif (gcinclude.BstPetMagicAttack:contains(PetAction.Name)) then
        gFunc.EquipSet(sets.PetMagicAttack);
	elseif (gcinclude.BstPetMagicAccuracy:contains(PetAction.Name)) then
        gFunc.EquipSet(sets.PetMagicAccuracy);
    end
end

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();
	
    gcinclude.settings.RefreshGearMPP = 50;
	
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
	
    local pet = gData.GetPet();
	local petAction = gData.GetPetAction();
    if (petAction ~= nil) then
        HandlePetAction(petAction);
        return;
    end
	
	local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet'));
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (pet ~= nil) and (player.Status == 'Engaged') and (pet.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Hybrid);
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (pet ~= nil and pet.Status == 'Engaged') then
        gFunc.EquipSet(sets.Pet_Only_Tp);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
		ggFunc.EquipSet(sets.Idle_Default);
		if (gcdisplay.GetCycle('IdleSet') ~= 'Default') then gFunc.EquipSet('Idle_' .. gcdisplay.GetCycle('IdleSet')) end;
    end
	
	if (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
	end
	
	gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then
		gFunc.EquipSet(sets.Dt);
        if (pet ~= nil) and (pet.HPP < 60) then
            gFunc.EquipSet(sets.Pet_Dt);
		end
	end
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    if (pet ~= nil) then 
        if (player.Status == 'Engaged') and (pet.Status ~= 'Engaged') then
            AshitaCore:GetChatManager():QueueCommand(1, '/ja "Fight" <t>');
        end
    end
end

profile.HandleAbility = function()
	local ability = gData.GetAction();
	if string.match(ability.Name, 'Call Beast') or string.match(ability.Name, 'Bestial Loyalty') then
		gFunc.EquipSet(sets.Call);
	elseif string.match(ability.Name, 'Reward') then
		gFunc.EquipSet(sets.Reward);
    elseif string.match(ability.Type, 'Killer Instinct') then
		gFunc.EquipSet(sets.Killer);
    elseif string.match(ability.Type, 'Spur') then
		gFunc.EquipSet(sets.Spur);
    elseif string.match(ability.Type, 'Ready') then
		gFunc.EquipSet(sets.Ready);
	end

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
    local player = gData.GetPlayer();
    local spell = gData.GetAction();

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);

        if string.match(spell.Name, 'Phalanx') then
            gFunc.EquipSet(sets.Phalanx);
        elseif string.match(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        elseif string.contains(spell.Name, 'Refresh') then
            gFunc.EquipSet(sets.Refresh);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
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

        if string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.Aedge_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Aedge_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;