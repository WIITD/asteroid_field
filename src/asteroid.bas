
Type TAsteroid
  As Single x
  As Single y
  As Single dx
  As Single dy
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
  This.x = _x
  This.y = _y
  This.rot = _rot
  This.r = _r
  This.multiply = _multiply
  This.dx = Sin(_rot)
  This.dy = Cos(_rot)
End Constructor

Sub TAsteroid.DrawType()
  Circle (This.x, This.y), This.r, 15
End Sub

Sub TAsteroid.UpdateType()
  ' movement '
  This.x += This.dx' * This.multiply
  This.y += This.dy' * This.multiply
  
  ' wrap around the screen '
  If This.x - This.r > 800 Then This.x = -This.r
  If This.x + This.r < 0 Then This.x = 800 + This.r
  If This.y - This.r > 600 Then This.y = -This.r
  If This.y + This.r < 0 Then This.y = 600 + This.r
End Sub

Sub TAsteroid.Bounce(_ast As TAsteroid)
  Dim As Single _x = This.x - _ast.x
  Dim As Single _y = This.y - _ast.y
  Dim As Single _dist = Sqr(_x * _x + _y * _y)
  Dim As Single _rmax = This.r + _ast.r
  If _dist < _rmax Then 
    This.x += _x * 0.02
    This.y += _y * 0.02
    This.dx += _x * 0.02
    This.dy += _y * 0.02

    _ast.x -= _x * 0.02
    _ast.y -= _y * 0.02
    _ast.dx -= _x * 0.02
    _ast.dy -= _y * 0.02
  End If
End Sub

Destructor TAsteroid
End Destructor
