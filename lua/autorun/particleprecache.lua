game.AddParticles("particles/cstm_muzzleflashes.pcf")
game.AddParticles("particles/cstm_muzzleflashes2.pcf")

PrecacheParticleSystem("cstm_child_sparks_small")
PrecacheParticleSystem("cstm_child_sparks_medium")
PrecacheParticleSystem("cstm_child_sparks_large")
PrecacheParticleSystem("cstm_child_sparks_verylarge")
PrecacheParticleSystem("cstm_child_smoke_small")
PrecacheParticleSystem("cstm_child_smoke_medium")
PrecacheParticleSystem("cstm_child_smoke_large")
PrecacheParticleSystem("cstm_child_smoke_verylarge")
PrecacheParticleSystem("cstm_child_muzzle_small")
PrecacheParticleSystem("cstm_child_muzzle_medium")
PrecacheParticleSystem("cstm_child_muzzle_large")
PrecacheParticleSystem("cstm_child_heat")
PrecacheParticleSystem("cstm_muzzle_pistol")
PrecacheParticleSystem("cstm_muzzle_smg")
PrecacheParticleSystem("cstm_muzzle_ar")
PrecacheParticleSystem("cstm_muzzle_br")
PrecacheParticleSystem("cstm_incendiary_hit")
PrecacheParticleSystem("cstm_frag_fly")
PrecacheParticleSystem("cstm_frag_expl")

local pmodel = util.PrecacheModel

pmodel("models/attachments/kascope.mdl")
pmodel("models/attachments/cmore.mdl")
pmodel("models/bunneh/scope01.mdl")
pmodel("models/wystan/cmag.mdl")
pmodel("models/wystan/2cog.mdl")
pmodel("models/wystan/2octorrds.mdl")
pmodel("models/wystan/2otech557sight.mdl")
pmodel("models/wystan/aimpoint.mdl")
pmodel("models/wystan/akrailmount.mdl")
pmodel("models/wystan/bipod.mdl")
pmodel("models/wystan/foregrip1.mdl")
pmodel("models/wystan/m203.mdl")
pmodel("models/wystan/rail.mdl")
pmodel("models/props_c17/oildrum001.mdl")
pmodel("models/props_c17/FurnitureBoiler001a.mdl")

for k, v in pairs(weapons.GetList()) do
	if v.ThisClass and v.ThisClass:find("cstm_") then
		if v.ViewModel then
			pmodel(v.ViewModel)
		end
	end
end

FS = {}
FS["CSTM_SilencedShot"] = "weapons/m4a1/m4a1-1.wav"

local tbl = {channel = CHAN_WEAPON,
	volume = 1,
	soundlevel = 120,
	pitchstart = 100,
	pitchend = 100}
	
for k, v in pairs(FS) do
	tbl.name = k
	tbl.sound = v
		
	sound.Add(tbl)
end	

AttEnum = {
	["acog"] = 2,
	["aimpoint"] = 3,
	["eotech"] = 4,
	["kobra"] = 5,
	["grenadelauncher"] = 6,
	["vertgrip"] = 7,
	["cmag"] = 8,
	["reflex"] = 9,
	["laser"] = 10,
	["bipod"] = 11,
	["riflereflex"] = 12,
	["ballistic"] = 13}
	
AmmoTypes = {
	["incendiary"] = {name = "Incendiary", num = 1, penmod = 0.25},
	["ap"] = {name = "Armor Piercing", num = 2, penmod = 1.15},
	["hp"] = {name = "Hollow Point", num = 3, penmod = 0.85},
	
	["magnum"] = {name = "Magnum", num = 4, penmod = 1.1, func = function(ply, wep)
		wep.PrevStats = {dmg = wep.Primary.Damage, rec = wep.Primary.Recoil}
		
		wep.Primary.Recoil = wep.Primary.Recoil * 1.25
		wep.Primary.Damage = wep.Primary.Damage * 1.2
		wep:SendRecoil()
	end},
	
	["slug"] = {name = "Slug", num = 6, penmod = 1, func = function(ply, wep)
		wep.PrevStats = {dmg = wep.Primary.Damage, shot = wep.Primary.NumShots, acc = wep.IronsightsCone, velsens = wep.VelocitySensivity}
		
		wep.Primary.Damage = wep.Primary.Damage * 10
		wep.Primary.NumShots = 1
		wep.IronsightsCone = wep.IronsightsCone * 0.05
		wep.VelocitySensivity = 1.6
			
		umsg.Start("NBUL", activator)
			umsg.Short(1)
		umsg.End()
	end},
	
	["birdshot"] = {name = "Birdshot", num = 7, penmod = 0.5, func = function(ply, wep)
		wep.PrevStats = {dmg = wep.Primary.Damage, shot = wep.Primary.NumShots, acc = wep.IronsightsCone, acch = wep.HipCone, velsens = wep.VelocitySensivity, rec = wep.Primary.Recoil}
		
		wep.Primary.Recoil = wep.Primary.Recoil * 0.5
		wep.Primary.NumShots = 12
		wep.Primary.Damage = wep.Primary.Damage / 8
		wep.IronsightsCone = wep.IronsightsCone * 2
		wep.HipCone = wep.HipCone * 1.4
		wep.VelocitySensivity = 0.2
		wep:SendRecoil()
		
		umsg.Start("NBUL", activator)
			umsg.Short(12)
		umsg.End()
	end},
	
	["frag"] = {name = "Frag", num = 10, penmod = 1},
	["smoke"] = {name = "Smoke", num = 11, penmod = 1}}
	
local mag, wep

function TWeps_LowAmmo(w, p)
	mag = w:Clip1()
	
	if mag < w.Primary.ClipSize * 0.33 then
		w:EmitSound("weapons/ClipEmpty_Rifle.wav", 100 - (mag * 4), 100)
	end
end

function TWeps_Move(p, m)
	if p:Alive() then
		wep = p:GetActiveWeapon()
		
		if IsValid(wep) then
			if wep.IsCSTMWeapon then
				if not p:KeyDown(IN_SPEED) then
					if wep:GetDTInt(3) == 1 then
						if p:Crouching() then
							m:SetMaxSpeed(p:GetWalkSpeed() * p:GetCrouchedWalkSpeed())
						else
							m:SetMaxSpeed(p:GetWalkSpeed() * 0.7)
						end
					end
				end
			end
		end
	end
end

hook.Add("Move", "TWeps_Move", TWeps_Move)

/*local am = {dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3}*/

//am.name = "9x18MM"
game.AddAmmoType({name = "9x18MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "9x19MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

//am.name = "7.65x17MM"
game.AddAmmoType({name = "7.65x17MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "4.6x30MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "5.7x28MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "5.45x39MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "9x39MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "5.56x45MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "6x35MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "7.62x39MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "7.62x51MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "7.92x57MM",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = ".45ACP",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = ".50AE",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = ".338",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = ".50BMG",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "12G",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "6G",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = ".357",
dmgtype = DMG_BULLET,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "40MM_HE",
dmgtype = DMG_BLAST,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "40MM_CE",
dmgtype = DMG_BLAST,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

game.AddAmmoType({name = "40MM_Smoke",
dmgtype = DMG_BLAST,
force = 10,
maxsplash = 0,
minsplash = 0,
npcdmg = 18,
plydmg = 18,
tracer = 3})

if CLIENT then
	language.Add("9x18MM_ammo", "9x18MM Ammo")
	language.Add("9x19MM_ammo", "9x19MM Ammo")
	language.Add("7.65x17MM_ammo", "7.65x17MM Ammo")
	language.Add("4.6x30MM_ammo", "4.6x30MM Ammo")
	language.Add("5.7x28MM_ammo", "5.7x28MM Ammo")
	language.Add("6x35MM_ammo", "6x35MM Ammo")
	language.Add("5.45x39MM_ammo", "5.45x39MM Ammo")
	language.Add("9x39MM_ammo", "9x39MM Ammo")
	language.Add("5.56x45MM_ammo", "5.56x45MM Ammo")
	language.Add("7.62x39MM_ammo", "7.62x39MM Ammo")
	language.Add("7.62x51MM_ammo", "7.62x51MM Ammo")
	language.Add("7.92x57MM_ammo", "7.92x57MM Ammo")
	language.Add(".45ACP_ammo", ".45ACP Ammo")
	language.Add(".50AE_ammo", ".50 AE Ammo")
	language.Add(".338_ammo", ".338 Ammo")
	language.Add(".50BMG_ammo", ".50 BMG Ammo")
	language.Add("12G_ammo", "12 Gauge Ammo")
	language.Add("6G_ammo", "6 Gauge Ammo")
	language.Add(".357_ammo", ".357 Magnum Ammo")
	language.Add("gren_smoke", "Smoke Grenade")
	language.Add("gren_explosive", "Frag Grenade")
	language.Add("40MM_HE_ammo", "40MM High Explosive")
	language.Add("40MM_CE_ammo", "40MM Centered Explosion")
	language.Add("40MM_Smoke_ammo", "40MM Smoke")
	killicon.Add("gren_smoke", "VGUI/bullet", Color(255, 80, 0, 255))
	killicon.Add("gren_explosive", "VGUI/bullet", Color(255, 80, 0, 255))
	killicon.AddFont("cstm_grenade", "CSKillIcons", "O", Color(255, 80, 0, 255))
	//language.Add("MM_ammo", "MM Ammo") -- easy to copy-paste for new ammo types
end