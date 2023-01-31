local gckeybinds = T{};

--[[
[Custom commands below]

/gcmessages		-Toggle messages on and off
/wsdistance		-Toggle block on ws when out of range
/dt				-Toggle damage taken set (fulltime)
/th				-Toggle treasure hunter set (combines with TP set)
/kite			-Equip movement set (fulltime)
/meleeset		-Cycles melee sets
/idleset		-Cycles idle sets
/gcdrain		-Cast your highest tier Drain spell
/gcaspir		-Cast your highest tier Aspir spell
/nukeset		-(RDM BLM SCH GEO) Cycles nuke sets 
/burst			-(RDM BLM SCH GEO) Toggles magic burst set 
/weapon			-(BLM SCH) Cycles between club or staff 
/elecycle		-(BLM SCH) Cycles element
/helix			-(BLM SCH) Cast helix spell of chosen element (/elecycle)
/weather		-(BLM SCH) Cast weather spell of chosen element (/elecycle)
/nuke			-(RDM BLM SCH GEO) Cast your highest tier spell of chosen element (/elecycle)
/death			-(BLM) Toggle Death spell set 
/fight			-(RDM BRD GEO WHM) Locks mage weapon/ammo 
/sir			-(PLD RUN) Spell interupt down set 
/tankset		-(PLD RUN) Toggle tank set
/proc			-(SAM NIN) Toggle low damage proc set
/cj				-(BLU) Toggle cruel joke mode
/pupmode		-(PUP) Toggle puppet mode
/tpgun			-(COR) Toggle TP gun mode
/cormsg			-(COR) Toggle roll messages
/forcestring	-(BRD) Toggle forced harp mode
/siphon			-(SMN) Release current avatar > summon weather appropriate elemental > siphon > resummon original avatar
/warpring		-Equip Warp Ring and use it
/telering		-Equip chosen tele ring and use it
/xpring			-Equip chosen xp ring
/rrset			-Equip reraise set
/craftset		-Equip crafing set
/zeniset		-Equip zeni set
/fishset 		-Equip fishing set
/helmset		-Equip gathering set
/disable		-Disables automatic gear swaps for all slots

 KEY BINDS
 ! - Represents ALT key must be pressed with the keybind.
 ^ - Represents CTRL key must be pressed with the keybind.
 @ - Represents Windows key must be pressed with the keybind.
 # - Represents Apps key must be pressed with the keybind.
 + - Represents Shift key must be pressed with the keybind.
]]--

function gckeybinds.SetKeybinds()
	local player = gData.GetPlayer();
	
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F1 /idleset');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F2 /meleeset');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F3 /th');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F4 /dt');
	
	--Example of some job specific keybinds:
	
	if (player.MainJob == 'RDM') or (player.MainJob == 'BLM') or (player.MainJob == 'SCH') or (player.MainJob == 'GEO') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F5 /nukeset');
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F6 /burst');
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F7 /nuke');
		if (player.MainJob == 'BLM') or (player.MainJob == 'SCH') then
			AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F5 /weapon');
			AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F6 /helix');
			AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F7 /weather');
			AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F8 /elecycle');
			if (player.MainJob == 'BLM') then
				AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F9 /death');
			end
		end
	elseif (player.MainJob == 'PLD') or (player.MainJob == 'RUN') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F5 /tankset');
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F6 /sir');
	elseif (player.MainJob == 'SMN') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F5 /siphon');
	end
	if (player.MainJob == 'RDM') or (player.MainJob == 'WHM') or (player.MainJob == 'BRD') or (player.MainJob == 'GEO') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F12 /fight');
	end
		
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F8 /fillmode');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F9 /craftset');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F10 /fishset');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F11 /helmset');
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^F12 /xpring');
	
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F1 /disable');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F2 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F3 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F4 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F5 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F6 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F7 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F8 /meleeset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F9 /craftset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F10 /fishset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F11 /helmset');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/bind !F12 /xpring');
end

function gckeybinds.ClearKeybinds()
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F1');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F2');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F3');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F4');
	
	if (player.MainJob == 'RDM') or (player.MainJob == 'BLM') or (player.MainJob == 'SCH') or (player.MainJob == 'GEO') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F5');
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F6');
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F7');
		if (player.MainJob == 'BLM') or (player.MainJob == 'SCH') then
			AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F5');
			AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F6');
			AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F7');
			AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F8');
			if (player.MainJob == 'BLM') then
				AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F9');
			end
		end
	elseif (player.MainJob == 'PLD') or (player.MainJob == 'RUN') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F5');
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F6');
	elseif (player.MainJob == 'SMN') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F5');
	end
	if (player.MainJob == 'RDM') or (player.MainJob == 'WHM') or (player.MainJob == 'BRD') or (player.MainJob == 'GEO') then
		AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F12');
	end
	
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F5');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F6');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F7');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F8');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F9');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F10');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F11');
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^F12');
	
	AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F1');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F2');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F3');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F4');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F5');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F6');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F7');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F8');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F9');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F10');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F11');
	-- AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !F12');
end

return gckeybinds;