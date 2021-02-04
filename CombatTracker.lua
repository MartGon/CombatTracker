
Queue = {}
function Queue:New(o)

	o = o or {}
	setmetatable(o, self);
	self.index = 0;
	self.__index = self
	return o

end

function Queue:Push(value)
	self[self.index] = value
	self.index = self.index + 1
end

function Queue:Pop()
	if self.index <= 0 then return nil end
	
	self.index = self.index - 1;
	local value = self[self.index];
	
	return value;
end

function Queue:Size()
	return self.index;
end

print("Hello from CombatTracker")

local MAX_ICONS = 40;

local CT_index = 0;
local CT_IconPool = Queue:New();
local CT_UnitIcons = {}

local function UpdateIcon(icon)
	
	if icon.unitId and UnitAffectingCombat(icon.unitId) then
		if not icon.t:IsShown() then
			-- print("Showing icon for "..icon.unitId);
			icon.t:Show();
		end
	else
		if icon.t:IsShown() then
			-- print("Hiding icon for "..icon.unitId);
			icon.t:Hide();
		end
	end

end

local function CreateIcon()

	local icon = CreateFrame('Frame', 'CombatTrackerIcon'..CT_index);
	CT_index = CT_index + 1;
	icon:SetScript('OnUpdate', UpdateIcon); 
	icon.t = icon:CreateTexture(nil, BORDER);	
	icon.t:Hide();
	icon.t:SetAllPoints();
	icon.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD");
	
	return icon

end

local function OnNameplateAdded(self, event, unitId)

	local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
	
	if event == 'NAME_PLATE_UNIT_ADDED' then
		-- print("NameplateAdded")
		local icon = CT_IconPool:Pop() or CreateIcon();
		
		icon:SetParent(nameplate);
		--print("Parenting to "..nameplate:GetName())
		icon:SetPoint('TOPLEFT', nameplate, -16, -12);
		icon:SetSize(24, 24);
		icon.unitId = unitId
		
		CT_UnitIcons[unitId] = icon
		
	elseif event =="NAME_PLATE_UNIT_REMOVED" then
		--print("NameplateRemoved");
		icon = CT_UnitIcons[unitId];
		CT_UnitIcons[unitId] = nil;
		CT_IconPool:Push(icon)
	
	end

end

local addon = CreateFrame('Frame', 'CombatTrackerMainFrame')
addon:RegisterEvent("NAME_PLATE_UNIT_ADDED")
addon:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
addon:SetScript('OnEvent', OnNameplateAdded);
addon:Show()