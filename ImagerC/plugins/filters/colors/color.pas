unit color;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls;

type
  TfrmColor = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    sbxPreview: TScrollBox;
    trbRed: TTrackBar;
    imgPreview: TImage;
    trbGreen: TTrackBar;
    trbBlue: TTrackBar;
    lblValRed: TLabel;
    lblRed: TLabel;
    lblGreen: TLabel;
    lblBlue: TLabel;
    lblValGreen: TLabel;
    lblValBlue: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FIPISfilter(info: PChar; app: THandle; img: hBitmap):hBitmap; stdcall;

var
  frmColor: TfrmColor;
  bmp: TBitmap;
  canceled: boolean = true;

const
    MaxPixelCount   =  32768;

type
    pRGBArray  =  ^TRGBArray;
    TRGBArray  =  ARRAY[0..MaxPixelCount-1] OF TRGBTriple;

function Min(a, b: integer): integer;
function Max(a, b: integer): integer;

implementation

{$R *.DFM}

function FIPISfilter(info: PChar; app: THandle; img: hBitmap):hBitmap;
var
   local: TBitmap;
begin
// tuning form
Application.Handle:=app;
// tuning bitmap
bmp:=TBitmap.Create();
bmp.Handle:=img;
bmp.PixelFormat:=pf24bit;
local:=TBitmap.Create();
local.Assign(local);
// starting
frmColor:=TfrmColor.Create(Application);
frmColor.ShowModal();
frmColor.Free();
// ending
if canceled then Result:=0 else begin
                                local.Assign(bmp);
                                Result:=local.ReleaseHandle();
                                end;
bmp.Free();
local.Free();
end;


procedure TfrmColor.TrackBarChange(Sender: TObject);
var
   i, j, RedValue, GreenValue, BlueValue: integer;
   OrigRow, DestRow: pRGBArray;
begin
// get brightness increment value
RedValue:=trbRed.Position;
GreenValue:=trbGreen.Position;
BlueValue:=trbBlue.Position;

if RedValue<=0 then lblValRed.Caption:=IntToStr(RedValue) else lblValRed.Caption:=Format('+%d',[RedValue]);
if GreenValue<=0 then lblValGreen.Caption:=IntToStr(GreenValue) else lblValGreen.Caption:=Format('+%d',[GreenValue]);
if BlueValue<=0 then lblValBlue.Caption:=IntToStr(BlueValue) else lblValBlue.Caption:=Format('+%d',[BlueValue]);

// for each row of pixels
for i:=0 to (bmp.Height-1) do begin
                              OrigRow:=bmp.ScanLine[i];
                              DestRow:=imgPreview.Picture.Bitmap.ScanLine[i];
                              // for each pixel in row
                              for j:=0 to (bmp.Width-1) do begin
                                                           // add brightness value to pixel's RGB values
                                                           if RedValue>0 then DestRow[j].rgbtRed:=Min(255,OrigRow[j].rgbtRed + RedValue) else DestRow[j].rgbtRed:=Max(0,OrigRow[j].rgbtRed + RedValue);
                                                           if GreenValue>0 then DestRow[j].rgbtGreen:=Min(255,OrigRow[j].rgbtGreen + GreenValue) else DestRow[j].rgbtGreen:=Max(0,OrigRow[j].rgbtGreen + GreenValue);
                                                           if BlueValue>0 then DestRow[j].rgbtBlue:=Min(255,OrigRow[j].rgbtBlue + BlueValue) else DestRow[j].rgbtBlue:=Max(0,OrigRow[j].rgbtBlue + BlueValue);
                                                           end;
                              end;
imgPreview.Repaint;
end;

function Min(a, b: integer): integer;
begin
  if a<b then result:=a
  else result:=b;
end;

function Max(a, b: integer): integer;
begin
  if a>b then result:=a
  else result:=b;
end;

procedure TfrmColor.btnCancelClick(Sender: TObject);
begin
Close();
end;

procedure TfrmColor.btnOKClick(Sender: TObject);
begin
canceled:=false;
bmp.Assign(imgPreview.Picture.Bitmap);
Close();
end;

procedure TfrmColor.FormCreate(Sender: TObject);
begin
// loading image
imgPreview.Picture.Bitmap.Assign(bmp);
end;

end.
