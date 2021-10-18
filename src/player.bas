#Include "raylib.bi"
#Include Once "asteroid.bas"

' player '
Type TPlayer
  As Vector2 position
  As Vector2 direction
  As Vector2 velocity
  As Single rot
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
  This.position = Vector2(_x, _y)
  This.rot = _rot
  This.direction = Vector2(Sin(_rot), Cos(_rot))
  This.velocity = Vector2(0, 0)
  This.r = 10
  This.max_speed = 3
End Constructor

Sub TPlayer.UpdateType()
  ' player rotation '
  If IsKeyDown(KEY_LEFT) Or IsKeyDown(KEY_A) Then This.rot += 0.136
  If IsKeyDown(KEY_RIGHT) Or IsKeyDown(KEY_D) Then This.rot -= 0.136
  
  ' speed and direction movement controls '
  If IsKeyDown(KEY_UP) Or IsKeyDown(KEY_W) Then
    This.velocity.x += This.direction.x * 0.2
    This.velocity.y += This.direction.y * 0.2
  End If  
  If IsKeyDown(KEY_DOWN) Or IsKeyDown(KEY_S) Then
    This.velocity.x -= This.direction.x * 0.1
    This.velocity.y -= This.direction.y * 0.1
  End If
  
  ' player movement '
  This.position.x += This.velocity.x
  This.position.y += This.velocity.y

  ' wrap around the screen '
  If This.position.x - This.r > 800 Then This.position.x = -This.r
  If This.position.x + This.r < 0 Then This.position.x = 800 + This.r
  If This.position.y - This.r > 600 Then This.position.y = -This.r
  If This.position.y + This.r < 0 Then This.position.y = 600 + This.r
  
  ' prevent rotation being larger then 2Pi or smaller then 0 '
  If This.rot > 6.28 Then This.rot = 0
  If This.rot < 0 Then This.rot = 6.28
    
  ' speed bounds '
  If This.velocity.x > This.direction.x + This.max_speed Then This.velocity.x = This.direction.x + This.max_speed
  If This.velocity.x < This.direction.x - This.max_speed Then This.velocity.x = This.direction.x - This.max_speed
  If This.velocity.y > This.direction.y + This.max_speed Then This.velocity.y = This.direction.y + This.max_speed
  If This.velocity.y < This.direction.y - This.max_speed Then This.velocity.y = This.direction.y - This.max_speed

  ' calculate movement direction '
  This.direction.x = Sin(This.rot)
  This.direction.y = Cos(This.rot)
End Sub


Sub TPlayer.DrawType()
  DrawLine(This.position.x + This.direction.x * This.r, This.position.y + This.direction.y * This.r, This.position.x + Sin(This.rot + 2.443461) * This.r, This.position.y + Cos(This.rot + 2.443461) * This.r, WHITE)
  DrawLine(This.position.x + This.direction.x * This.r, This.position.y + This.direction.y * This.r, This.position.x + Sin(This.rot - 2.443461) * This.r, This.position.y + Cos(This.rot - 2.443461) * This.r, WHITE)
  DrawLine(This.position.x + Sin(This.rot + 2.443461) * This.r, This.position.y + Cos(This.rot + 2.443461) * This.r, This.position.x + Sin(This.rot - 2.443461) * This.r, This.position.y + Cos(This.rot - 2.443461) * This.r, WHITE)
End Sub

Function TPlayer.GetCollision(_ast As TAsteroid) As Boolean
  Dim As Single _x = This.position.x - _ast.position.x
  Dim As Single _y = This.position.y - _ast.position.y
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
