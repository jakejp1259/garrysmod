local trans = {["MOUSE1"] = "LEFT MOUSE BUTTON",
	["MOUSE2"] = "RIGHT MOUSE BUTTON"}

local function CSTM_GetKeyBind(bind)
	local b = input.LookupBinding(bind)
	
	return b and (" (yours: " .. (trans[b] and trans[b] or string.upper(b)) .. ")") or " (yours: NOT BOUND)"
end

local function CSTM_Controls(ply)
	chat.AddText(Color(141, 201, 0, 255), "-= Customizable Weaponry controls =-")
	chat.AddText(Color(141, 201, 0, 255), "Walk key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+walk") .. " + ", Color(141, 201, 0, 255), "reload key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+reload") .. " - ", Color(0, 157, 255, 255), "attach suppressor. (if possible)")
	chat.AddText(Color(141, 201, 0, 255), "Use key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+use") .. " + ", Color(141, 201, 0, 255), "reload key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+reload") .. " - ", Color(0, 157, 255, 255), "change firemode. (if possible)")
	chat.AddText(Color(141, 201, 0, 255), "Use key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+use") .. " + ", Color(141, 201, 0, 255), "primary attack key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+attack") .. " - ", Color(0, 157, 255, 255), "melee.")
	chat.AddText(Color(141, 201, 0, 255), "Use key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+use") .. " + ", Color(141, 201, 0, 255), "secondary attack key key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+attack2") .. " - ", Color(0, 157, 255, 255), "toggle between M203 and rifle modes. (WHEN SWITCHED TO M203, TAKE AIM TO FIRE OUT A GRENADE)")
	chat.AddText(Color(141, 201, 0, 255), "Walk key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+walk") .. " + ", Color(141, 201, 0, 255), "primary attack key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+attack") .. " - ", Color(0, 157, 255, 255), "quick grenade.")
	chat.AddText(Color(141, 201, 0, 255), "Walk key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+walk") .. " + ", Color(141, 201, 0, 255), "secondary attack key", Color(255, 255, 255, 255), CSTM_GetKeyBind("+attack2") .. " - ", Color(0, 157, 255, 255), "adjust quick grenade fuse time.")
	chat.AddText(Color(141, 201, 0, 255), "Context menu key",  Color(255, 255, 255, 255), CSTM_GetKeyBind("+menu_context") .. " - ", Color(0, 157, 255, 255), "open attachment selection menu. While in the menu press the numbers on your keyboard shown in the brackets to change attachments in that certain group.")
	chat.AddText(Color(141, 201, 0, 255), "Double tap use key (WHILE AIMING DOWN THE SIGHTS)", Color(255, 255, 255, 255), " - ", Color(0, 157, 255, 255), "toggle between current and back up sights. (if the weapon supports it)")
	chat.AddText(Color(141, 201, 0, 255), "Mouse wheel scroll while aiming down the sights of a Ballistic 12x scope", Color(255, 255, 255, 255), " - ", Color(0, 157, 255, 255), "UP - increase magnification; DOWN - decrease magnification.")
end

concommand.Add("cstm_controls", CSTM_Controls)

local function CSTM_FAQ(ply)
	chat.AddText(Color(141, 201, 0, 255), "-= Frequently Asked Questions (FAQ) related to Customizable Weaponry =-")
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "The sub-category 'Weapon Attachments' is nowhere to be seen in my Entities category!")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "There is a certain Lua file limit (or something like that) that won't let the game run any more scripts after it has been reached. Uninstall some addons to fix this issue.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "WHERE DO I GET THE WEAPONS FOUND IN THE RELEASE VIDEO???")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Read the addon description on the Workshop page for once in your fucking life and you'll find out.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "How do I attach an attachment to a weapon?")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Open your Q menu, and go to 'Entities'. Then, find a category called 'Weapon Attachments'. Spawn attachments from there, pick them up by looking at them and pressing your USE KEY. After that, open up the weapon customization menu by pressing your CONTEXT MENU KEY and select the attachments you want by pressing the numbers in the brackets on your keyboard! Simple, isn't it?\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "I cannot see the attachments!")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Some addons conflict with this. As such, you will not be able to see attachments. People with Macs seem to have problems like these too. Sorry, I'm on a PC, so I can't really fix this.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "How can I increase my accuracy?")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "You can: stop moving, crouch down, aim down the sights, fire in short controlled bursts.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "I have 2 red dots when using various attachments.")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "That's because you have another aim2 texture that's interfering with the new one. Search for aim2 and delete all of them (both the .vmts and .vtfs) that are not in the Customizable Weaponry folder.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "I don't have any ammo in reserve for all weapons!")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Spawn the 'Ammokit' SWEP in category 'Throwable Weapons' and throw it on the ground by pressing your PRIMARY ATTACK KEY. After that equip the weapon you want to resupply and stand close to the ammo kit.\n")

	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "The ACOG scope has this reflection on it and I can barely see anything.")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "You have another pair of ACOG model textures in your GMod folder somewhere, which are over-writing the current ACOG lense texture.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "Some weapons in the Extra pack have scopes that don't get removed when I attach a sight on them.")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "You have another weapon addon that's conflicting with the Extra pack's textures.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "Why do some weapons don't support many attachments?")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Because they're not supposed to.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "The key combinations don't work!")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "Your keys aren't bound to the correct commands.\n")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "Can you make this work without the need for Counter-Strike: Source?")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "No.\n")
	
	/*chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "")
	
	chat.AddText(Color(141, 201, 0, 255), "Q: ", Color(255, 255, 255, 255), "")
	chat.AddText(Color(0, 157, 255, 255), "A: ", Color(255, 255, 255, 255), "")*/
end

concommand.Add("cstm_faq", CSTM_FAQ)