unit w_new;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ColorPickerButton;

type
  TfrmNew = class(TForm)
    gbxSize: TGroupBox;
    gbxColor: TGroupBox;
    edtWidth: TEdit;
    edtHeight: TEdit;
    lblWidth: TLabel;
    lblHeight: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    btnColor: TColorPickerButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNew: TfrmNew;

implementation

uses f_graphics, fipis, globals, main, f_reg;

{$R *.DFM}

procedure TfrmNew.FormClose(Sender: TObject; var Action: TCloseAction);
begin
reg.OpenKey(sReg + '\New',true);
reg.WriteString('Width',edtWidth.Text);
reg.WriteString('Height',edtHeight.Text);
reg.WriteString('Color',ColorToString(btnColor.SelectionColor));
reg.CloseKey();
Action:=caFree;
end;

procedure TfrmNew.FormDestroy(Sender: TObject);
begin
frmNew:=nil;
end;

procedure TfrmNew.btnCancelClick(Sender: TObject);
begin
Close();
end;

procedure TfrmNew.btnOKClick(Sender: TObject);
var
   w,h: integer;
   bmp: TBitmap;
begin
w:=500;
h:=350;
try
   w:=StrToInt(edtWidth.Text);
   h:=StrToInt(edtHeight.Text);
   except
         Abort();
   end;
bmp:=TBitmap.Create();
bmp.Canvas.Brush.Color:=btnColor.SelectionColor;
bmp.Width:=w;
bmp.Height:=h;
CloseImage();
OpenUntitled(bmp);
bmp.Free();
Close();
end;

procedure TfrmNew.FormCreate(Sender: TObject);
begin
reg.OpenKey(sReg + '\New',true);
edtWidth.Text:=RegReadStr('Width','500');
edtHeight.Text:=RegReadStr('Height','350');
btnColor.SelectionColor:=StringToColor(RegReadStr('Color','clWhite'));
reg.CloseKey();
end;

end.
