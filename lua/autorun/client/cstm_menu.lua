cstmmenu = {}
cstmmenu.PanelB = nil

-- These convars are used to communicate between with the client when the player presses "apply changes"

CreateClientConVar("cstm_accuracymod_aim_cl", "1", true, true)
CreateClientConVar("cstm_accuracymod_hip_cl", "1", true, true)
CreateClientConVar("cstm_recoilmod_cl", "1", true, true)
CreateClientConVar("cstm_damagemod_cl", "1", true, true)

CreateClientConVar("cstm_att_kobra_cl", "0", true, true)
CreateClientConVar("cstm_att_rreflex_cl", "0", true, true)
CreateClientConVar("cstm_att_eotech_cl", "0", true, true)
CreateClientConVar("cstm_att_aimpoint_cl", "0", true, true)
CreateClientConVar("cstm_att_acog_cl", "0", true, true)
CreateClientConVar("cstm_att_ballistic_cl", "0", true, true)
CreateClientConVar("cstm_att_reflex_cl", "0", true, true)
CreateClientConVar("cstm_att_vertgrip_cl", "0", true, true)
CreateClientConVar("cstm_att_m203_cl", "0", true, true)
CreateClientConVar("cstm_att_bipod_cl", "0", true, true)
CreateClientConVar("cstm_att_lasersight_cl", "0", true, true)
CreateClientConVar("cstm_att_cmag_cl", "0", true, true)

CreateClientConVar("cstm_ammo_incendiary_cl", "0", true, true)
CreateClientConVar("cstm_ammo_ap_cl", "0", true, true)
CreateClientConVar("cstm_ammo_hp_cl", "0", true, true)
CreateClientConVar("cstm_ammo_magnum_cl", "0", true, true)
CreateClientConVar("cstm_ammo_slug_cl", "0", true, true)
CreateClientConVar("cstm_ammo_birdshot_cl", "0", true, true)
CreateClientConVar("cstm_ammo_frag_cl", "0", true, true)
CreateClientConVar("cstm_ammo_smoke_cl", "0", true, true)

function cstmmenu.PanelA(panel)
	panel:ClearControls()
	
	panel:AddControl("Label", {Text = "Crosshair parts control"})
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Dynamic scaling", Command = "cstm_dynamiccrosshair"})
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Left cross", Command = "cstm_leftcross"})
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Right cross", Command = "cstm_rightcross"})
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Lower cross", Command = "cstm_lowercross"})
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Upper cross", Command = "cstm_uppercross"})
	panel:AddControl("Label", {Text = "Outline crosshair parts colour"})
	panel:AddControl("Color", {Label = "Outline crosshair color", Red = "cstm_out_r", Green = "cstm_out_g", Blue = "cstm_out_b", Alpha = "cstm_out_a", ShowAlpha = false, ShowHSV = true, ShowRGB = true, NumberMultiplier = "1"})
	panel:AddControl("Label", {Text = "Inline crosshair parts colour"})
	panel:AddControl("Color", {Label = "Inline crosshair color", Red = "cstm_in_r", Green = "cstm_in_g", Blue = "cstm_in_b", Alpha = "cstm_in_a", ShowAlpha = true, ShowHSV = true, ShowRGB = true, NumberMultiplier = "1"})
	panel:AddControl("Slider", {Label = "Cross length", Command = "cstm_crosslength", Type = "Integer", Min = 6, Max = 40})
	panel:AddControl("Label", {Text = "Blur effects (Turn on Motion Blur first!)"})
	panel:AddControl("CheckBox", {Label = "BLUR: When aiming?", Command = "cstm_ef_blur_aim"})
	panel:AddControl("CheckBox", {Label = "BLUR: When sprinting?", Command = "cstm_ef_blur_sprint"})
	panel:AddControl("CheckBox", {Label = "BLUR: When reloading?", Command = "cstm_ef_blur_reload"})
	panel:AddControl("CheckBox", {Label = "BLUR: When customizing?", Command = "cstm_ef_blur_customize"})
	panel:AddControl("CheckBox", {Label = "VIEWMODEL BLUR?", Command = "cstm_ef_blur_viewmodel"})
	panel:AddControl("Label", {Text = "Miscellaneous"})
	panel:AddControl("CheckBox", {Label = "GUNFIRE: Additional muzzleflash?", Command = "cstm_ef_extramuzzle"})
	panel:AddControl("CheckBox", {Label = "GUNFIRE: heat?", Command = "cstm_ef_heat"})
	panel:AddControl("CheckBox", {Label = "GUNFIRE: smoke?", Command = "cstm_ef_smoke"})
	panel:AddControl("CheckBox", {Label = "GUNFIRE: sparks?", Command = "cstm_ef_sparks"})
	panel:AddControl("CheckBox", {Label = "EFFECT: Blur lasers?", Command = "cstm_ef_laserblur"})
	panel:AddControl("CheckBox", {Label = "VIEWBOB: upon reload?", Command = "cstm_viewbob_reload"})
	panel:AddControl("CheckBox", {Label = "VIEWBOB: upon draw?", Command = "cstm_viewbob_draw"})
	panel:AddControl("CheckBox", {Label = "VIEWBOB: upon silencer attach/detach?", Command = "cstm_viewbob_silencer"})
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_pitchmod")
	slider:SetValue(GetConVarNumber("cstm_pitchmod"))
	slider:SetText("VIEWBOB: Pitch")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_yawmod")
	slider:SetValue(GetConVarNumber("cstm_yawmod"))
	slider:SetText("VIEWBOB: Yaw")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_rollmod")
	slider:SetValue(GetConVarNumber("cstm_rollmod"))
	slider:SetText("VIEWBOB: Roll")
	
	panel:AddItem(slider)
	
	panel:AddControl("CheckBox", {Label = "MISC: Use different weapon origins?", Command = "cstm_different_origins"})
	panel:AddControl("CheckBox", {Label = "MISC: Use hold-to-aim?", Command = "cstm_hold_to_aim"})
	panel:AddControl("CheckBox", {Label = "MISC: Use additional 'recoil' effect?", Command = "cstm_recoil_head"})
	panel:AddControl("CheckBox", {Label = "MISC: Show attachment description?", Command = "cstm_attdesc"})
	panel:AddControl("CheckBox", {Label = "MISC: Use first-person death?", Command = "cstm_firstpersondeath"})
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_firstpersondeath_speed")
	slider:SetValue(GetConVarNumber("cstm_firstpersondeath_speed"))
	slider:SetText("Fade out speed")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(0)
	slider:SetMin(150)
	slider:SetMax(255)
	slider:SetConVar("cstm_firstpersondeath_alpha")
	slider:SetValue(GetConVarNumber("cstm_firstpersondeath_alpha"))
	slider:SetText("Fade opaque scale")
	
	panel:AddItem(slider)
	
	panel:AddControl("CheckBox", {Label = "HUD: Ammo indicator?", Command = "cstm_hud_ammo"})
	panel:AddControl("CheckBox", {Label = "HUD: Health indicator?", Command = "cstm_hud_health"})
	panel:AddControl("CheckBox", {Label = "HUD: Alternate health indicator?", Command = "cstm_hud_health_different"})
	panel:AddControl("CheckBox", {Label = "HUD: Reload indicator?", Command = "cstm_hud_reloadprogress"})
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(3)
	slider:SetMin(0.005)
	slider:SetMax(0.02)
	slider:SetConVar("cstm_aim_sensitivity")
	slider:SetValue(GetConVarNumber("cstm_aim_sensitivity"))
	slider:SetText("Aim sensitivity")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(3)
	slider:SetMin(0.001)
	slider:SetMax(0.015)
	slider:SetConVar("cstm_aim_sensitivity_acog")
	slider:SetValue(GetConVarNumber("cstm_aim_sensitivity_acog"))
	slider:SetText("ACOG Aim sensitivity")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(3)
	slider:SetMin(0.04)
	slider:SetMax(0.01)
	slider:SetConVar("cstm_aim_sensitivity_ballistic")
	slider:SetValue(GetConVarNumber("cstm_aim_sensitivity_ballistic"))
	slider:SetText("Ballistic Aim sensitivity")
	
	panel:AddItem(slider)
end

function cstmmenu.AdminPanel(panel)
	if not LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "Not an admin - don't look here."})
		return
	end
	
	panel:ClearControls()
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_accuracymod_aim_cl")
	slider:SetValue(GetConVarNumber("cstm_accuracymod_aim_cl"))
	slider:SetText("ACCURACY: Aim")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_accuracymod_hip_cl")
	slider:SetValue(GetConVarNumber("cstm_accuracymod_hip_cl"))
	slider:SetText("ACCURACY: Hip")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_recoilmod_cl")
	slider:SetValue(GetConVarNumber("cstm_recoilmod_cl"))
	slider:SetText("Recoil modifier")
	
	panel:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(2)
	slider:SetConVar("cstm_damagemod_cl")
	slider:SetValue(GetConVarNumber("cstm_damagemod_cl"))
	slider:SetText("Damage modifier")
	
	panel:AddItem(slider)
	
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Kobra?", Description = "", Command = "cstm_att_kobra_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Rifle Reflex?", Description = "", Command = "cstm_att_rreflex_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give EoTech?", Description = "", Command = "cstm_att_eotech_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Aimpoint?", Description = "", Command = "cstm_att_aimpoint_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give ACOG 4x?", Description = "", Command = "cstm_att_acog_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Ballistic 12x?", Description = "", Command = "cstm_att_ballistic_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Docter reflex sight?", Description = "", Command = "cstm_att_reflex_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Foregrip?", Description = "", Command = "cstm_att_vertgrip_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give M203?", Description = "", Command = "cstm_att_m203_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Bipod?", Description = "", Command = "cstm_att_bipod_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give a Laser sight?", Description = "", Command = "cstm_att_lasersight_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give a Beta C-Mag?", Description = "", Command = "cstm_att_cmag_cl"})
	
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Incendiary Ammo?", Description = "", Command = "cstm_ammo_incendiary_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Armor-Piercing Ammo?", Description = "", Command = "cstm_ammo_ap_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Hollow-Point Ammo?", Description = "", Command = "cstm_ammo_hp_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Magnum Ammo?", Description = "", Command = "cstm_ammo_magnum_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Slug Ammo?", Description = "", Command = "cstm_ammo_slug_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Birdshot Ammo?", Description = "", Command = "cstm_ammo_birdshot_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Frag Ammo?", Description = "", Command = "cstm_ammo_frag_cl"})
	panel:AddControl("CheckBox", {Label = "ON SPAWN: Give Smoke Ammo?", Description = "", Command = "cstm_ammo_smoke_cl"})
	
	panel:AddControl("Button", {Label = "Apply Changes", Command = "cstm_applychanges"})
	panel:AddControl("Button", {Label = "Reset Settings", Command = "cstm_resetsettings"})
end

function cstmmenu.OpenSpawnMenu()
	if(cstmmenu.PanelB) then
		cstmmenu.PanelA(cstmmenu.PanelB)
	end
end

hook.Add("SpawnMenuOpen", "cstmmenu.OpenSpawnMenu", cstmmenu.OpenSpawnMenu)

local function CSTM_PopulateAdminMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Customizable Weaponry", "Customizable Weaponry client", "Client", "", "", cstmmenu.PanelA)
	spawnmenu.AddToolMenuOption("Utilities", "Customizable Weaponry", "Customizable Weaponry admin", "Admin", "", "", cstmmenu.AdminPanel)
end
hook.Add("PopulateToolMenu", "CSTM_PopulateAdminMenu", CSTM_PopulateAdminMenu)

local smtext = draw.SimpleText

function draw.ShadowedText(text, font, x, y, color, shadowcolor, shadowdist, al, ar, dynamic)
	if dynamic then
		HP = LocalPlayer():Health() / 100
		color = Color(200, 255 * HP, 150 * HP, 255)
	end
	
	smtext(text, font, x + shadowdist, y + shadowdist, shadowcolor, (al or TEXT_ALIGN_LEFT), (ar or TEXT_ALIGN_CENTER))
	smtext(text, font, x, y, color, (al or TEXT_ALIGN_LEFT), (ar or TEXT_ALIGN_CENTER))
end

local stext, rbox, rboxex, clr, rect, orect, vcret, tid, tex, trect = draw.ShadowedText, draw.RoundedBox, draw.RoundedBoxEx, surface.SetDrawColor, surface.DrawRect, surface.DrawOutlinedRect, vgui.Create, surface.GetTextureID, surface.SetTexture, surface.DrawTexturedRect
local ply, wep, w, h, f, a, att, vm, f2

AttToMdl = {
	["vertgrip"] = {mdl = "models/wystan/attachments/foregrip1.mdl", t = tid("VGUI/entities/upgr_vertgrip"), n = "Foregrip"},
	["laser"] = {mdl = "models/props_c17/FurnitureBoiler001a.mdl", t = tid("VGUI/entities/upgr_lasersight"), n = "Laser sight"},
	["eotech"] = {mdl = "models/wystan/attachments/eotech557sight.mdl", t = tid("VGUI/entities/upgr_eotech557"), n = "EoTech 557"},
	["aimpoint"] = {mdl = "models/wystan/attachments/aimpoint.mdl", t = tid("VGUI/entities/upgr_aimpoint"), n = "Aimpoint"},
	["kobra"] = {mdl = "models/attachments/cmore.mdl", t = tid("VGUI/entities/upgr_kobra"), n = "Kobra"},
	["acog"] = {mdl = "models/wystan/attachments/acog.mdl", t = tid("VGUI/entities/upgr_acog"), n = "ACOG 4x"},
	["grenadelauncher"] = {mdl = "models/wystan/attachments/m203.mdl", t = tid("VGUI/entities/upgr_m203"), n = "M203"},
	["cmag"] = {mdl = "models/wystan/cmag.mdl", t = tid("VGUI/entities/upgr_cmag"), n = "Beta C-Magazine"},
	["reflex"] = {mdl = "models/wystan/attachments/doctorrds.mdl", t = tid("VGUI/entities/upgr_reflexsight"), n = "Docter red-dot sight"},
	["bipod"] = {mdl = "models/wystan/attachments/bipod.mdl", t = tid("VGUI/entities/upgr_bipod"), n = "Bipod"},
	["riflereflex"] = {mdl = "models/attachments/kascope.mdl", t = tid("VGUI/entities/upgr_riflereflex"), n = "Reflex sight"},
	["ballistic"] = {mdl = "models/bunneh/scope01.mdl", t = tid("VGUI/entities/upgr_ballistic"), n = "Ballistic 12x"}}
	
local AttDesc = {
	["kobra"] = {
		[1] = {t = "Provides a bright red three-part reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Slightly increases aim zoom.", c = Color(150, 255, 150, 255)}},
	
	["riflereflex"] = {
		[1] = {t = "Provides a bright red reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Slightly increases aim zoom.", c = Color(150, 255, 150, 255)}},
		
	["reflex"] = {
		[1] = {t = "Provides a bright red reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Slightly increases aim zoom.", c = Color(150, 255, 150, 255)}},
		
	["eotech"] = {
		[1] = {t = "Provides a bright red sphere-like reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Slightly increases aim zoom.", c = Color(150, 255, 150, 255)}},
		
	["aimpoint"] = {
		[1] = {t = "Provides a bright red reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Moderately increases aim zoom.", c = Color(150, 255, 150, 255)}},
		
	["acog"] = {
		[1] = {t = "Good aim zoom increase.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Provides a chevron upside-down 'V' reticle to enhance aiming.", c = Color(150, 255, 150, 255)},
		[3] = {t = "Has back up sights that can be used by double tapping your USE KEY while aiming.", c = Color(150, 255, 150, 255)},
		[4] = {t = "Can be disorienting when engaging targets at close range.", c = Color(255, 110, 96, 255)}},
		
	["ballistic"] = {
		[1] = {t = "Greatly increases aim zoom.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Magnification levels can be adjusted with the mouse wheel.", c = Color(150, 255, 150, 255)},
		[3] = {t = "Is very disorienting when engaging targets at close range.", c = Color(255, 110, 96, 255)}},
		
	["vertgrip"] = {
		[1] = {t = "Decreases maximum spread from continuous fire by 50%", c = Color(150, 255, 150, 255)},
		[2] = {t = "Decreases spread increase from movement by 35%", c = Color(150, 255, 150, 255)},
		[3] = {t = "Decreases recoil by 20%", c = Color(150, 255, 150, 255)}},
		
	["bipod"] = {
		[1] = {t = "When deployed:", c = Color(255, 255, 255, 255)},
		[2] = {t = "Decreases recoil by 70% when firing while aiming.", c = Color(150, 255, 150, 255)},
		[3] = {t = "Decreases recoil by 60% when hip-firing.", c = Color(150, 255, 150, 255)},
		[4] = {t = "Increases hip-fire accuracy greatly.", c = Color(150, 255, 150, 255)},
		[5] = {t = "Decreases mouse sensitivity by 25%", c = Color(255, 110, 96, 255)}},
		
	["laser"] = {
		[1] = {t = "Decreases hip-fire spread by 60%", c = Color(150, 255, 150, 255)},
		[2] = {t = "Decreases spread increase from movement by 30%", c = Color(150, 255, 150, 255)},
		[3] = {t = "Decreases spread increase speed from continuous fire by 15%", c = Color(150, 255, 150, 255)}},
		
	["grenadelauncher"] = {
		[1] = {t = "Allows the use of an underslung grenade launcher.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Cannot aim down sights while M203 mode is enabled.", c = Color(255, 110, 96, 255)},
		[3] = {t = "To use - hold USE KEY, press SECONDARY ATTACK KEY and then take aim.", c = Color(255, 255, 255, 255)},
		[4] = {t = "To switch back to rifle mode - hold USE KEY, press SECONDARY ATTACK KEY.", c = Color(255, 255, 255, 255)}},
		
	["cmag"] = {
		[1] = {t = "Increases magazine size to 100 rounds.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Decreases reload speed by 20%", c = Color(255, 110, 96, 255)}}}
		
local AmmoDesc = {
	["Incendiary"] = {
		[1] = {t = "Ignites hit target for 6 seconds.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Deals 70% damage.", c = Color(255, 110, 96, 255)},
		[3] = {t = "Decreases penetrative effectiveness by 25%", c = Color(255, 110, 96, 255)}},
		
	["Armor Piercing"] = {
		[1] = {t = "Deals 130% damage to armored NPCs, players and props.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Increases penetrative effectiveness by 15%", c = Color(150, 255, 150, 255)},
		[3] = {t = "Deals 70% damage to unarmored NPCs or players.", c = Color(255, 110, 96, 255)},},
		
	["Hollow Point"] = {
		[1] = {t = "Deals 130% damage to unarmored NPCs, players.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Deals 70% damage to armored NPCs or players and props.", c = Color(255, 110, 96, 255)},
		[3] = {t = "Decreases penetrative effectiveness by 15%", c = Color(255, 110, 96, 255)}},
		
	["Magnum"] = {
		[1] = {t = "Increases damage by 25%", c = Color(150, 255, 150, 255)},
		[2] = {t = "Increases penetrative effectiveness by 10%", c = Color(150, 255, 150, 255)},
		[3] = {t = "Increases recoil by 25%", c = Color(255, 110, 96, 255)}},
		
	["Slug"] = {
		[1] = {t = "Fires out a single very accurate slug round.", c = Color(150, 255, 150, 255)}},
		
	["Birdshot"] = {
		[1] = {t = "Fires out 12 pellets.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Decreases recoil by 50%.", c = Color(150, 255, 150, 255)},
		[3] = {t = "Greatly decreases accuracy.", c = Color(255, 110, 96, 255)},
		[4] = {t = "Decreases penetrative effectiveness by 50%", c = Color(255, 110, 96, 255)}},
		
	["Frag"] = {
		[1] = {t = "Fires out a single very accurate explosive round.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Greatly affected by gravity.", c = Color(255, 110, 96, 255)},
		[3] = {t = "Much slower than regular bullets.", c = Color(255, 110, 96, 255)}},
		
	["Smoke"] = {
		[1] = {t = "Fires out a single very accurate smoke grenade.", c = Color(150, 255, 150, 255)},
		[2] = {t = "Greatly affected by gravity.", c = Color(255, 110, 96, 255)},
		[3] = {t = "Much slower than regular bullets.", c = Color(255, 110, 96, 255)}}}

local P = {}
local c, desc, entry
local Gradient = surface.GetTextureID("VGUI/gradient")

function P:Init()
	self.Alpha = 0
	self.White = Color(255, 255, 255, 0)
	self.Black = Color(0, 0, 0, 0)
	self.Grey = Color(50, 50, 50, 0)
	self.Blue = Color(84, 141, 255, 0)
end

function P:Paint()
	ply = LocalPlayer()
	wep = ply:GetActiveWeapon()
	
	if not wep.IsCSTMWeapon then
		self:Remove()
		return
	end
	
	if not self.DontRepos then
		vm = ply:GetViewModel()
		
		if IsValid(vm) then
			att = vm:GetAttachment("1").Pos:ToScreen()
			self:SetPos(att.x + 200, att.y + self.Off - 50)
		end
	end
	
	w, h = self:GetSize()
	rbox(6, 0, 0, w, h, self.Grey)
	rboxex(6, 2, 2, w - 4, 15, self.Blue, true, true, false, false)
	stext("[" .. self.Key .. "]", "Default12B", 15, 9, self.White, self.Black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	f = false
	desc = GetConVarNumber("cstm_attdesc")
	
	if self.Key == 1 then
		DisableClipping(true)
			surface.SetDrawColor(0, 0, 0, self.Alpha / 1.275)
			surface.SetTexture(Gradient)
			surface.DrawTexturedRectRotated(150, -23, 300, 26, 180)
			
			stext("[E] - Toggle weapon overview", "BROOP_26", 0, -25, self.White, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		DisableClipping(false)
	end
	
	if wep.Attachments[self.Key] then
		for k, v in pairs(wep.Attachments[self.Key]) do
			entry = wep.VElements[v]
			
			if entry and entry.color.a == 255 then
				stext(AttToMdl[v].n, "Default12B", 30, 9, self.White, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				f = true
				
				if desc > 0 then
					if not self.DescSize or self.DescSize.last != v then -- don't run the size calculations every time
						surface.SetFont("Default12B")
						AddX, AddY = 10, 4
						
						for k2, v2 in pairs(AttDesc[v]) do
							x, y = surface.GetTextSize(v2.t)
							
							if x + 10 > AddX then
								AddX = x + 10
							end
							
							AddY = AddY + 13
						end
						
						self.DescSize = {x = AddX, y = AddY, last = v}
					end
					
					if self.DescSize then
						DisableClipping(true)
							t = self.DescSize
							clr(84, 141, 255, self.Alpha)
							orect(w + 5, 0, t.x, t.y)
							
							clr(50, 50, 50, self.Alpha * 0.8)
							rect(w + 6, 1, t.x - 2, t.y - 2)
							
							for k2, v2 in pairs(AttDesc[v]) do
								v2.c.a = self.Alpha
								stext(v2.t, "Default12B", w + 10, (k2 - 1) * 13 + 8, v2.c, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end
						DisableClipping(false)
					end
				end
			end
		end
	end
	
	if not f then
		stext("None", "Default12B", 30, 9, self.White, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		self.DescSize = nil
	end
	
	if wep.WeaponOverview then
		self.Alpha = Lerp(FrameTime() * 20, self.Alpha, 0)
	else
		self.Alpha = Lerp(FrameTime() * 20, self.Alpha, 255)
	end
	
	self.White.a = self.Alpha / 1.275
	self.Black.a = self.Alpha
	self.Grey.a = self.Alpha / 1.7
	self.Blue.a = self.Alpha
end

vgui.Register("AttachmentSelectionPanel", P, "DPanel")

P = {}

local AddX, AddY, x, y, t, pw, p, pp

function P:Init()
	self.Alpha = 0
	self.White = Color(255, 255, 255, 0)
	self.Black = Color(0, 0, 0, 0)
	self.Grey = Color(50, 50, 50, 0)
	self.Blue = Color(84, 141, 255, 0)
end

function P:Paint()
	if not wep.IsCSTMWeapon then
		self:Remove()
		return
	end
	
	f, f2 = false, false
	ply = LocalPlayer()
	wep = ply:GetActiveWeapon()
	p = self:GetParent()
	a = p.Alpha
	
	if table.HasValue(AttOnMe, self.Att) then
		entry = wep.VElements[self.Att]
		
		if entry and entry.color.a == 255 then
			clr(163, 255, 84, a)
		else
			clr(84, 141, 255, a)
		end
		
		f = true
	else
		clr(255, 95, 10, a)
	end
	
	rect(0, 0, 50, 50)
	
	if not f then
		clr(150, 150, 150, a)
	else
		clr(255, 255, 255, a)
	end
	
	tex(self.Texture)
	trect(1, 1, 48, 48)
end

vgui.Register("AttachmentIcon", P, "DPanel")

-- AMMO SELECTION PANELS

P = {}

function P:Init()
	self.Alpha = 0
	self.White = Color(255, 255, 255, 0)
	self.Black = Color(0, 0, 0, 0)
	self.Grey = Color(50, 50, 50, 0)
	self.Blue = Color(84, 141, 255, 0)
end

function P:Paint()
	ply = LocalPlayer()
	wep = ply:GetActiveWeapon()
	
	if not wep.IsCSTMWeapon then
		self:Remove()
		return
	end
	
	if not self.DontRepos then
		vm = ply:GetViewModel()
		
		if IsValid(vm) then
			att = vm:GetAttachment("1").Pos:ToScreen()
			
			self:SetPos(att.x + 200, att.y + self.Off - 50)
		end
	end
	
	w, h = self:GetSize()
	rbox(6, 0, 0, w, h, self.Grey)
	rboxex(6, 2, 2, w - 4, 15, self.Blue, true, true, false, false)
	stext("[R]", "Default12B", 15, 9, self.White, self.Black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	f = false
	desc = GetConVarNumber("cstm_attdesc")
	
	if wep.AmmoTypes then
		for k, v in pairs(wep.AmmoTypes) do
			if wep.LastAmmo != "Normal" then
				stext(wep.LastAmmo .. " Ammo", "Default12B", 30, 9, self.White, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				f = true
				break
			end
		end
		
		if f then
			if desc > 0 then
				if not self.DescSize or self.DescSize.last != wep.LastAmmo then -- don't run the size calculations every time
					surface.SetFont("Default12B")
					AddX, AddY = 10, 4
					
					if AmmoDesc[wep.LastAmmo] then
						for k2, v2 in pairs(AmmoDesc[wep.LastAmmo]) do
							x, y = surface.GetTextSize(v2.t)
							
							if x + 10 > AddX then
								AddX = x + 10
							end
							
							AddY = AddY + 13
						end
						
						self.DescSize = {x = AddX, y = AddY, last = wep.LastAmmo}
					end
				end
				
				if self.DescSize then
					DisableClipping(true)
						t = self.DescSize
						clr(84, 141, 255, self.Alpha)
						orect(w + 5, 0, t.x, t.y)
						
						clr(50, 50, 50, self.Alpha * 0.8)
						rect(w + 6, 1, t.x - 2, t.y - 2)
						
						for k2, v2 in pairs(AmmoDesc[wep.LastAmmo]) do
							v2.c.a = self.Alpha
							stext(v2.t, "Default12B", w + 10, (k2 - 1) * 13 + 8, v2.c, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end
					DisableClipping(false)
				end
			end
		end
	end
	
	if not f then
		stext("Standard Ammo", "Default12B", 30, 9, self.White, self.Black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		self.DescSize = nil
	end
	
	if wep.WeaponOverview then
		self.Alpha = Lerp(FrameTime() * 20, self.Alpha, 0)
	else
		self.Alpha = Lerp(FrameTime() * 20, self.Alpha, 255)
	end
	
	self.White.a = self.Alpha / 1.275
	self.Black.a = self.Alpha
	self.Grey.a = self.Alpha / 1.7
	self.Blue.a = self.Alpha
end

vgui.Register("AmmoSelectionPanel", P, "DPanel")

P = {}
local Ammo = surface.GetTextureID("VGUI/entities/upgr_lasersight")

function P:Init()
	self.Alpha = 0
	self.White = Color(255, 255, 255, 0)
	self.Black = Color(0, 0, 0, 0)
	self.Grey = Color(50, 50, 50, 0)
	self.Blue = Color(84, 141, 255, 0)
end

function P:Paint()
	if not wep.IsCSTMWeapon then
		self:Remove()
		return
	end
	
	f, f2 = false, false
	ply = LocalPlayer()
	wep = ply:GetActiveWeapon()
	p = self:GetParent()
	a = p.Alpha
	
	if table.HasValue(AmmoOnMe, self.Ammo) then
		if wep.LastAmmo == AmmoTypes[self.Ammo].name then
			clr(163, 255, 84, a)
		else
			clr(84, 141, 255, a)
		end
		
		f = true
	else
		clr(255, 95, 10, a)
	end
	
	rect(0, 0, 50, 50)
	
	if not f then
		clr(150, 150, 150, a)
	else
		clr(255, 255, 255, a)
	end
	
	tex(Ammo)
	trect(1, 1, 48, 48)
end

vgui.Register("AmmoIcon", P, "DPanel")