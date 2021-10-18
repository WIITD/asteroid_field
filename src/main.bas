#include Once "raylib.bi"
#include Once "player.bas"
#include Once "asteroid.bas"

Randomize Timer, 1

Dim Shared As Boolean debug = False
Dim Shared As Long game_tick
Dim Shared As Long game_score

Dim Shared As Integer game_state = 0 '' menu -> 0; start -> 1;game -> 2; end -> 3

Dim Shared As TPlayer ply = TPlayer(400, 300, 3.14)

Dim Shared As TAsteroid astrs(48)
Dim Shared As Integer astr_count = 5

For i As Integer = 0 To astr_count
  astrs(i) = TAsteroid(Rnd * 800, Rnd * 600 , Rnd * 6.28, (Rnd * 3) + 1, (Rnd * 40) + 10)
Next i

Dim Shared As Vector2 stars(32)

For i As Integer = 0 To 32 
  stars(i).x = Rnd * 800
  stars(i).y = Rnd * 600
Next i

Declare Sub DebugPrint(_var As Boolean)

' init app '

InitWindow(800, 600, "Asteroid Field")
SetTargetFPS(30)

While Not WindowShouldClose()
  ' update '
  game_tick += 1
  If IsKeyPressed(KEY_F1) Then
      debug = Not debug
  End If
  
  ' game state update '
  Select Case game_state
    ' menu '
    Case 0
      If IsKeyPressed(KEY_ENTER) Then game_state = 1
      
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
  BeginDrawing()
  ClearBackground(BLACK)

  ' game state draw '
  Select Case game_state
    ' menu '
    Case 0
      DrawText("Asteroid Field by WIITD", 15, 5, 25, WHITE)
      DrawText("Enter to START", 30, 40, 20, WHITE)
      DrawText("Escape to EXIT", 30, 65, 20, WHITE)
      
      For i As Integer = 1 To 32
        DrawPixel(stars(i).x, stars(i).y, WHITE)
      Next i
      
      For i As Integer = 0 To astr_count
        astrs(i).DrawType()
      Next i
    
    ' game '
    Case 2
      For i As Integer = 1 To 32
        DrawPixel(stars(i).x, stars(i).y, WHITE)
      Next i
      For i As Integer = 0 To astr_count
        astrs(i).DrawType()
      Next i
      DrawText("SCORE: " & game_score, 370, 5, 20, WHITE)
      ply.DrawType()
      DebugPrint(debug)
    
  End Select
  
  EndDrawing()
Wend
CloseWindow()

Sub DebugPrint(_var As Boolean)
  If _var Then
    DrawText("fps: " & GetFPS(), 5, 5, 12, WHITE)
    DrawText("game tick: " & game_tick, 5, 25, 12, WHITE)
  End If
End Sub

End 
