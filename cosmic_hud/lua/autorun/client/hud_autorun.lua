if SERVER then
	resource.AddFile( "resource/fonts/Cocosignum-Maiuscoletto-Regular-trial.ttf" )
	resource.AddFile( "materials/cosmic/armor.png" )
	resource.AddFile( "materials/cosmic/health.png" )
	resource.AddFile( "materials/cosmic/id.png" )
	resource.AddFile( "materials/cosmic/job.png" )
	resource.AddFile( "materials/cosmic/license.png" )
	resource.AddFile( "materials/cosmic/money.png" )
	resource.AddFile( "materials/cosmic/salary.png" )
	return 
end

surface.CreateFont( "cosmicfont16",
{
	font = "Cocosignum Maiuscoletto-Regular", 
	size = 16,
	weight = 250,
	antialias = true,
	strikeout = true,
	additive = true,
	
} )

surface.CreateFont( "cosmicfont18",
{
	font = "Cocosignum Maiuscoletto-Regular", 
	size = 18,
	weight = 250,
	antialias = true,
	strikeout = true,
	additive = true,
	
} )

surface.CreateFont( "cosmicfont24",
{
	font = "Cocosignum Maiuscoletto-Regular", 
	size = 24,
	weight = 250,
	antialias = true,
	strikeout = true,
	bold = true,
	additive = true,
	
} )

surface.CreateFont( "cosmicfont32",
{
	font = "Cocosignum Maiuscoletto-Regular", 
	size = 32,
	weight = 500,
	antialias = true,
	strikeout = true,
	additive = true,
	
} )

surface.CreateFont( "cosmicfont48",
{
	font = "Cocosignum Maiuscoletto-Regular", 
	size = 48,
	weight = 250,
	antialias = true,
	strikeout = true,
	additive = true,
	
} )

-- CONFIG

local healthIcon = Material( "cosmic/health.png", "smooth" )
local moneyIcon = Material( "cosmic/money.png", "smooth" )
local salaryIcon = Material( "cosmic/salary.png", "smooth" )
local jobIcon = Material( "cosmic/job.png", "smooth" )
local armorIcon = Material( "cosmic/armor.png", "smooth" )
local idIcon = Material( "cosmic/id.png", "smooth" )
local licenseIcon = Material( "cosmic/license.png", "smooth" )

local blur = Material( "pp/blurscreen" )

local function drawBlur( x, y, w, h, layers, density, alpha )

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
	
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
		
	end
	
end

local function drawLine( startPos, endPos, color )

	surface.SetDrawColor( color )
	surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
	
end

local function drawRectOutline( x, y, w, h, color )

	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
	
end

CosmicRP = {}

CosmicRP.drawtrect = function( x, y, w, h, col, mat )

	surface.SetDrawColor( col )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x, y, w, h )
	
end

local function CosmicTex( x, y, w, h, col, mat )

	if !CosmicRP.drawtrect then
		return
	end

	return CosmicRP.drawtrect( x, y, w, h, col, mat )
	
end

local function formatCurrency( number )

	local output = number
	
	if number < 1000000 then
	
		output = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1,%2" ) 
	
	else
	
		output = string.gsub( number, "^(-?%d+)(%d%d%d)(%d%d%d)", "%1,%2,%3" )

	end
	
	output = "$" .. output

	return output
	
end


hook.Add( "HUDPaint", "vendetta", function()
	
	local backgroundColor = Color( 0, 0, 0, 225 )

	LocalPlayer().DarkRPVars = LocalPlayer().DarkRPVars or {}
	LocalPlayer().DarkRPVars.money = LocalPlayer().DarkRPVars.money or 0
	LocalPlayer().DarkRPVars.salary = LocalPlayer().DarkRPVars.salary or 0

	drawBlur( 0, 0, ScrW(), 30, 3, 6, 255 )
	draw.RoundedBox( 0, 0, 0, ScrW(), 30, backgroundColor )
	draw.RoundedBox(0, 0, 30, ScrW(), 3, Color(32, 150, 229,255))
	draw.SimpleText( Comsic_Config.ServerName, "cosmicfont24", ScrW() - 10, 4, Color(255,255,255,255), TEXT_ALIGN_RIGHT )

	if LocalPlayer().DarkRPVars then
			
		local currentHealth = LocalPlayer():Health() or 0
		local currentArmor = LocalPlayer():Armor() or 0
		local spacer, newx, newy = 35, 0, 0
		local iconcolor = Color(255,255,255, 255)
		local texHeight = 5
		local textHeight = texHeight + 2
		local mycol = team.GetColor( LocalPlayer():Team() )
		local mycolfixed = Color( math.Clamp(mycol.r * 2, 100, 255), math.Clamp(mycol.g * 2, 100, 255), math.Clamp(mycol.b * 2, 100, 255) )
		
		newx, newy = draw.SimpleText( LocalPlayer():getDarkRPVar("rpname") or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(255,255,255, 150), 0 )
		CosmicTex( 25, texHeight, 20, 20, iconcolor, idIcon )
		spacer = (spacer + newx) + 36
		
		CosmicTex( spacer - 10, texHeight, 20, 20, Color(252, 115, 100, 150), healthIcon )
		newx, newy = draw.SimpleText( currentHealth.."%" or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(252, 115, 100, 150), 0 )
		spacer = (spacer + newx) + 36
		
		CosmicTex( spacer - 10, texHeight, 20, 20, Color(101, 174, 247, 150), armorIcon )
		newx, newy = draw.SimpleText( currentArmor.."%" or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(101, 174, 247, 150), 0 )
		spacer = (spacer + newx) + 36
		
		CosmicTex( spacer - 10, texHeight, 20, 20, iconcolor, jobIcon )
		newx, newy = draw.SimpleText( LocalPlayer():getDarkRPVar( "job" ) or "unnamed", "cosmicfont18", spacer + 15, textHeight, mycolfixed, 0 )
		spacer = (spacer + newx) + 36
		
		CosmicTex( spacer - 10, texHeight, 20, 20, iconcolor, moneyIcon )
		newx, newy = draw.SimpleText( "$"..LocalPlayer():getDarkRPVar( "money" ) or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(150, 249, 147, 150), 0 )
		spacer = (spacer + newx) + 36
		
		CosmicTex( spacer - 10, texHeight, 20, 20, iconcolor, salaryIcon )
		newx, newy = draw.SimpleText( "$"..LocalPlayer():getDarkRPVar( "salary" ) or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(72, 244, 66, 150), 0 )
		spacer = (spacer + newx) + 36 
		
		if LocalPlayer():getDarkRPVar("HasGunlicense") then
			hasLicense = "Gun License"
		else	
			hasLicense = "No License"
		end
		
		CosmicTex( spacer - 10, texHeight, 20, 20, iconcolor, licenseIcon )
		newx, newy = draw.SimpleText( hasLicense or "unnamed", "cosmicfont18", spacer + 15, textHeight, Color(255,255,255, 150), 0 )
		spacer = (spacer + newx) + 36
		
		if LocalPlayer():getDarkRPVar("wantedReason") then
			newx, newy = draw.SimpleText( "You Are Wanted", "cosmicfont18", spacer - 5, textHeight, Color(255,55,55, 150), 0 )
			spacer = (spacer + newx) + 36
		end
	end
	
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		local CurrentWeapon = LocalPlayer():GetActiveWeapon():GetPrintName()
		local ReserveWeapon = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
		local ClipWeapon = LocalPlayer():GetActiveWeapon():Clip1()
		
		if ClipWeapon < 0 then
			ClipWeapon = ""
		end
		
		drawBlur( ScrW() - 100 - 105 - 30, ScrH() - 210 + 175 - 4, 230, 25, 5, 6, 255 )
		draw.RoundedBox( 0, ScrW() - 100 - 105 - 30, ScrH() - 210 + 175 - 3, 230, 25, backgroundColor )
		draw.RoundedBox( 0, ScrW() - 100 - 105 - 30, ScrH() - 210 + 175 + 22, 230, 4, Color(32, 150, 229,255) )
		draw.DrawText (CurrentWeapon, "cosmicfont24", ScrW() - 10, ScrH() - 39, Color (255, 255, 255, 255), TEXT_ALIGN_RIGHT)
	
		
		if LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 then
				
			drawBlur( ScrW() - 125, ScrH() - 69, 120, 20, 5, 6, 255 )
			draw.RoundedBox( 0, ScrW() - 125, ScrH() - 69, 120, 20, backgroundColor )
			draw.RoundedBox( 0, ScrW() - 125, ScrH() - 49, 120, 4, Color(32, 150, 229,255) )
			
			draw.DrawText ( ClipWeapon .. "/" .. ReserveWeapon, "cosmicfont24", ScrW() - 10, ScrH() - 67 -5 , Color (255, 255, 255, 255), TEXT_ALIGN_RIGHT) -- Clip Text
		end
	end
	
end )


local hideHUDElements = {

	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Agenda"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)

	if hideHUDElements[name] then
		return false
	end
	
end)

hook.Add("HUDShouldDraw", "cosmic_hud_removeshit", function(name)

    if name == "CHudAmmo" or name == "CHudHealth" or name == "CHudBattery" then return false end

end)