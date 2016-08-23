unit athread;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Forms;

type
  TAnimationThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure FrameCycle();
    procedure SendResult;
    procedure JustEnded;
  end;

var
   frame: hBitmap;

implementation

uses main, f_anim, globals, fipis, f_ui;

procedure TAnimationThread.Execute;
var
   i: integer;
begin
FreeOnTerminate:=true;
// endless loop
i:=1;
repeat begin
       if Terminated then Break;
       if not Terminated then FrameCycle();
       if ((Terminated) or (frame=0)) then Break;
       end;
until i=0;
// terminating
Synchronize(JustEnded);
thrAnim:=nil;
end;

procedure TAnimationThread.FrameCycle();
var
   delay: integer;
begin
if not Terminated then infAnim.FIPISanimGetFrame(frame,delay);
if frame<>0 then begin
                 if not Terminated then Synchronize(SendResult);
                 if not Terminated then sleep(delay);
                 end;
end;

procedure TAnimationThread.SendResult;
begin
frmMain.imgMain.Picture.Bitmap.Handle:=frame;
frmMain.imgMain.Invalidate();
if infSettings.full_screen then Center();
end;

procedure TAnimationThread.JustEnded;
begin
ATuneUI(false);
end;

end.
