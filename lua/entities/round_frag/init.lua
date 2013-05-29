AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Radius = 128
ENT.Damage = 60

function ENT:Initialize()
	self:SetModel("models/weapons/W_missile_closed.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	spd = physenv.GetPerformanceSettings()
    spd.MaxVelocity = 10000
	
    physenv.SetPerformanceSettings(spd)
end

function ENT:OnTakeDamage(dmginfo)
	return false
end

function ENT:Use(activator, caller)
	return false
end

function ENT:PhysicsCollide(data, physobj)
	self:Explode()
	self.BlewUp = true
end

local cl, owner, phys, distance, relation, forceDir, pos, pos2, mass, dmg

function ENT:Explode()
	if self.BlewUp then
		return
	end
	
	owner = self.Owner
	pos = self:GetPos()
	
	sound.Play("weapons/explode" .. math.random(3, 5) .. ".wav", pos, 95, 100, 1)
	ParticleEffect("cstm_frag_expl", pos, Angle(0, 0, 0), nil)
	
	for k, v in pairs(ents.FindInSphere(pos, self.Radius)) do
		if IsValid(v) then
			cl = v:GetClass()
			pos2 = v:GetPos()
			distance = pos:Distance(pos2)
			forceDir = ((pos2 - pos):GetNormal() * 500)
			
			if v:Health() > 0 then
				dmg = DamageInfo()
				dmg:SetInflictor(self)
				dmg:SetAttacker(owner)
				dmg:SetDamageType(DMG_BLAST)
				dmg:SetDamage((1 - distance / self.Radius) * self.Damage)
				dmg:SetDamageForce(forceDir * 200)
				v:TakeDamageInfo(dmg)
			end
			
			if (cl == "prop_physics" or cl == "prop_ragdoll") then
				phys = v:GetPhysicsObject()
				
				if not v.ReceivedExplosiveForce then
					v.ReceivedExplosiveForce = 300
				else
					v.ReceivedExplosiveForce = v.ReceivedExplosiveForce + 300
				end
				
				if IsValid(phys) then
					mass = phys:GetMass()
					relation = math.Clamp(((128 - distance) / 128) / (mass * 0.005), 0, 1)
					forceDir = forceDir * relation
					
					if phys:IsMoveable() then
						phys:AddAngleVelocity(Vector(500, 500, 100) * relation)
						phys:SetVelocity(forceDir)
					end
					
					if v.ReceivedExplosiveForce >= mass then
						constraint.RemoveAll(v)
						
						phys:Wake()
						phys:EnableMotion(true)
						
						phys:AddAngleVelocity(Vector(500, 500, 100) * relation)
						phys:SetVelocity(forceDir)
						
						v.ReceivedExplosiveForce = 0
					end
				end
				
			end
		end
	end
	
	//util.BlastDamage(owner:GetActiveWeapon(), owner, pos, 128, 60)
	SafeRemoveEntity(self)
end