
local function SwiftTexture( x, y, w, h, col, mat )
  if !CosmicRP.drawtrect then return end
  return CosmicRP.drawtrect( x, y, w, h, col, mat )
end

local function drawLine( startPos, endPos, color )
  surface.SetDrawColor( color )
  surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
end

local ang, pos, offset, alpha, trace, ent, group, group_color, job_min
local Alpha = 255
function DrawName( ply )

  if !ply:Alive() then return end
  
  local drawLocation = Vector( 0, 0, 75 )
  local eyeangles = LocalPlayer():EyeAngles()
  local pos = ply:GetPos() + drawLocation + eyeangles:Up()
  local hpIcon = Material( "cosmic/hp.png", "smooth" )
  local rankIcon = Material( "cosmic/rank.png", "smooth" )
  local idIcon = Material( "cosmic/id.png", "smooth" )
  local jobIcon = Material( "cosmic/job.png", "smooth" )
  local wantedIcon = Material( "cosmic/wanted.png", "smooth" )

  eyeangles:RotateAroundAxis( eyeangles:Forward(), 90 )
  eyeangles:RotateAroundAxis( eyeangles:Right(), 90 )
  if ply:getDarkRPVar("wanted") then
    swiftWanted = Color(200,200,200,255)
  else
    swiftWanted = Color(0,0,0,0)
  end
  
  trace = LocalPlayer():GetEyeTrace()
  ent = trace.Entity

  offset = Vector(0,0,85)
  ang = LocalPlayer():EyeAngles()
  pos = ply:GetPos() + offset + ang:Up()

  dis = LocalPlayer():GetPos():Distance(ply:GetPos())

  ang:RotateAroundAxis(ang:Forward(), 90)
  ang:RotateAroundAxis(ang:Right(), 90)

  if dis > 200 or trace.HitPos:Distance(LocalPlayer():GetShootPos()) > 250 then
    alpha = 0
  else
    alpha = 255
  end

  Alpha = Lerp(2 * FrameTime(), Alpha, alpha)

  cam.Start3D2D( pos, Angle( 0, eyeangles.y, 90 ), 0.10 )
    SwiftTexture( 150, 205, 20, 20, Color(255, 255, 255, Alpha ), idIcon )
    draw.DrawText( ply:GetName(), "cosmicfont32", 175, 200, Color(255, 255, 255, Alpha), TEXT_ALIGN_LEFT )
    SwiftTexture( 150, 232, 20, 20, Color( 255, 255, 255, Alpha ), jobIcon )
    draw.DrawText( ply:getDarkRPVar( "job" ), "cosmicfont32", 175, 227, Color( 255, 255, 255, Alpha ), TEXT_ALIGN_LEFT )
    if ply:getDarkRPVar("wantedReason") then
      draw.DrawText( ply:getWantedReason(), "cosmicfont32", 0, -32, Color( 255, 255, 255, Alpha ), TEXT_ALIGN_CENTER )
    end
  cam.End3D2D() 
end

hook.Add( "PostPlayerDraw", "DrawName", DrawName )