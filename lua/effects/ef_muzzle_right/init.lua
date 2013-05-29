function EFFECT:Init(ef)
	if IsValid(ef:GetEntity()) then
		self:SetPos(ef:GetOrigin())
		self.Emitter = ParticleEmitter(ef:GetOrigin())
		local ent = ef:GetEntity()
		local ply = ent:GetOwner()
		
		local model = ent.WElements["weapon"]
		
		local att
		
		if model then
			att = model.modelEnt:GetAttachment("1")
		else
			att = ent:GetAttachment("1")
		end
			
		if att then
			ParticleEffect(ent.SmokeEffect or "cstm_child_smoke_small", att.Pos, ply:EyeAngles(), att)
						
			if not ent.dt.Sil or ((ent.WElements and ent.WElements["silencer"] != nil and ent.WElements["silencer"].color.a != 255) or ent.WElements and ent.WElements["silencer"] == nil) then -- I check if it's not nil and then if it's nil to ensure that weapons that don't have a silencer don't bug
				ParticleEffect(ent.Muzzle or "cstm_child_muzzle_small", att.Pos, ply:EyeAngles(), att)
				ParticleEffect(ent.SparkEffect or "cstm_child_sparks_small", att.Pos, ply:EyeAngles(), att)
			end
		end
	end
	
	self.DieTime = CurTime() + 0.01
end

function EFFECT:Think()
	if not IsValid(self.Emitter) then
		return false
	end

	if CurTime() > self.DieTime then
		self.Emitter:Finish()
		return false
	else
		return true
	end
end

function EFFECT:Render()
end