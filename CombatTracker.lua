
Queue = {}
function Queue.New()

	return {index = 1}

end

function Queue.Push(list, value)
	list[list.index] = value
	list.index = list.index + 1
end

function Queue.Pop(list)
	if list.index <= 0 then return nil end
	
	list.index = list.index - 1;
	local value = list[list.index];
	
	return value;
end

function Queue.Size(list)

	return list.index;

end

print("Hello from CombatTracker")

local MAX_ICONS = 40;

local CT_icons = Queue.New();

local function UpdateIcon(icon)
	
	if icon.unitId and UnitAffectingCombat(icon.unitId) then
		if not icon.t:IsShown() then
			print("Showing icon for "..icon.unitId);
			icon.t:Show();
		end
	else
		if icon.t:IsShown() then
			print("Hiding icon for "..icon.unitId);
			icon.t:Hide();
		end
	end

end

local function OnHide(icon)
	print(icon:GetName().." is now hidden");
	icon:SetParent(nil);
	Queue.Push(CT_icons, icon)
end

local function CreateIcons()

	local index = 1;

	-- Create  Icons
	while Queue.Size(CT_icons) < MAX_ICONS do
		
		if not icon then
			local icon = CreateFrame('Frame', 'CombatTrackerIcon'..index);
			icon:SetScript('OnUpdate', UpdateIcon); 
			icon:SetScript('OnHide', OnHide); 
			icon.t = icon:CreateTexture(nil, BORDER);	
			icon.t:Hide();
			icon.t:SetAllPoints();
			icon.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD");
			
			Queue.Push(CT_icons, icon)
		end
		
		index = index + 1
		
	end
	

end

local function OnUpdate()
	
	CreateIcons();
	
end

local function OnNameplateAdded(self, event, unitId)

	
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
	
	if event == 'NAME_PLATE_UNIT_ADDED' then
		print("NameplateAdded")
		local icon = Queue.Pop(CT_icons)
		
		if icon then
			icon:SetParent(nameplate);
			print("Parenting to "..nameplate:GetName())
			icon:SetPoint('TOPLEFT', nameplate, -16, -12);
			icon:SetSize(24, 24);
			icon.unitId = unitId
		else 
			print("Icon didn't exist for unit "..unitId);
		end
	elseif event =="NAME_PLATE_UNIT_REMOVED" then
		print("NameplateRemoved");
		
		local icon = nameplate:GetChildren();
		if icon then
			
		else
			print("Icon was nil");
		
		end
		
	
	end

end

local addon = CreateFrame('Frame', 'CombatTrackerMainFrame')
addon:RegisterEvent("NAME_PLATE_UNIT_ADDED")
addon:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
addon:SetScript('OnUpdate', CreateIcons);
addon:SetScript('OnEvent', OnNameplateAdded);
addon:Show()