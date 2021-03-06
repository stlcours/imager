unit w_save_JPEG2K;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, c_const, c_reg;

type
  TfrmJPsave = class(TForm)
    cbxLossless: TCheckBox;
    gbxCompression: TGroupBox;
    btnSave: TButton;
    btnCancel: TButton;
    lblQualityValue: TLabel;
    tbrQuality: TTrackBar;
    procedure cbxLosslessKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxLosslessClick(Sender: TObject);
    procedure cbxLosslessMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tbrQualityChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
  public
    jp2_confirm: boolean;
  end;

var
  frmJPsave: TfrmJPsave;


implementation

{$R *.dfm}

procedure TfrmJPsave.cbxLosslessKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  tbrQuality.Enabled := (not cbxLossless.Checked);
  lblQualityValue.Enabled := (not cbxLossless.Checked);
end;

procedure TfrmJPsave.cbxLosslessClick(Sender: TObject);
begin
  tbrQuality.Enabled := (not cbxLossless.Checked);
  lblQualityValue.Enabled := (not cbxLossless.Checked);
end;

procedure TfrmJPsave.cbxLosslessMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  tbrQuality.Enabled := (not cbxLossless.Checked);
  lblQualityValue.Enabled := (not cbxLossless.Checked);
end;

procedure TfrmJPsave.btnSaveClick(Sender: TObject);
begin
  FxRegWInt('JPEG2000_Quality', tbrQuality.Position);
  FxRegWBool('JPEG2000_Lossless', cbxLossless.Checked);

  jp2_confirm := true;
  Self.Close();
end;

procedure TfrmJPsave.btnCancelClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TfrmJPsave.tbrQualityChange(Sender: TObject);
begin
  lblQualityValue.Caption := IntToStr(tbrQuality.Position);
end;

procedure TfrmJPsave.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Self.Close();
end;

procedure TfrmJPsave.FormCreate(Sender: TObject);
begin
  jp2_confirm := false;

  tbrQuality.Position := FxRegRInt('JPEG2000_Quality', 50);
  cbxLossless.Checked := FxRegRBool('JPEG2000_Lossless', true);

  cbxLosslessClick(Self);
end;

end.
