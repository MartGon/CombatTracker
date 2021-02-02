
print("Hello from CombatTracker")

local function UpdateIcon(icon)
	
	local nameplate = icon:GetParent();
	local unitId = nameplate:GetName():lower();
	
	if UnitAffectingCombat(unitId) then
		icon.t:Show();
	else
		icon.t:Hide();
	end

end

local function CreateIcons()

	local index = 1;

	-- Create  Icons
	while _G['NamePlate'..index] do
	
		local nameplate = _G['NamePlate'..index];
		
		local icon = _G['CombatTrackerIcon'..index]
		
		if not icon then
			local icon = CreateFrame('Frame', 'CombatTrackerIcon'..index);
			icon:SetScript('OnUpdate', UpdateIcon)
			
			icon.t = icon:CreateTexture(nil, BORDER);			
			print("Generating icon for nameplate "..index)
			
			-- Container
			icon:SetParent(nameplate);
			icon:SetPoint('TOPLEFT', nameplate, -16, -12);
			icon:SetSize(24, 24);
			
			-- Texture
			icon.t:Show();
			icon.t:SetAllPoints();
			icon.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD");
			
		end
		
		index = index + 1
		
	end
	

end

local function IsInCombat(index)

	return UnitAffectingCombat("nameplate"..index)

end

local function GetNumber(nameplate)
	
	local children = { nameplate:GetChildren() }
	for i, child in ipairs(children) do
		
	end
	
end

local function OnUpdate()
	
	CreateIcons();
	
end

local addon = CreateFrame('Frame', 'CombatTrackerMainFrame')
addon:SetScript('OnUpdate', OnUpdate);
addon:Show()