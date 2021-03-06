----------
-- Payday 2 GoonMod, Weapon Customizer Beta, built on 12/30/2014 6:10:13 PM
-- Copyright 2014, James Wilkinson, Overkill Software
----------

-- Mod Definition
local Mod = class( BaseMod )
Mod.id = "IronsightSensitivity"
Mod.Name = "Ironsight Normalized Sensitivity"
Mod.Desc = "Lower the sensitivity when using ironsights to more accurately place your shots"
Mod.Requirements = {}
Mod.Incompatibilities = {}

Hooks:Add("GoonBaseRegisterMods", "GoonBaseRegisterMutators_" .. Mod.id, function()
	GoonBase.Mods:RegisterMod( Mod )
end)

if not Mod:IsEnabled() then
	return
end

-- Options
GoonBase.Options.IronsightSensitivity = GoonBase.Options.IronsightSensitivity or {}
GoonBase.Options.IronsightSensitivity.Enabled = true

-- Localization
local Localization = GoonBase.Localization
Localization.OptionsMenu_ZoomSensitivityTitle = "Enabled Ironsight Normalized Sensitivity"
Localization.OptionsMenu_ZoomSensitivityMessage = "Lower the sensitivity when using ironsights to more accurately place your shots"

-- Add options to menu
Hooks:Add("MenuManagerSetupGoonBaseMenu", "MenuManagerSetupGoonBaseMenu_" .. Mod:ID(), function( menu_manager )

	local success, err = pcall(function()

		MenuCallbackHandler.toggle_zoom_sensitivity = function(this, item)
			GoonBase.Options.IronsightSensitivity.Enabled = item:value() == "on" and true or false
			GoonBase.Options:Save()
		end

		GoonBase.MenuHelper:AddToggle({
			id = "toggle_zoom_sensitivity",
			title = "OptionsMenu_ZoomSensitivityTitle",
			desc = "OptionsMenu_ZoomSensitivityMessage",
			callback = "toggle_zoom_sensitivity",
			value = GoonBase.Options.IronsightSensitivity.Enabled,
			menu_id = "goonbase_options_menu"
		})

	end)
	if not success then PrintTable(err) end

end)

Hooks:Add( "MenuManagerSetMouseSensitivity", "MenuManagerSetMouseSensitivity_" .. Mod:ID(), function( menu_manager, zoomed )

	if GoonBase.Options.IronsightSensitivity == nil or not GoonBase.Options.IronsightSensitivity.Enabled then
		return
	end

	-- Zoom sensitivity calculations by Frankelstner
	local sens = managers.user:get_setting("camera_sensitivity")
	if zoomed and alive( managers.player:player_unit() ) then
			local currentState = managers.player:player_unit():movement():current_state()
			if alive(currentState._equipped_unit) then
				local fovMul = managers.user:get_setting( "fov_multiplier" )
				sens = sens * ( currentState._equipped_unit:base():zoom() or 65 ) * (fovMul + 1) / 2 / ( 65 * fovMul )
			end
	end
	menu_manager._controller:get_setup():get_connection("look"):set_multiplier(sens * menu_manager._look_multiplier)
	managers.controller:rebind_connections()

end )
-- END OF FILE
