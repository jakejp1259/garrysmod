AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.WireDebugName = "Numpad"

local keynames = {"0","1","2","3","4","5","6","7","8","9",".","enter","+","-","*","/"} -- Names as we will display them and for inputs/outputs
local keyenums = {37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 52, 51, 50, 49, 48, 47} -- Same indexes as keynames, values are the corresponding KEY_* enums
local nametoenum = {}
for k,v in ipairs(keynames) do nametoenum[v] = keyenums[k] end  -- Indexes are string input/output names, values are the corresponding KEY_* enums

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.Inputs = Wire_CreateInputs(self, keynames)
	self.Outputs = Wire_CreateOutputs(self, keynames)

	self.Buffer = {}
	for i = 1, #keynames do
		self.Buffer[i] = 0
	end
end

-- These two high speed functions want to access a zero indexed array of what keys are pressed (0-15), our buffer is 1-16
function ENT:ReadCell( Address )
	if (Address >= 0) && (Address < #keynames) then
		return self.Buffer[Address+1]
	else
		return nil
	end
end

function ENT:WriteCell( Address, value )
	if (Address >= 0) && (Address < #keynames) then
		self:TriggerInput(keynames[Address+1], value)
		return true
	else
		return false
	end
end

function ENT:TriggerInput(key, value)
	if value ~= 0 then
		numpad.Activate( self:GetPlayer(), nametoenum[key], true )
	else
		numpad.Deactivate( self:GetPlayer(), nametoenum[key], true )
	end
end

function ENT:Setup( toggle, value_off, value_on)
	self.toggle = toggle
	self.value_off = value_off
	self.value_on = value_on

	self:ShowOutput()
end

function ENT:NumpadActivate( key )
	if ( self.toggle ) then
		return self:Switch( self.Buffer[ key ] == 0, key )
	end

	return self:Switch( true, key )
end

function ENT:NumpadDeactivate( key )
	if ( self.toggle ) then return true end

	return self:Switch( false, key )
end

function ENT:Switch( on, key )
	if (!self:IsValid()) then return false end

	self.Buffer[key] = on and 1 or 0
	
	self:ShowOutput()
	self.Value = on and self.value_on or self.value_off

	Wire_TriggerOutput(self, keynames[key], self.Value)

	return true
end

function ENT:ShowOutput()
	local txt = ""
	for k,keyname in ipairs(keynames) do
		if (self.Buffer[k] ~= 0) then
			txt = txt..", "..keyname
		end
	end

	self:SetOverlayText( string.sub(txt,2) )
end

function ENT:OnRemove()
	for _,impulse in ipairs(self.impulses) do
		numpad.Remove(impulse)
	end
end

local function On( pl, ent, key )
	return ent:NumpadActivate( key )
end
numpad.Register( "WireNumpad_On", On )

local function Off( pl, ent, key )
	return ent:NumpadDeactivate( key )
end
numpad.Register( "WireNumpad_Off", Off )

function MakeWireNumpad( pl, Pos, Ang, model, toggle, value_off, value_on )
	if ( !pl:CheckLimit( "wire_numpads" ) ) then return false end

	local wire_numpad = ents.Create( "gmod_wire_numpad" )
	if (!wire_numpad:IsValid()) then return false end

	wire_numpad:SetAngles( Ang )
	wire_numpad:SetPos( Pos )
	wire_numpad:SetModel( Model(model or "models/jaanus/wiretool/wiretool_input.mdl") )
	wire_numpad:Spawn()

	wire_numpad:Setup(toggle, value_off, value_on )
	wire_numpad:SetPlayer( pl )
	wire_numpad.pl = pl

	wire_numpad.impulses = {}
	for k,keyenum in ipairs(keyenums) do
		table.insert(wire_numpad.impulses, numpad.OnDown( pl, keyenum, "WireNumpad_On", wire_numpad, k ))
		table.insert(wire_numpad.impulses, numpad.OnUp( pl, keyenum, "WireNumpad_Off", wire_numpad, k ))
	end

	pl:AddCount( "wire_numpads", wire_numpad )

	return wire_numpad
end
duplicator.RegisterEntityClass("gmod_wire_numpad", MakeWireNumpad, "Pos", "Ang", "Model", "toggle", "value_off", "value_on")
