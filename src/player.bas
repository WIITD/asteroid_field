#Include "fbgfx.bi"
#Include Once "asteroid.bas"

' player '
Type TPlayer
  As Single x
  As Single y
  As Single rot
  As Single dx
  As Single dy
  As Single vx
  As Single vy
  As Integer r
  As single max_speed

  Declare Constructor(_x As Single, _y As Single, _rot As Single)
  Declare Sub UpdateType()
  Declare Sub DrawType()
  Declare Function GetCollision(_ast As TAsteroid) As Boolean
  Declare Sub DrawCollisionVector(_ast As TAsteroid)
  Declare Destructor()
End Type

Constructor TPlayer(_x As Single, _y As Single, _rot As Single)
  This.x = _x
  This.y = _y
  This.rot = _rot
  This.dx = Sin(_rot)
  This.dy = Cos(_rot)
  This.vx = 0
  This.vy = 0
  This.r = 10
  This.max_speed = 3
End Constructor

Sub TPlayer.UpdateType()
  ' player rotation '
  If MultiKey(FB.SC_LEFT) Or MultiKey(FB.SC_A) Then This.rot += 0.136
  If MultiKey(FB.SC_RIGHT) Or MultiKey(FB.SC_D) Then This.rot -= 0.136
  
  ''If MultiKey(FB.SC_PAGEUP) Then This.r += 1
  ''If MultiKey(FB.SC_PAGEDOWN) Then This.r -= 1
  
  ' speed and direction movement controls '
  If MultiKey(FB.SC_UP) Or MultiKey(FB.SC_W) Then
    This.vx += This.dx * 0.2
    This.vy += This.dy * 0.2
  End If  
  If MultiKey(FB.SC_DOWN) Or MultiKey(FB.SC_S) Then
    This.vx -= This.dx * 0.1
    This.vy -= This.dy * 0.1
  End If
  
  ' player movement '
  This.x += This.vx
  This.y += This.vy
  
  ' wrap around the screen '
  If This.x - This.r > 800 Then This.x = -This.r
  If This.x + This.r < 0 Then This.x = 800 + This.r
  If This.y - This.r > 600 Then This.y = -This.r
  If This.y + This.r < 0 Then This.y = 600 + This.r
  
  ' prevent rotation being larger then 2Pi or smaller then 0 '
  If This.rot > 6.28 Then This.rot = 0
  If This.rot < 0 Then This.rot = 6.28
    
  ' speed bounds '
  If This.vx > This.dx + This.max_speed Then This.vx = This.dx + This.max_speed
  If This.vx < This.dx - This.max_speed Then This.vx = This.dx - This.max_speed
  If This.vy > This.dy + This.max_speed Then This.vy = This.dy + This.max_speed
  If This.vy < This.dy - This.max_speed Then This.vy = This.dy - This.max_speed

  ' calculate movement direction '
  This.dx = Sin(This.rot)
  This.dy = Cos(This.rot)
End Sub


Sub TPlayer.DrawType()
  ''Circle (This.x, This.y), This.r/2, 15
  ''Line (This.x, This.y) - (This.x + This.dx * This.r, This.y + This.dy * This.r), 15
  Line (This.x + This.dx * This.r, This.y + This.dy * This.r) - (This.x + Sin(This.rot + 2.443461) * This.r, This.y + Cos(This.rot + 2.443461) * This.r), 15
  Line (This.x + This.dx * This.r, This.y + This.dy * This.r) - (This.x + Sin(This.rot - 2.443461) * This.r, This.y + Cos(This.rot - 2.443461) * This.r), 15
  Line (This.x + Sin(This.rot + 2.443461) * This.r, This.y + Cos(This.rot + 2.443461) * This.r) - (This.x + Sin(This.rot - 2.443461) * This.r, This.y + Cos(This.rot - 2.443461) * This.r), 15
End Sub

Function TPlayer.GetCollision(_ast As TAsteroid) As Boolean
  Dim As Single _x = This.x - _ast.x
  Dim As Single _y = This.y - _ast.y
  Dim As Single _dist = Sqr(_x * _x + _y * _y)
  Dim As Integer _rmax = This.r / 2 + _ast.r
  If _dist > _rmax Then 
    Return False
  Else
    Return True
  End If
End Function

Destructor TPlayer()
End Destructor
