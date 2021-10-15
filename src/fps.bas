#IfNDef _FRAMETIMER_AVERAGE_SPAN_
  #Define _FRAMETIMER_AVERAGE_SPAN_ 1.0
#EndIf

Type TFrameTimer
    prev_time As Double
    frame_time As Double
    frame_counter As UInteger
    Declare Constructor()
    Declare Sub Update()
    Declare Function GetFPS() As Integer
    Declare Function GetFrameTime As Double
End Type
Constructor TFrameTimer()
        This.prev_time = Timer
End Constructor

Sub TFrameTimer.Update()
  This.frame_counter+=1
  If Timer > This.prev_time + _FRAMETIMER_AVERAGE_SPAN_ Then
    This.frame_time = (Timer - This.prev_time) / CDbl(This.frame_counter)
    This.frame_counter = 0
    This.prev_time = Timer
  EndIf
End Sub

Function TFrameTimer.GetFPS As Integer
  Return Int(1.0 / This.frame_time)
End Function

Function TFrameTimer.GetFrameTime As Double
  Return This.frame_time
End Function
