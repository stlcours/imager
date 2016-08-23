library fxjpeglossless;

uses
  FastMM,
  Windows,
  SysUtils,
  Classes,
  Forms,
  c_const,
  c_locales,
  ImageEnIO,
  rotate in 'rotate.pas' {frmJPEG};

{$R *.RES}

function FxImgQuery(plugin_path: PChar; info_call: TPlugInCallBack; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
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

    info_call(PT_FNAME, 'JPEG Lossless Tools Plug-in', '');

	info_call(PT_FTOOL, PChar(LoadLStr(3401)), ' ');
end;

function FxImgTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	temp_res: TFxImgResult;
    io: TImageEnIO;
    markers: TIEJpegCopyMarkers;
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

    io := TImageEnIO.Create(nil);
    io.ParamsFromFile(PChar(document_path));

    if ((not io.Aborting) and (io.Params.FileType = ioJPEG)) then
    	begin
        if (((io.Params.Width mod 8) <> 0) or ((io.Params.Height mod 8) <> 0)) then
        	MessageBox(wnd, PChar(LoadLStr(3413)), sAppName, MB_OK or MB_ICONWARNING);

    	frmJPEG := TfrmJPEG.Create(Application);
    	frmJPEG.ShowModal();

        if (apply_transf) then
        	begin
            if (transf = jtNone) then
            	markers := jcCopyNone
            else
            	markers := jcCopyAll;

            JpegLosslessTransform(document_path, ChangeFileExt(String(document_path), LoadLStr(3403) + '.jpg'), transf, false, markers, Rect(0, 0, 0, 0));

    		Result.result_type := RT_INT;
    		Result.result_value := 1;
            StrLCopy(Result.result_string_data, PChar(ChangeFileExt(String(document_path), LoadLStr(3403) + '.jpg')), 2048);
            end;

    	FreeAndNil(frmJPEG);
        end
    else
        MessageBox(wnd, PChar(LoadLStr(3402)), sAppName, MB_OK or MB_ICONWARNING);

    FreeAndNil(io);
end;

exports
	FxImgQuery, FxImgTool;

begin
end.
 