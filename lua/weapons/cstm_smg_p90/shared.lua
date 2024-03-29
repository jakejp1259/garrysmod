if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.BulletLength = 5.7
SWEP.CaseLength = 28

SWEP.MuzVel = 557.741

if ( CLIENT ) then

	SWEP.PrintName			= "FN P90"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 2
	SWEP.SlotPos = 0 //			= 1
	SWEP.IconLetter			= "m"
	SWEP.Muzzle = "cstm_muzzle_smg"
	SWEP.SparkEffect = "cstm_child_sparks_medium"
	SWEP.SmokeEffect = "cstm_child_smoke_medium"
	
	killicon.AddFont( "cstm_smg_p90", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	SWEP.VElements = {
		["silencer"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.p90_Parent", pos = Vector(0.043, 2.944, 6.593), angle = Angle(0, 0, 0), size = Vector(0.043, 0.043, 0.15), color = Color(255, 255, 255, 1), surpresslightning = false, material = "models/bunneh/silencer", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["silencer"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", pos = Vector(13.718, 1.18, -2.901), angle = Angle(-90, 0, 0), size = Vector(0.043, 0.043, 0.15), color = Color(255, 255, 255, 1), surpresslightning = false, material = "models/bunneh/silencer", skin = 0, bodygroup = {} }
	}
	
	SWEP.NoProperIronsights = true
	SWEP.BoneApproachSpeed = 0.45
end

SWEP.Category = "Customizable Weaponry"
SWEP.HoldType			= "ar2"
SWEP.Base				= "cstm_base_pistol"
SWEP.FireModes = {"auto", "semi"}

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBonescales = {}

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/p90/p90-1.wav")
SWEP.Primary.Recoil			= 0.3
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.0666
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.7x28MM"
SWEP.InitialHoldtype = "smg"
SWEP.InHoldtype = "smg"

-- Animation speed/custom reload function related
SWEP.IsReloading = false
SWEP.AnimPrefix = ""
SWEP.ReloadSpeed = 1
SWEP.ShouldBolt = false
SWEP.ReloadDelay = 0
SWEP.IncAmmoPerc = 0.7 -- Amount of frames required to pass (in percentage) of the reload animation for the weapon to have it's amount of ammo increased

-- Dynamic accuracy related
SWEP.ShotsAmount 			= 0
SWEP.ConeDecAff				= 0
SWEP.DefRecoil				= 0.5
SWEP.CurCone				= 0.038
SWEP.DecreaseRecoilTime 	= 0
SWEP.ConeAff1 				= 0 -- Crouching/standing
SWEP.ConeAff2 				= 0 -- Using ironsights

SWEP.UnConeTime				= 0 -- Amount of time after firing the last shot that needs to pass until accuracy increases
SWEP.FinalCone				= 0 -- Self explanatory
SWEP.VelocitySensivity		= 1.2 -- Percentage of how much the cone increases depending on the player's velocity (moving speed). Rifles - 100%; SMGs - 80%; Pistols - 60%; Shotguns - 20%
SWEP.HeadbobMul 			= 1
SWEP.IsSilenced 			= false
SWEP.IronsightsCone			= 0.01
SWEP.HipCone 				= 0.045
SWEP.InaccAff1 = 0.45
SWEP.ConeInaccuracyAff1 = 0.55

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IsUsingIronsights 		= false
SWEP.TargetMul = 0
SWEP.SetAndForget			= false

SWEP.IronSightsPos = Vector(6.0749, -5.5216, 2.3984)
SWEP.IronSightsAng = Vector(2.5174, -0.0099, 0)

SWEP.AimPos = Vector(2, -4.427, 2.44)
SWEP.AimAng = Vector(0, 0, 0)

SWEP.ChargePos = Vector (5.4056, -10.3522, -4.0017)
SWEP.ChargeAng = Vector (-1.7505, -55.5187, 68.8356)