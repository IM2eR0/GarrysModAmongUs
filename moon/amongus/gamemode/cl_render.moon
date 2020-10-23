GM.Render = {}

fitImage = (material, w, h) ->
	if texture = material\GetTexture "$basetexture"
		width = texture\GetMappingWidth!
		height = texture\GetMappingHeight!

		imgAspect = width / height
		containerAspect = w / h

		if imgAspect > containerAspect
			h = w / imgAspect
		elseif imgAspect < containerAspect
			w = h * imgAspect

	return w, h

GM.Render.FitMaterial = fitImage

GM.Render.DermaFitImage = (w, h) =>
	with @
		if .Image
			newWidth, newHeight = fitImage .Image, w, h

			surface.SetMaterial .Image
			surface.SetDrawColor .Color or Color 255, 255, 255

			render.PushFilterMag TEXFILTER.ANISOTROPIC
			render.PushFilterMin TEXFILTER.ANISOTROPIC
			surface.DrawTexturedRect w/2 - newWidth/2, h/2 - newHeight/2, newWidth, newHeight
			render.PopFilterMag!
			render.PopFilterMin!

hide = {
	"CHudCrosshair": true
	"CHudHealth": true
	"CHudBattery": true
	"CHudWeaponSelection": true
}

hook.Add "HUDShouldDraw", "NMW AU HideHud", (element) ->
	if hide[element]
		false

hook.Add "Tick", "NMW AU Light", ->
	if not IsValid LocalPlayer!
		return

	with dlight = DynamicLight LocalPlayer!\EntIndex!
		.pos = LocalPlayer!\GetShootPos!
		.r = 127
		.g = 127
		.b = 127
		.brightness = 2
		.Decay = 0
		.Size = 200
		.DieTime = CurTime! + 0.25

	-- screw implicit returns man
	return

hook.Add "CalcView", "NMW AU CalcView", ( ply, pos, angles, fov ) ->
	newOrigin = if GAMEMODE.GameData.Vented
		ply\GetPos! + Vector 0, 0, 10
	else
		pos - Vector 0, 0, 15

	return {
		origin: newOrigin
		:angles
		:fov
	}

color_kill = Color 255, 0, 0
color_use   = Color 255, 255, 255
color_task  = Color 255, 255, 255, 32

hook.Add "PreDrawHalos", "NMW AU Highlight", ->
	-- Highlight our current tasks.
	for _, task in pairs GAMEMODE.GameData.MyTasks
		if not task.completed and IsValid(task.entity) and task.entity ~= GAMEMODE.UseHighlight and task.entity\GetPos!\Distance(LocalPlayer!\GetPos!) < 200
			halo.Add { task.entity }, color_task, 6, 6, 2, true, true

	if IsValid GAMEMODE.KillHighlight
		halo.Add { GAMEMODE.KillHighlight }, color_kill, 6, 6, 2, true, true

	if IsValid GAMEMODE.UseHighlight
		halo.Add { GAMEMODE.UseHighlight }, color_use, 6, 6, 2, true, true
