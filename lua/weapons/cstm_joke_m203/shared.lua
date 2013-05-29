if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName = "Handheld M203 (joke weapon)";
	SWEP.Slot = 3;
	SWEP.SlotPos = 0 // = 3;
	SWEP.ChangeSkin = true
	
	SWEP.VElements = {
		["m203"] = { type = "Model", model = "models/wystan/attachments/m203.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, 1.468, -10.945), angle = Angle(0, 180, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.HoldType = "pistol"

SWEP.Base = "cmodel_cstm_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBonescales = {["v_weapon.Deagle_Parent"] = Vector(0.009, 0.009, 0.009)}
SWEP.Secondary.Automatic = true
SWEP.Instructions = [[Handheld M203, CAN YOU HANDLE MORE?!]] 

SWEP.Primary.DefaultClip	= 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo         	= "smg1_grenade"

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "none"

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:PrimaryAttack()
	if self:Clip1() == 0 then
		return
	end

	if SERVER then
		local prop = ents.Create("gren_explosive")
		prop:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 24 + self.Owner:GetRight() * 4 + self.Owner:GetUp() * -6)
		prop:SetOwner(self.Owner)
		prop:SetAngles(self.Owner:EyeAngles())
		prop.BlastRadius = 256
		prop.BlastDamage = 80
		prop:Spawn()
		prop:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 3500)
		prop:SetGravity(1.8)
		prop:SetOwner(self.Owner)
			
		self.Owner:ViewPunch(Angle(-10, 0, 0))
		self.Owner:EmitSound("weapons/grenade_launcher1.wav", 85, 100)
		self:TakeSecondaryAmmo(1)
		self:SetDTInt(3, 0)
		self.Owner:SetFOV(0, 0.3)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:TakePrimaryAmmo(1)
	end
end

function SWEP:SecondaryAttack()
	return
end

if CLIENT then

	local GLTexture = surface.GetTextureID("sprites/crosshair_gl")
	
	function SWEP:DrawHUD()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(GLTexture)
		surface.DrawTexturedRect(ScrW() / 2 - 64, ScrH() / 2, 128, 128)
	end
end
