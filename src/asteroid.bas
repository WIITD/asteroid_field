
Type TAsteroid
  As Vector2 position
  As Vector2 direction
  As Single rot
  As Integer r
  As Integer multiply

  Declare Constructor
  Declare Constructor (_x As Single, _y As Single, _rot As Single, _multiply As Integer, _r As Integer)
  Declare Sub DrawType()
  Declare Sub UpdateType()
  Declare Sub Bounce(_ast As TAsteroid)
  Declare Destructor()
End Type

Constructor TAsteroid()
End Constructor

Constructor TAsteroid(_x As Single, _y As Single, _rot As Single, _multiply As Integer, _r As Integer)
  This.position = Vector2(_x, _y)
  This.rot = _rot
  This.r = _r
  This.multiply = _multiply
  This.direction = Vector2(Sin(_rot), Cos(_rot))
End Constructor

Sub TAsteroid.DrawType()
  DrawCircleLines(This.position.x, This.position.y, This.r, WHITE)
End Sub

Sub TAsteroid.UpdateType()
  ' movement '
  This.position.x += This.direction.x' * This.multiply
  This.position.y += This.direction.y' * This.multiply
  
  ' wrap around the screen '
  If This.position.x - This.r > 800 Then This.position.x = -This.r
  If This.position.x + This.r < 0 Then This.position.x = 800 + This.r
  If This.position.y - This.r > 600 Then This.position.y = -This.r
  If This.position.y + This.r < 0 Then This.position.y = 600 + This.r
End Sub

Sub TAsteroid.Bounce(_ast As TAsteroid)
  Dim As Single _x = This.position.x - _ast.position.x
  Dim As Single _y = This.position.y - _ast.position.y
  Dim As Single _dist = Sqr(_x * _x + _y * _y)
  Dim As Single _rmax = This.r + _ast.r
  If _dist < _rmax Then 
    This.position.x += _x * 0.02
    This.position.y += _y * 0.02
    This.direction.x += _x * 0.02
    This.direction.y += _y * 0.02

    _ast.position.x -= _x * 0.02
    _ast.position.y -= _y * 0.02
    _ast.direction.x -= _x * 0.02
    _ast.direction.y -= _y * 0.02
  End If
End Sub

Destructor TAsteroid
End Destructor
