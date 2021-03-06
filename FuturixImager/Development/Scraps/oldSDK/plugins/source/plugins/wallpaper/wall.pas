unit wall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TileImage, c_const, c_locales;

type
  TfrmWallpaper = class(TForm)
    pnlButtons: TPanel;
    sbxWall: TScrollBox;
    tilWall: TTileImage;
    btnOK: TButton;
    btn800x600: TButton;
    btn1024x768: TButton;
    btn1280x1024: TButton;
    btn1600x1200: TButton;
    btn640x480: TButton;
    btn3000x2250: TButton;
    edtCustWidth: TEdit;
    edtCustHeight: TEdit;
    btnSetCustom: TButton;
    lblCustom: TLabel;
    lblX: TLabel;
    pnlClose: TPanel;
    btn1920x1200: TButton;
    btn3200x1200: TButton;
    btn2560x1024: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btn640x480Click(Sender: TObject);
    procedure btn800x600Click(Sender: TObject);
    procedure btn1024x768Click(Sender: TObject);
    procedure btn1280x1024Click(Sender: TObject);
    procedure btn1600x1200Click(Sender: TObject);
    procedure btn3000x2250Click(Sender: TObject);
    procedure btnSetCustomClick(Sender: TObject);
    procedure btn1920x1200Click(Sender: TObject);
    procedure btn3200x1200Click(Sender: TObject);
    procedure btn2560x1024Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

function FxImgQuery(plugin_path: PChar; info_call: TPlugInCallBack; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
function FxImgTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;

var
	frmWallpaper: TfrmWallpaper;
	image: TBitmap;


implementation

uses swall;

{$R *.DFM}

function FxImgQuery(plugin_path: PChar; info_call: TPlugInCallBack; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
	temp_res: TFxImgResult;
begin
    Result.result_type := RT_BOOL;
    Result.result_value := FX_TRUE;

    if (@app_query <> nil) then
        begin
    	temp_res := app_query(CQ_GETLANGLIBS, 0, 0);

        if (temp_res.result_type = RT_HANDLE) then
        	begin
            locale_lib := temp_res.result_value;
            backup_lib := temp_res.result_xtra;
            end;
        end;

    info_call(PT_FNAME, 'Wallpaper tools', '');

	info_call(PT_FTOOL, PChar(LoadLStr(3000)), ' ');
	info_call(PT_FTOOL, PChar(LoadLStr(3001)), ' ');
end;

function FxImgTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
	temp_res: TFxImgResult;
begin
    Result.result_type := RT_BOOL;
    Result.result_value := FX_TRUE;

	Application.Handle := app;

    if (@app_query <> nil) then
        begin
    	temp_res := app_query(CQ_GETLANGLIBS, 0, 0);

        if (temp_res.result_type = RT_HANDLE) then
        	begin
            locale_lib := temp_res.result_value;
            backup_lib := temp_res.result_xtra;
            end;
        end;

	image := TBitmap.Create();
	image.Handle := img;

    if (String(info) = LoadLStr(3000)) then
    	begin
		frmWallpaper := TfrmWallpaper.Create(Application);
		frmWallpaper.tilWall.Picture.Assign(image);
		frmWallpaper.ShowModal();
    	FreeAndNil(frmWallpaper);
    	end
    else
    	begin
		frmWallpaperS := TfrmWallpaperS.Create(Application);
		frmWallpaperS.ShowModal();
		FreeAndNil(frmWallpaperS);
        end;

	FreeAndNil(image);
end;

procedure TfrmWallpaper.btnOKClick(Sender: TObject);
begin
	Close();
end;

procedure TfrmWallpaper.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

procedure TfrmWallpaper.FormDestroy(Sender: TObject);
begin
	frmWallpaper := nil;
end;

procedure TfrmWallpaper.btn640x480Click(Sender: TObject);
begin
	tilWall.Width := 640;
	tilWall.Height := 480;

	edtCustWidth.Text := '640';
	edtCustHeight.Text := '480';
end;

procedure TfrmWallpaper.btn800x600Click(Sender: TObject);
begin
	tilWall.Width := 800;
	tilWall.Height := 600;

	edtCustWidth.Text := '800';
	edtCustHeight.Text := '600';
end;

procedure TfrmWallpaper.btn1024x768Click(Sender: TObject);
begin
	tilWall.Width := 1024;
	tilWall.Height := 768;

	edtCustWidth.Text := '1024';
	edtCustHeight.Text := '768';
end;

procedure TfrmWallpaper.btn1280x1024Click(Sender: TObject);
begin
	tilWall.Width := 1280;
	tilWall.Height := 1024;

	edtCustWidth.Text := '1280';
	edtCustHeight.Text := '1024';
end;

procedure TfrmWallpaper.btn1600x1200Click(Sender: TObject);
begin
	tilWall.Width := 1600;
	tilWall.Height := 1200;

	edtCustWidth.Text := '1600';
	edtCustHeight.Text := '1200';
end;

procedure TfrmWallpaper.btn3000x2250Click(Sender: TObject);
begin
	tilWall.Width := 3000;
	tilWall.Height := 2250;

	edtCustWidth.Text := '3000';
	edtCustHeight.Text := '2250';
end;

procedure TfrmWallpaper.btnSetCustomClick(Sender: TObject);
var
	tmp_w, tmp_h: integer;
begin
	tmp_w := 768;
	tmp_h := 576;

	try
  		tmp_w := StrToInt(edtCustWidth.Text);
  		tmp_h := StrToint(edtCustHeight.Text);
  		except
  			on EConvertError do
    			Abort();
  			else
        		Abort();
  		end;

	tilWall.Width := tmp_w;
	tilWall.Height := tmp_h;
end;

procedure TfrmWallpaper.btn1920x1200Click(Sender: TObject);
begin
	tilWall.Width := 1920;
	tilWall.Height := 1200;

	edtCustWidth.Text := '1920';
	edtCustHeight.Text := '1200';
end;

procedure TfrmWallpaper.btn3200x1200Click(Sender: TObject);
begin
	tilWall.Width := 3200;
	tilWall.Height := 1200;

	edtCustWidth.Text := '3200';
	edtCustHeight.Text := '1200';
end;

procedure TfrmWallpaper.btn2560x1024Click(Sender: TObject);
begin
	tilWall.Width := 2560;
	tilWall.Height := 1024;

	edtCustWidth.Text := '2560';
	edtCustHeight.Text := '1024';
end;

procedure TfrmWallpaper.FormCreate(Sender: TObject);
begin
	Self.Caption			:= LoadLStr(3002);

    lblCustom.Caption		:= LoadLStr(3003);
    lblX.Caption			:= LoadLStr(3004);

    btnSetCustom.Caption	:= LoadLStr(3006);
    btnOK.Caption			:= LoadLStr(54);

    btn640x480.Caption		:= Format(LoadLStr(3005), [IntToStr(640), IntToStr(480)]);
    btn800x600.Caption		:= Format(LoadLStr(3005), [IntToStr(800), IntToStr(600)]);
    btn1024x768.Caption		:= Format(LoadLStr(3005), [IntToStr(1024), IntToStr(768)]);
    btn1280x1024.Caption	:= Format(LoadLStr(3005), [IntToStr(1280), IntToStr(1024)]);
    btn1600x1200.Caption	:= Format(LoadLStr(3005), [IntToStr(1600), IntToStr(1200)]);
    btn3000x2250.Caption	:= Format(LoadLStr(3005), [IntToStr(3000), IntToStr(2250)]);
    btn1920x1200.Caption	:= Format(LoadLStr(3005), [IntToStr(1920), IntToStr(1200)]);
    btn3200x1200.Caption	:= Format(LoadLStr(3005), [IntToStr(3200), IntToStr(1200)]);
    btn2560x1024.Caption	:= Format(LoadLStr(3005), [IntToStr(2560), IntToStr(1024)]);
end;

procedure TfrmWallpaper.CreateParams(var Params: TCreateParams);
begin
	Params.Style := (Params.Style or WS_POPUP);

	inherited;

	if (Owner is TForm) then
		Params.WndParent := (Owner as TWinControl).Handle
	else if Assigned(Screen.ActiveForm) then
		Params.WndParent := Screen.ActiveForm.Handle;
end;

exports
	FxImgQuery, FxImgTool;

end.
