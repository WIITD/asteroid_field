#include Once "fbgfx.bi"
#include Once "player.bas"
#include Once "asteroid.bas"
#include Once "fps.bas"

Randomize Timer, 1

Dim Shared As Boolean debug = False
Dim Shared As Long game_tick
Dim Shared As Long game_score
Dim Shared As TFrameTimer fps

Dim Shared As Integer game_state = 0 '' menu -> 0; start -> 1;game -> 2; end -> 3

Dim Shared As FB.EVENT ev
Dim Shared As TPlayer ply = TPlayer(400, 300, 3.14)

Dim Shared As TAsteroid astrs(48)
Dim Shared As Integer astr_count = 5

For i As Integer = 0 To astr_count
  astrs(i) = TAsteroid(Rnd * 800, Rnd * 600 , Rnd * 6.28, (Rnd * 3) + 1, (Rnd * 40) + 10)
Next i

Dim Shared As Integer starsx(32)
Dim Shared As Integer starsy(32)

For i As Integer = 1 To 32
  starsx(i) = Rnd * 800
  starsy(i) = Rnd * 600
Next i

Declare Sub DebugPrint(_var As Boolean)

' init app '

Screen 19, 256, 0

WindowTitle "asteroid_field"

Do
  ' update '
  fps.Update()
  game_tick += 1
  If ScreenEvent(@ev) Then
    Select Case ev.type
     Case FB.EVENT_KEY_PRESS
            If (ev.scancode = FB.SC_ESCAPE) Then
                End
            End If
            If (ev.scancode = FB.SC_F1) Then
                debug = Not debug
            End If
      Case FB.EVENT_WINDOW_CLOSE
        End
    End Select
  End If
  
  ' game state update '
  Select Case game_state
    ' menu '
    Case 0
      If MultiKey(FB.SC_ENTER) Then game_state = 1
      
      For i As Integer = 0 To astr_count
        astrs(i).UpdateType()
        For j As Integer = 0 To astr_count
          astrs(i).Bounce(astrs(j))
        Next j
      Next i

    ' start '
    Case 1
      For i As Integer = 0 To astr_count
        astrs(i) = TAsteroid(Rnd * 800, -400 , Rnd * 6.28, (Rnd * 3) + 1, (Rnd * 40) + 10)
      Next i

      game_tick = 0
      game_score = 0

      game_state = 2

    ' game '
    Case 2
      For i As Integer = 0 To astr_count
        astrs(i).UpdateType()
        For j As Integer = 0 To astr_count
          astrs(i).Bounce(astrs(j))
        Next j
        If ply.GetCollision(astrs(i)) Then game_state = 3
      Next i
  
      ply.UpdateType()

      If game_tick Mod 250 = 0 Then
        If astr_count <= 48 Then
          astr_count += 1
          astrs(astr_count) = TAsteroid(Rnd * 800, -400 , Rnd * 6.28, (Rnd * 3) + 1, (Rnd * 40) + 10)
        End If
        game_score += 1
      End If
    
    ' end '
    Case 3
      astr_count = 5
      For i As Integer = 0 To 42
        astrs(i) = TAsteroid()
      Next i
      For i As Integer = 0 To astr_count
        astrs(i) = TAsteroid(Rnd * 800, Rnd * 600 , Rnd * 6.28, (Rnd * 3) + 1, (Rnd * 40) + 10)
      Next i

      ply = TPlayer(400, 300, 3.14)

      game_state = 0
      
  End Select

  ' draw '
  ScreenLock
  Cls

  ' game state draw '
  Select Case game_state
    ' menu '
    Case 0
      Draw String (15, 15), "Asteroid Field by WIITD"
      Draw String (30, 40), "Enter to START"
      Draw String (30, 65), "Escape to EXIT"
      
      For i As Integer = 1 To 32
        PSet (starsx(i), starsy(i)), 15
      Next i
      
      For i As Integer = 0 To astr_count
        astrs(i).DrawType()
      Next i
    
    ' game '
    Case 2
      For i As Integer = 1 To 32
        PSet (starsx(i), starsy(i)), 15
      Next i
      For i As Integer = 0 To astr_count
        astrs(i).DrawType()
      Next i
      Draw String (380, 5), "SCORE: " & game_score, 15
      ply.DrawType()
      DebugPrint(debug)
    
  End Select
  
  ScreenUnlock
  Sleep 32, 1
Loop

End

Sub DebugPrint(_var As Boolean)
  If _var Then
    Draw String (5, 5 ),  "dx: " & ply.dx, 2
    Draw String (5, 25),  "dy: " & ply.dy, 2
    Draw String (5, 45),  "rot: " & ply.rot, 15
    Draw String (5, 65),  "vx: " & ply.vx, 15
    Draw String (5, 85),  "vy: " & ply.vy, 15
    Draw String (5, 105), "fps: " & fps.GetFPS(), 15
    Draw String (5, 125), "game tick: " & game_tick, 15
  End If
End Sub

End 
