AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.WireDebugName = "Advanced Pod Controller"

local serverside_keys = {
	[IN_FORWARD] = "W",
	[IN_MOVELEFT] = "A",
	[IN_BACK] = "S",
	[IN_MOVERIGHT] = "D",
	[IN_ATTACK] = "Mouse1",
	[IN_ATTACK2] = "Mouse2",
	[IN_RELOAD] = "R",
	[IN_JUMP] = "Space",
	[IN_SPEED] = "Shift",
	[IN_ZOOM] = "Zoom",
	[IN_WALK] = "Alt",
	[IN_LEFT] = "TurnLeftKey",
	[IN_RIGHT] = "TurnRightKey",
}

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local outputs = {
		-- Keys
		"W", "A", "S", "D", "Mouse1", "Mouse2",
		"R", "Space", "Shift", "Zoom", "Alt", "TurnLeftKey", "TurnRightKey",

		-- Clientside keys
		"PrevWeapon", "NextWeapon", "Light",

		-- Aim Position
		"X", "Y", "Z", "AimPos [VECTOR]",
		"Distance", "Bearing", "Elevation",

		-- Other info
		"ThirdPerson", "Team", "Health", "Armor",

		-- Active
		"Active",

		-- Entity
		"Entity [ENTITY]",
	}

	self.Inputs = WireLib.CreateInputs( self, { "Lock", "Terminate", "Strip weapons", "Eject", "Disable", "Crosshairs", "Brake", "Allow Buttons", "Relative", "Damage Health", "Damage Armor", "Hide Player", "Hide HUD"} )
	self.Outputs = WireLib.CreateOutputs( self, outputs )

	self:SetLocked( false )
	self:SetHidePlayer( false )
	self:SetHideHUD( false )
	self.HidePlayerVal = false
	self.Crosshairs = false
	self.Disable = false
	self.AllowButtons = false
	self.Relative = false
	self.MouseDown = false

	self:SetActivated( false )

	self:SetColor(Color(255,0,0,self:GetColor().a))
end

-- Accessor funcs for certain functions
function ENT:SetLocked( b )
	if (!self:HasPod() or self.Locked == b) then return end

	self.Locked = b
	self.Pod:Fire( b and "Lock" or "Unlock", "1", 0 )
end

function ENT:SetActivated( b )
	if (self.Activated == b) then return end

	if b then
		self:SetColor(Color(0,255,0,self:GetColor().a))
	else
		self:SetColor(Color(255,0,0,self:GetColor().a))
	end

	self.Activated = b
	WireLib.TriggerOutput(self, "Active", b and 1 or 0)
end

function ENT:HidePlayer( b )
	if not self:HasPly() then return end

	local c = self:GetPly():GetColor()
	if b then
		self.OldPlyAlpha = c.a
		c.a = 0
	else
		c.a = self.OldPlyAlpha or 255
		self.OldPlyAlpha = nil
	end
	self:GetPly():SetColor(c)
	self:GetPly():SetRenderMode(c.a ~= 255 and RENDERMODE_TRANSALPHA or RENDERMODE_NORMAL)
end

function ENT:SetHidePlayer( b )
	if (self.HidePlayer == b) then return end

	self.HidePlayerVal = b

	if (self:HasPly()) then
		self:HidePlayer( b )
	end
end

function ENT:Link( pod )
	if (!pod or !pod:IsValid() or !pod:IsVehicle()) then return false end
	self:SetPod( pod )
	return true
end

function ENT:HasPod() return (self.Pod and self.Pod:IsValid()) end
function ENT:GetPod() return self.Pod end
function ENT:SetPod( pod )
	if (pod and pod:IsValid() and !pod:IsVehicle()) then return false end
	self.Pod = pod
	WireLib.TriggerOutput( self, "Entity", pod )
	return true
end

function ENT:HasPly()
	return (self.Ply and self.Ply:IsValid())
end
function ENT:GetPly()
	return self.Ply
end
function ENT:SetPly( ply )
	if (ply and ply:IsValid() and !ply:IsPlayer()) then return false end
	self.Ply = ply
	return true
end

function ENT:SetHideHUD( bool )
	self.HideHUD = bool

	if self:HasPly() and self:HasPod() then -- If we have a player, we SHOULD always have a pod as well, but just in case.
		umsg.Start( "wire adv pod hud", self:GetPly() )
			umsg.Entity( self:GetPod() )
			umsg.Bool( self.HideHUD )
		umsg.End()
	end
end
function ENT:GetHideHUD() return self.HideHUD end

-- Clientside binds
concommand.Add("wire_adv_pod_bind", function( ply,cmd,args )
	local bind = args[1]
	if (!bind) then return end

	if (bind == "1") then bind = "PrevWeapon"
	elseif (bind == "2") then bind = "NextWeapon"
	end

	for _, pod in pairs( ents.FindByClass( "gmod_wire_adv_pod" ) ) do
		if (ply:GetVehicle() == pod.Pod) then
			WireLib.TriggerOutput( pod, bind, 1 )
			timer.Simple( 0.03, function()
				WireLib.TriggerOutput( pod, bind, 0 )
			end )
		end
	end
end)

-- Serverside binds
hook.Add( "KeyPress", "Wire_Adv_Pod_KeyPress", function( ply, key )
	if (!serverside_keys[key]) then return end
	for k,v in pairs( ents.FindByClass( "gmod_wire_adv_pod" ) ) do
		if (v:HasPly() and v:GetPly() == ply and !v.Disable) then
			WireLib.TriggerOutput( v, serverside_keys[key], 1 )
		end
	end
end)

hook.Add( "KeyRelease", "Wire_Adv_Pod_KeyRelease", function( ply, key )
	if (!serverside_keys[key]) then return end
	for k,v in pairs( ents.FindByClass( "gmod_wire_adv_pod" ) ) do
		if (v:HasPly() and v:GetPly() == ply and !v.Disable) then
			WireLib.TriggerOutput( v, serverside_keys[key], 0 )
		end
	end
end)

-- Helper function for ejecting players using the RC remote
function ENT:RCEject()
	self.RC:Off()
end

function ENT:TriggerInput( name, value )
	if (name == "Lock") then
		if (self.RC) then return end
		if (!self:HasPod()) then return end
		self:SetLocked( value != 0 )
	elseif (name == "Terminate") then
		if (value == 0 or !self:HasPly()) then return end
		local ply = self:GetPly()
		if (self.RC) then self:RCEject( ply ) end
		ply:Kill()
	elseif (name == "Strip weapons") then
		if (value == 0 or !self:HasPly()) then return end
		local ply = self:GetPly()
		if (self.RC) then
			ply:ChatPrint( "Your control has been terminated, and your weapons stripped!" )
			self:RCEject( ply )
		else
			ply:ChatPrint( "Your weapons have been stripped!" )
		end
		ply:StripWeapons()
	elseif (name == "Eject") then
		if (value == 0 or !self:HasPly()) then return end
		if (self.RC) then
			self:RCEject( self:GetPly() )
		else
			self:GetPly():ExitVehicle()
		end
	elseif (name == "Disable") then
		self.Disable = (value != 0)

		if (self.Disable) then
			for k,v in pairs( serverside_keys ) do
				WireLib.TriggerOutput( self, v, 0 )
			end
		end
	elseif (name == "Crosshairs") then
		self.Crosshairs = (value != 0)
		if (self:HasPly()) then
			if (self.Crosshairs) then
				self:GetPly():CrosshairEnable()
			else
				self:GetPly():CrosshairDisable()
			end
		end
	elseif (name == "Brake") then
		if (!self:HasPod()) then return end
		local pod = self:GetPod()
		if (value != 0) then
			pod:Fire("TurnOff","1",0)
			pod:Fire("HandBrakeOn","1",0)
		else
			pod:Fire("TurnOn","1",0)
			pod:Fire("HandBrakeOff","1",0)
		end
	elseif (name == "Damage Health") then
		if (!self:HasPly() or value <= 0) then return end
		if (value > 100) then value = 100 end
		self:GetPly():TakeDamage( value )
	elseif (name == "Damage Armor") then
		if (!self:HasPly() or value <= 0) then return end
		if (value > 100) then value = 100 end
		local dmg = self:GetPly():Armor() - value
		if (dmg < 0) then dmg = 0 end
		self:GetPly():SetArmor( dmg )
	elseif (name == "Allow Buttons") then
		self.AllowButtons = (value != 0)
	elseif (name == "Relative") then
		self.Relative = (value != 0)
	elseif (name == "Hide Player") then
		self:SetHidePlayer( value != 0 )
	elseif (name == "Hide HUD") then
		self:SetHideHUD( value ~= 0 )
	end
end

local function fixupangle(angle)
	if angle > 180 then angle = angle - 360 end
	if angle < -180 then angle = angle + 360 end
	return angle
end

function ENT:Think()
	if (self:HasPly() and self.Activated) then
		local ply = self:GetPly()
		local pod = self:GetPod()

		-- Tracing
		local trace = util.TraceLine( { start = ply:GetShootPos(), endpos = ply:GetShootPos() + ply:GetAimVector() * 9999999999, filter = { ply, pod } } )
		local distance = 0
		if (self:HasPod()) then distance = trace.HitPos:Distance( pod:GetPos() ) else distance = trace.HitPos:Distance( ply:GetShootPos() ) end

		if (trace.Hit) then
			-- Position
			WireLib.TriggerOutput( self, "X", trace.HitPos.x )
			WireLib.TriggerOutput( self, "Y", trace.HitPos.y )
			WireLib.TriggerOutput( self, "Z", trace.HitPos.z )
			WireLib.TriggerOutput( self, "AimPos", trace.HitPos )
			WireLib.TriggerOutput( self, "Distance", distance )
			self.VPos = trace.HitPos

			-- Bearing & Elevation
			local angle = ply:GetAimVector():Angle()

			if (self.Relative) then
				local originalangle
				if (self.RC) then
					originalangle = ply.InitialAngle
				else
					originalangle = pod:GetAngles()
					if (pod:GetClass() != "prop_vehicle_prisoner_pod") then
						originalangle.y = originalangle.y + 90
					end
				end
				WireLib.TriggerOutput( self, "Bearing", fixupangle( angle.y - originalangle.y ) )
				WireLib.TriggerOutput( self, "Elevation", fixupangle( angle.p - originalangle.p ) )
			else
				WireLib.TriggerOutput( self, "Bearing", fixupangle( angle.y ) )
				WireLib.TriggerOutput( self, "Elevation", fixupangle( -angle.p ) )
			end
		else
			WireLib.TriggerOutput( self, "X", 0 )
			WireLib.TriggerOutput( self, "Y", 0 )
			WireLib.TriggerOutput( self, "Z", 0 )
			WireLib.TriggerOutput( self, "AimPos", Vector(0,0,0) )
			WireLib.TriggerOutput( self, "Bearing", 0 )
			WireLib.TriggerOutput( self, "Elevation", 0 )
			self.VPos = Vector(0,0,0)
		end

		-- Button pressing
		if (self.AllowButtons and distance < 82) then
			local button = trace.Entity
			if (button and button:IsValid() and button:GetClass() == "gmod_wire_button") then
				if (ply:KeyDown( IN_ATTACK ) and !self.MouseDown) then
					self.MouseDown = true
					if (button.toggle) then
						if (button:IsOn()) then
							button:Switch( false )
						else
							button.EntToOutput = ply
							button.PrevUser = ply
							button:Switch( true )
						end
					else
						button.PrevUser = ply
						button.podpress = true
						button.EntToOutput = ply
						button:Switch( true )
					end
				elseif (!ply:KeyDown( IN_ATTACK ) and self.MouseDown) then
					self.MouseDown = false
				end
			end
		end

		-- Other info
		WireLib.TriggerOutput(self, "Team", ply:Team())
		WireLib.TriggerOutput(self, "Health", ply:Health())
		WireLib.TriggerOutput(self, "Armor", ply:Armor())
		WireLib.TriggerOutput(self, "ThirdPerson", ply:GetInfoNum("gmod_vehicle_viewmode", 0))
		
		WireLib.TriggerOutput(self, "Light", ply.keystate[KEY_F] and 1 or 0)
	end

	self:NextThink( CurTime() )
	return true
end

function ENT:PlayerEntered( ply, RC )
	if (self:HasPly()) then return end
	self:SetPly( ply )

	if (RC != nil) then self.RC = RC else self.RC = nil end

	if (self.Crosshairs) then
		ply:CrosshairEnable()
	end

	if self.HideHUD and self:HasPod() then
		umsg.Start( "wire adv pod hud", ply )
			umsg.Entity( self:GetPod() )
			umsg.Bool( true )
		umsg.End()
	end

	if (self.HidePlayerVal) then
		self:HidePlayer( true )
	end

	self:SetActivated( true )
end

function ENT:PlayerExited( ply )
	if (!self:HasPly()) then return end

	self:HidePlayer( false )

	ply:CrosshairEnable()

	self:SetActivated( false )

	for k,v in pairs( serverside_keys ) do
		WireLib.TriggerOutput( self, v, 0 )
	end
	WireLib.TriggerOutput( self, "PrevWeapon", 0 )
	WireLib.TriggerOutput( self, "NextWeapon", 0 )
	WireLib.TriggerOutput( self, "Light", 0 )

	WireLib.TriggerOutput( self, "X", 0 )
	WireLib.TriggerOutput( self, "Y", 0 )
	WireLib.TriggerOutput( self, "Z", 0 )
	WireLib.TriggerOutput( self, "AimPos", Vector(0,0,0) )

	WireLib.TriggerOutput( self, "Distance", 0 )
	WireLib.TriggerOutput( self, "Bearing", 0 )
	WireLib.TriggerOutput( self, "Elevation", 0 )

	WireLib.TriggerOutput( self, "ThirdPerson", 0 )
	WireLib.TriggerOutput( self, "Team", 0 )
	WireLib.TriggerOutput( self, "Health", 0 )
	WireLib.TriggerOutput( self, "Armor", 0 )

	self:SetPly( nil )
end

hook.Add( "PlayerEnteredVehicle", "Wire_Adv_Pod_EnterVehicle", function( ply, vehicle )
	for k,v in pairs( ents.FindByClass( "gmod_wire_adv_pod" ) ) do
		if (v:HasPod() and v:GetPod() == vehicle) then
			v:PlayerEntered( ply )
		end
	end
end)

hook.Add( "PlayerLeaveVehicle", "Wire_Adv_Pod_ExitVehicle", function( ply, vehicle )
	for k,v in pairs( ents.FindByClass( "gmod_wire_adv_pod" ) ) do
		if (v:HasPod() and v:GetPod() == vehicle) then
			v:PlayerExited( ply )
		end
	end
end)

function ENT:GetBeaconPos(sensor)
	return self.VPos
end
function ENT:GetBeaconVelocity(sensor)
	return self:HasPod() and self:GetPod():GetVelocity() or self:GetVelocity()
end

--Duplicator support to save pod link (TAD2020)
function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self:HasPod() and !self.RC) then
		info.pod = self.Pod:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.pod) then
		self:SetPod( GetEntByID( info.pod ) or ents.GetByIndex( info.pod ) )
	end
end

function ENT:Use( User, caller )
	if User ~= self:GetPlayer() then return end
	User:PrintMessage(HUD_PRINTTALK, "Hold down your use key for 2 seconds to get and link a Remote Controller.")
	timer.Create("adv_pod_use_"..self:EntIndex(), 2, 1, function()
		if not User then return end
		if not User:IsValid() then return end
		if not User:IsPlayer() then return end
		if not User:KeyDown(IN_USE) then return end
		if not User:GetEyeTrace().Entity or User:GetEyeTrace().Entity ~= self then return end

		if not User:GetWeapon("RemoteController"):IsValid()  then
			User:Give("RemoteController")
		end

		User:GetWeapon("RemoteController").Linked = self
		User:PrintMessage(HUD_PRINTTALK, "You are now linked!")
		User:SelectWeapon("RemoteController")
	end)
end


function MakeWireAdvPod(pl, Pos, Ang, model, frozen)
	if not pl:CheckLimit("wire_adv_pods") then return false end

	local wire_pod = ents.Create("gmod_wire_adv_pod")
	if not wire_pod:IsValid() then return false end
	wire_pod:SetModel( model or MODEL )
	wire_pod:SetAngles(Ang)
	wire_pod:SetPos(Pos)
	wire_pod:Spawn()

	if wire_pod:GetPhysicsObject():IsValid() then
		wire_pod:GetPhysicsObject():EnableMotion(!frozen)
	end

	wire_pod:SetPlayer(pl)
	wire_pod.pl = pl

	pl:AddCount("wire_adv_pods", wire_pod)
	pl:AddCleanup( "gmod_wire_adv_pod", wire_pod )

	return wire_pod
end
duplicator.RegisterEntityClass("gmod_wire_adv_pod", MakeWireAdvPod, "Pos", "Ang", "Model", "frozen")
