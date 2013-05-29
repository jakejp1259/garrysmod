--[[
	~ Fading Door STool ~
	~ Based on Conna's, but this time it works. ~
	~ Lexi ~
	~ Further fixed by Dellkan of SammyServers. Removed Wire bullshit not used on our server, added other security fixes we required ~
--]]
if SERVER then AddCSLuaFile() end
--[[ Tool Related Settings ]]--
TOOL.Category = "Construction - SS"
TOOL.Name = "#Fading Doors"

TOOL.ClientConVar["key"] = "5"
TOOL.ClientConVar["toggle"] = "0"
TOOL.ClientConVar["reversed"] = "0"

local FadingCheckEmInputs = {"Toggle fade"}
if (CLIENT) then
	usermessage.Hook("FadingDoorCreated", function()
		GAMEMODE:AddNotify("Fading door has been created!", NOTIFY_GENERIC, 10)
		surface.PlaySound ("ambient/water/drip" .. math.random(1, 4) .. ".wav")
	end)
	usermessage.Hook("FadingDoorRemoved", function()
		GAMEMODE:AddNotify("Fading door has been removed!", NOTIFY_GENERIC, 10)
		surface.PlaySound ("ambient/water/drip" .. math.random(1, 4) .. ".wav")
	end)
	
	usermessage.Hook("UpdateCheckEmInputs", function(data)
		local ent = data:ReadEntity()
		if IsValid(ent) then
			ent.CHKMInputs = FadingCheckEmInputs
		end
	end)
	language.Add("Tool.fading_doors.name", "Fading Doors")
	language.Add("Tool.fading_doors.desc", "Makes anything into a fadable door")
	language.Add("Tool.fading_doors.0", "Left click on something to make it a fading door, right click to remove a fading door.")
	language.Add("Undone.fading.door", "Undone Fading Door")
	
	function TOOL:BuildCPanel()
		self:AddControl("Header",   {Text = "#Tool_fading_doors_name", Description = "#Tool_fading_doors_desc"})
		self:AddControl("CheckBox", {Label = "Reversed (Starts invisible, becomes solid)", Command = "fading_doors_reversed"})
		self:AddControl("CheckBox", {Label = "Toggle Active", Command = "fading_doors_toggle"})
		self:AddControl("Numpad",   {Label = "Button", ButtonSize = "22", Command = "fading_doors_key"})
	end
	
	return
end	

local function fadeActivate(self)
	self.fadeActive = true
	self.fadeMaterial = self:GetMaterial()
	self:SetMaterial("sprites/heatwave")
	self:DrawShadow(false)
	self:SetNotSolid(true)
	local phys = self:GetPhysicsObject()
	if (IsValid(phys)) then
		self.fadeMoveable = phys:IsMoveable()
		phys:EnableMotion(false)
	end
	self.NextFadeDeactivate = CurTime() + GetConVarNumber("fadeclosedelay")
end

local function fadeDeactivate(self)
	if not self or not IsValid(self) then return end
	self.NextFadeDeactivate = self.NextFadeDeactivate or CurTime()
	if self.NextFadeDeactivate > CurTime() then
		timer.Create("fadingdoor_delay"..self:EntIndex(), self.NextFadeDeactivate - CurTime(), 1, function()
			fadeDeactivate(self)
		end)
		return
	end
	self.fadeActive = false
	self:SetMaterial(self.fadeMaterial or "")
	self:DrawShadow(true)
	self:SetNotSolid(false)
	local phys = self:GetPhysicsObject();
	if (IsValid(phys)) then
		phys:EnableMotion(self.fadeMoveable or false);
	end
end

local function fadeToggleActive(self)
	if (self.fadeActive) then
		self:fadeDeactivate()
	else
		self:fadeActivate()
	end
end

local function onUp(ply, ent)
	if (not (ent:IsValid() and ent.fadeToggleActive and not ent.fadeToggle)) then
		return
	end
	ent:fadeToggleActive()
end
numpad.Register("Fading Doors onUp", onUp)

local function onDown(ply, ent)
	if (not (ent:IsValid() and ent.fadeToggleActive)) then
		return
	end
	ent:fadeToggleActive()
end
numpad.Register("Fading Doors onDown", onDown)

local function onRemove(self, ply)
	numpad.Remove(self.fadeUpNum)
	numpad.Remove(self.fadeDownNum)
	if IsValid(ply) then
		ply.fadingdoor_count = ply.fadingdoor_count or {}
		if table.HasValue(ply.fadingdoor_count, self:EntIndex()) then
			for k, v in pairs(ply.fadingdoor_count) do
				if v == self:EntIndex() then
					ply.fadingdoor_count[k] = nil
				end
			end
		end
	end
end

-- Fer Duplicator
local function dooEet(ply, ent, stuff)
	if (ent.isFadingDoor) then
		ent:fadeDeactivate()
	else
		ent.isFadingDoor = true
		umsg.Start("UpdateCheckEmInputs")
			umsg.Entity(ent)
		umsg.End()
		ent.CHKMInputs = FadingCheckEmInputs
		ent.CheckInputs = function(self, ip, on)			
			if ip == 1 and on then
				ent:fadeActivate()
			elseif ip == 1 and not on then
				ent:fadeDeactivate()
			end
		end
					
		ent.fadeActivate = fadeActivate
		ent.fadeDeactivate = fadeDeactivate
		ent.fadeToggleActive = fadeToggleActive
		ent.fadeUpNum = numpad.OnUp(ply, stuff.key, "Fading Doors onUp", ent)
		ent.fadeDownNum = numpad.OnDown(ply, stuff.key, "Fading Doors onDown", ent)
		ent:CallOnRemove("Fading Doors", onRemove, ply)
	end
	ent.fadeToggle = stuff.toggle
	if (stuff.reversed) then
		ent:fadeActivate()
	end
	duplicator.StoreEntityModifier(ent, "Fading Door", stuff)
	return true
end
duplicator.RegisterEntityModifier("Fading Door", dooEet)

if (not FadingDoor) then
	local function legacy(ply, ent, data)
		return dooEet(ply, ent, {
			key      = data.Key,
			toggle   = data.Toggle,
			reversed = data.Inverse
		})
	end
	duplicator.RegisterEntityModifier("FadingDoor", legacy)
end

local function doUndo(undoData, ent)
	if (IsValid(ent)) then
		onRemove(ent, undoData.Owner)
		ent:fadeDeactivate()
		ent.isFadingDoor = false
	end
end

function TOOL:LeftClick(tr)
	local ent = tr.Entity
	local ply = self:GetOwner()
	if IsValid(ent) then
		if not ent.isFadingDoor then
			undo.Create("fading_door")
				undo.AddFunction(doUndo, ent)
				undo.SetPlayer(ply)
			undo.Finish()
		end
		dooEet(ply, ent, {
			key      = self:GetClientNumber("key"),
			toggle   = self:GetClientNumber("toggle") == 1,
			reversed = self:GetClientNumber("reversed") == 1
		})
		ply.fadingdoor_count = ply.fadingdoor_count or {}
		table.insert(ply.fadingdoor_count, ent:EntIndex())
		SendUserMessage("FadingDoorCreated", ply)
	end
end

function TOOL:RightClick(tr)
	local ent = tr.Entity
	local ply = self:GetOwner()
	if IsValid(ent) and ent.isFadingDoor then
		onRemove(ent, ply)
		ent:fadeDeactivate()
		ent.isFadingDoor = nil
		SendUserMessage("FadingDoorRemoved", ply)
	end
end
