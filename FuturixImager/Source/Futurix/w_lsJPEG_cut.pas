unit w_lsJPEG_cut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmCut = class(TForm)
    trackTop: TTrackBar;
    trackRight: TTrackBar;
    trackLeft: TTrackBar;
    trackBottom: TTrackBar;
    labelPreview: TLabel;
    labelHint: TLabel;
    labelTop: TLabel;
    labelRight: TLabel;
    labelBottom: TLabel;
    labelLeft: TLabel;
    buttonOK: TButton;
    procedure trackTopChange(Sender: TObject);
    procedure buttonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCut: TfrmCut;


implementation

uses w_lsJPEG_rotate;

{$R *.dfm}

procedure TfrmCut.buttonOKClick(Sender: TObject);
begin
  frmJPEG.cut_rect := Rect(trackLeft.Position - 1, trackTop.Position - 1, trackRight.Position - 1, trackBottom.Position - 1);

  Close();
end;

procedure TfrmCut.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmCut.FormCreate(Sender: TObject);
begin
  // setting sizes
  trackTop.Max := frmJPEG.img_height;
  trackRight.Max := frmJPEG.img_width;
  trackBottom.Max := frmJPEG.img_height;
  trackLeft.Max := frmJPEG.img_width;
  trackRight.Position := trackRight.Max;
  trackBottom.Position := trackBottom.Max;

  // preview
  trackTopChange(Self);
end;

procedure TfrmCut.FormDestroy(Sender: TObject);
begin
  frmCut := nil;
end;

procedure TfrmCut.trackTopChange(Sender: TObject);
begin
  if trackTop.Position > trackBottom.Position then
    trackBottom.Position := trackTop.Position;

  if trackLeft.Position > trackRight.Position then
    trackRight.Position := trackLeft.Position;

  labelPreview.Caption :=
    IntToStr(trackLeft.Position) + ' x ' + IntToStr(trackTop.Position) +
    ' to ' +
    IntToStr(trackRight.Position) + ' x ' + IntToStr(trackBottom.Position);
end;

end.
