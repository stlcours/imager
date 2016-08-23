library fxmain;

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  Forms,
  Dialogs,
  ImageEnIO,
  ImageEnProc,
  hyieutils,
  c_const,
  c_utils,
  c_locales,
  c_reg,
  hyiedefs,
  JPEG2Ksave in 'JPEG2Ksave.pas' {frmJPsave},
  TIFFsave in 'TIFFsave.pas' {frmTIFFsave},
  JPEGsave in 'JPEGsave.pas' {frmJPEGsave},
  ScanOptions in 'ScanOptions.pas' {frmScanOpt};

var
    gframe: cardinal = 0;
    gframes: cardinal = 0;
    gfile: string = '';

	pio: TImageEnIO;
    gpage: cardinal = 0;
    gpages: cardinal = 0;
    gfilep: string = '';
    gext: string = '';

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

    info_call(PT_FNAME, 'Core functions', '');
    info_call(PT_FROLE, PR_SCAN, '');
    info_call(PT_FCONFIG, PChar(LoadLStr(3700)), '');

    info_call(PT_FOPEN, 'cur', '');

	info_call(PT_FOPENMULTI, 'dcx', '');
	info_call(PT_FOPENMULTI, 'tif', '');
	info_call(PT_FOPENMULTI, 'tiff', '');

    info_call(PT_FSAVE, 'jp2', '');
    info_call(PT_FSAVE, 'j2k', '');
    info_call(PT_FSAVE, 'bmp', '');
	info_call(PT_FSAVE, 'jpg', '');
	info_call(PT_FSAVE, 'pcx', '');
	info_call(PT_FSAVE, 'png', '');
	info_call(PT_FSAVE, 'pbm', '');
	info_call(PT_FSAVE, 'pgm', '');
	info_call(PT_FSAVE, 'ppm', '');
	info_call(PT_FSAVE, 'tga', '');
	info_call(PT_FSAVE, 'tif', '');
    info_call(PT_FSAVE, 'gif', '');
    info_call(PT_FSAVE, 'pdf', '');
    info_call(PT_FSAVE, 'ps', '');
    info_call(PT_FSAVE, 'txt', '');

    info_call(PT_FIMPORT, PChar(LoadLStr(3080)), ' ');

    info_call(PT_FTOOL, PChar(LoadLStr(3081)), ' ');

    info_call(PT_FDESCR, 'pdf', PChar(LoadLStr(1031)));
    info_call(PT_FDESCR, 'ps', PChar(LoadLStr(1032)));
    info_call(PT_FDESCR, 'cur', PChar(LoadLStr(1033)));
    info_call(PT_FDESCR, 'txt', PChar(LoadLStr(1034)));
end;

function FxImgOpen(document_path, info: PChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	bmp, tmp: TBitmap;
    io: TImageEnIO;
	imh: THandle;
	pic: TPicture;
	iif: TIconInfo;
begin
    Result.result_type := RT_HBITMAP;
    Result.result_value := 0;

    if (LowerCase(ExtractExt(String(document_path))) = 'cur') then
    	begin
		imh := LoadImage(HInstance, document_path, IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTCOLOR);

		if (imh <> 0) then
  			begin
  			bmp := TBitmap.Create();
  			tmp := TBitmap.Create();
  			pic := TPicture.Create();

  			pic.Icon.Handle := imh;
  			GetIconInfo(imh, iif);

  			if (iif.hbmColor <> 0) then
    			tmp.Handle := iif.hbmColor
  			else
    			tmp.Handle := iif.hbmMask;

  			bmp.Width := tmp.Width;
  			bmp.Height := tmp.Height;
  			bmp.Canvas.Draw(0, 0, pic.Graphic);

  			Result.result_value := bmp.ReleaseHandle();

  			FreeAndNil(pic);
  			FreeAndNil(bmp);
  			FreeAndNil(tmp);
  			end;
        end
    else
    	begin
    	iegEnableCMS := true;

    	io := TImageEnIO.Create(nil);
    	bmp := TBitmap.Create();

        io.Params.JPEG_DCTMethod := ioJPEG_IFAST;

    	io.LoadFromFile(String(document_path));

    	if not io.Aborting then
    		begin
        	io.IEBitmap.PixelFormat := ie24RGB;
        	bmp.Assign(io.IEBitmap.VclBitmap);
        	bmp.PixelFormat := pf24bit;
        	Result.result_value := bmp.ReleaseHandle();
        	end;

   		FreeAndNil(io);
    	FreeAndNil(bmp);
    	end;
end;

function FxImgSave(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	temp_res: TFxImgResult;
	bmp: TBitmap;
    mex: string;
    io: TImageEnIO;
    proc: TImageEnProc;
begin
    Result.result_type := RT_BOOL;
    Result.result_value := FX_FALSE;

    if (@app_query <> nil) then
        begin
    	temp_res := app_query(CQ_GETLANGLIBS, 0, 0);

        if (temp_res.result_type = RT_HANDLE) then
        	begin
            locale_lib := temp_res.result_value;
            backup_lib := temp_res.result_xtra;
            end;
        end;

    iegEnableCMS := true;

	bmp := TBitmap.Create();
    bmp.Handle := img;
    bmp.PixelFormat := pf24bit;

    mex := ExtractExt(String(document_path));

    if ((mex = 'jp2') or (mex = 'j2k')) then
    	begin
        frmJPsave := TfrmJPsave.Create(nil);
		frmJPsave.ShowModal();

        if jp2_confirm then
        	begin
            io := TImageEnIO.Create(nil);
            io.IEBitmap.Assign(bmp);

            if frmJPsave.cbxLossless.Checked then
            	io.Params.J2000_Rate := 1.0
            else
            	io.Params.J2000_Rate := (frmJPsave.tbrQuality.Position / 100);

            if (io.Params.J2000_Rate < 0.001) then
            	io.Params.J2000_Rate := 0.001;

            if (mex = 'j2k') then
            	io.SaveToFileJ2K(String(document_path))
            else
            	io.SaveToFileJP2(String(document_path));

            if not io.Aborting then
            	Result.result_value := FX_TRUE;

            FreeAndNil(io);
            end;

        FreeAndNil(frmJPsave);
        end
        
    else if (mex = 'bmp') then
    	begin
        bmp.SaveToFile(String(document_path));
        Result.result_value := FX_TRUE;
        end

    else if (mex = 'jpg') then
    	begin
  		frmJPEGsave := TfrmJPEGsave.Create(nil);
  		frmJPEGsave.ShowModal();

        if jpeg_confirm then
    		begin
            io := TImageEnIO.Create(nil);
            io.IEBitmap.Assign(bmp);

    		if (frmJPEGsave.tbrQuality.Position > 0) then
            	io.Params.JPEG_Quality := frmJPEGsave.tbrQuality.Position
            else
                io.Params.JPEG_Quality := 1;
            io.Params.JPEG_Progressive := frmJPEGsave.cbxProgressive.Checked;
            io.Params.JPEG_OptimalHuffman := frmJPEGsave.cbxOptimized.Checked;

            io.SaveToFileJpeg(String(document_path));

            if not io.Aborting then
            	Result.result_value := FX_TRUE;

            FreeAndNil(io);
            end;

        FreeAndNil(frmJPEGsave);
        end

    else if (mex = 'pcx') then
    	begin
        io := TImageEnIO.Create(nil);
        io.IEBitmap.Assign(bmp);

        io.Params.PCX_Compression := ioPCX_RLE;
        io.SaveToFilePCX(String(document_path));

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'png') then
    	begin
        io := TImageEnIO.Create(nil);
        io.IEBitmap.Assign(bmp);

        io.Params.PNG_Filter := ioPNG_FILTER_SUB;
        io.Params.PNG_Compression := 9;
        io.SaveToFilePNG(String(document_path));

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if ((mex = 'pbm') or (mex = 'pgm') or (mex = 'ppm')) then
    	begin
        io := TImageEnIO.Create(nil);
        io.IEBitmap.Assign(bmp);

        io.IEBitmap.DefaultDitherMethod := ieOrdered;

        if (mex = 'pbm') then
        	begin
            io.IEBitmap.PixelFormat := ie1g;
            io.Params.BitsPerSample := 1;
            io.Params.SamplesPerPixel := 1;
            end
        else if (mex = 'pgm') then
        	begin
            io.IEBitmap.PixelFormat := ie8g;
            io.Params.BitsPerSample := 8;
            io.Params.SamplesPerPixel := 1;
            end
        else
        	begin
            io.Params.BitsPerSample := 8;
            io.Params.SamplesPerPixel := 3;
            end;

        io.SaveToFilePXM(String(document_path));

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'tga') then
    	begin
        io := TImageEnIO.Create(nil);
        io.IEBitmap.Assign(bmp);

        io.Params.TGA_Compressed := true;
        io.SaveToFileTGA(String(document_path));

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'gif') then
    	begin
        io := TImageEnIO.Create(nil);
        io.IEBitmap.Assign(bmp);

        io.SaveToFileGIF(String(document_path));

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'pdf') then
    	begin
        io := TImageEnIO.Create(nil);

        io.CreatePDFFile(String(document_path));

		io.IEBitmap.Assign(bmp);
        io.Params.PDF_Producer := sAppName;
		io.Params.PDF_Compression:= ioPDF_JPEG;
		io.SaveToPDF();

		io.ClosePDFFile();

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'ps') then
    	begin
        io := TImageEnIO.Create(nil);

        io.CreatePSFile(String(document_path));

		io.IEBitmap.Assign(bmp);
        io.Params.PS_Compression := ioPS_JPEG;
		io.SaveToPS();

		io.ClosePSFile();

        if not io.Aborting then
        	Result.result_value := FX_TRUE;

        FreeAndNil(io);
        end

    else if (mex = 'txt') then
    	begin
        io := TImageEnIO.Create(nil);

		io.IEBitmap.Assign(bmp);

        proc := TImageEnProc.Create(nil);
        proc.AttachedIEBitmap := io.IEBitmap;

        if (io.IEBitmap.Width > 80) then
        	proc.Resample(80, -1);

        io.SaveToText(String(document_path), ioUnknown, ietfASCIIArt);

       	Result.result_value := FX_FALSE;

        FreeAndNil(proc);
        FreeAndNil(io);
        end

    else if (mex = 'tif') then
    	begin
        frmTIFFsave := TfrmTIFFsave.Create(nil);
        frmTIFFsave.ShowModal();

        if tiff_confirm then
    		begin
            io := TImageEnIO.Create(nil);
            io.IEBitmap.Assign(bmp);

            io.IEBitmap.DefaultDitherMethod := ieOrdered;

            if frmTIFFsave.rbnCNone.Checked then
            	io.Params.TIFF_Compression := ioTIFF_UNCOMPRESSED
            else if frmTIFFsave.rbnCLZW.Checked then
                io.Params.TIFF_Compression := IoTIFF_LZW
            else if frmTIFFsave.rbnCJPEG.Checked then
                begin
                io.Params.TIFF_Compression := ioTIFF_JPEG;

      			if (frmTIFFsave.tbrQuality.Position > 0) then
        			io.Params.TIFF_JPEGQuality := frmTIFFsave.tbrQuality.Position
      			else
        			io.Params.TIFF_JPEGQuality := 1;
                end
            else if frmTIFFsave.rbnCPackBits.Checked then
                io.Params.TIFF_Compression := ioTIFF_PACKBITS
            else if frmTIFFsave.rbnCG31.Checked then
                begin
                io.IEBitmap.PixelFormat := ie1g;
                io.Params.TIFF_Compression := ioTIFF_G3FAX1D;
                end
            else if frmTIFFsave.rbnCG32.Checked then
                begin
                io.IEBitmap.PixelFormat := ie1g;
                io.Params.TIFF_Compression := ioTIFF_G3FAX2D;
                end
            else if frmTIFFsave.rbnCG4.Checked then
            	begin
                io.IEBitmap.PixelFormat := ie1g;
                io.Params.TIFF_Compression := ioTIFF_G4FAX;
                end
            else if frmTIFFsave.rbnCZlib.Checked then
                io.Params.TIFF_Compression := ioTIFF_CCITT1D
            else
                io.Params.TIFF_Compression := IoTIFF_LZW;

            io.SaveToFileTIFF(String(document_path));

            if not io.Aborting then
            	Result.result_value := FX_TRUE;

            FreeAndNil(io);
        	end;

        FreeAndNil(frmTIFFsave);
        end;

	FreeAndNil(bmp);
end;

function FxImgMultiStart(document_path, info: PChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
begin
    Result.result_type := RT_INT;
    Result.result_value := 0;

    gpage := 0;
    iegEnableCMS := true;
    gext := ExtractExt(String(document_path));
    gfilep := String(document_path);

	// initializing
    pio := TImageEnIO.Create(nil);

    if (gext = 'dcx') then
        begin
        gpages := EnumDCXIm(String(document_path));
    	pio.LoadFromFileDCX(String(document_path));
        end
    else
    	gpages := pio.LoadFromFileTIFF(String(document_path));

    if pio.Aborting then
        Result.result_value := 0
    else
        begin
		if (gext = 'dcx') then
			Result.result_value := EnumDCXIm(String(gfilep))
		else
  			Result.result_value := EnumTIFFIm(String(gfilep));
        end;
end;

function FxImgMultiGetPage(page_index: integer; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	bmp: TBitmap;
begin
    Result.result_type := RT_HBITMAP;
    Result.result_value := 0;

    bmp := TBitmap.Create();

	if (gext = 'dcx') then
        begin
        pio.Params.DCX_ImageIndex := page_index;
        pio.LoadFromFileDCX(gfilep);
        end
	else
        begin
        pio.Params.TIFF_ImageIndex := page_index;
        pio.LoadFromFileTIFF(gfilep);
        end;

    if pio.Aborting then
        Result.result_value := 0
    else
    	begin
        bmp.Assign(pio.IEBitmap.VclBitmap);
        bmp.PixelFormat := pf24bit;
    	Result.result_value := bmp.ReleaseHandle();
        end;

    FreeAndNil(bmp);
end;

function FxImgMultiStop(app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
begin
    Result.result_type := RT_BOOL;
    Result.result_value := FX_TRUE;

    FreeAndNil(pio);
end;

function FxImgImport(info: PChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	temp_res: TFxImgResult;
	bmp: TBitmap;
    io: TImageEnIO;
    api: TIEAcquireApi;
begin
    Result.result_type := RT_HBITMAP;
    Result.result_value := 0;

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

    if ((String(info) = LoadLStr(3080)) or (String(info) = PR_SCAN)) then
    	begin
        api := ieaTWain;
            
        case FxRegRInt('Scan_Subsystem', 0) of
        	0, 1:
            	if IsXP() then
                	api := ieaWIA;
            end;

        // working
		io := TImageEnIO.Create(nil);
    	bmp := TBitmap.Create();

        if ((api = ieaWIA) and (io.WIAParams.DevicesInfoCount = 0)) then
        	MessageBox(wnd, PChar(LoadLStr(3707)), PChar(sAppName), MB_OK or MB_ICONERROR);

        if (io.SelectAcquireSource(api) and io.Acquire(api)) then
			begin
            bmp.Assign(io.IEBitmap.VclBitmap);
            Result.result_value := bmp.ReleaseHandle();
            end;

		FreeAndNil(io);
    	FreeAndNil(bmp);
    	end;
end;

function FxImgTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
var
	temp_res: TFxImgResult;
	tmp, new: string;
	html: TStringList;
	bmp: TBitmap;
	wdth, hght: integer; // image dimensions
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

	tmp := String(document_path);

    if (String(info) = LoadLStr(3081)) then
    	begin
        // HTML generator
		if (tmp <> '') then
  			begin
  			if (MessageBox(wnd, PChar(LoadLStr(3082)), sAppName, MB_YESNO + MB_ICONQUESTION) = ID_YES) then
    			begin
    			// creating html
    			bmp := TBitmap.Create();
    			bmp.Handle := img;
    			wdth := bmp.Width;
    			hght := bmp.Height;
    			FreeAndNil(bmp);

    			new := ChangeFileExt(tmp, '.html');

    			html := TStringList.Create();
    			html.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
    			html.Add('<html>');
    			html.Add('<head>');
    			html.Add('<title>' + ExtractFileName(tmp) + '</title>');
    			html.Add('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
    			html.Add('</head>');
    			html.Add('');
    			html.Add('<body bgcolor="#FFFFFF" text="#000000">');
    			html.Add('<img src="' + ExtractFileName(tmp) + '" alt="" width="' + IntToStr(wdth) + '" height="' + IntToStr(hght) + '">');
    			html.Add('</body>');
    			html.Add('</html>');

    			try
      				html.SaveToFile(new);
            	except
      				MessageBox(wnd, PChar(LoadLStr(3083)), sAppName, MB_OK + MB_ICONERROR);
      				FreeAndNil(html);
      				Exit;
      			end;

    			FreeAndNil(html);
    			MessageBox(wnd, PChar(Format(LoadLStr(3084), [new])), sAppName, MB_OK + MB_ICONINFORMATION);
        		end;
    		end
		else
  			begin
  			// unsaved files
  			MessageBox(wnd, PChar(LoadLStr(3085)), sAppName, MB_OK + MB_ICONWARNING);
  			end;
    	end;
end;

function FxImgCfg(info: PChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
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

    frmScanOpt := TfrmScanOpt.Create(Application);
	frmScanOpt.ShowModal();
 	FreeAndNil(frmScanOpt);
end;

exports
	FxImgQuery, FxImgOpen, FxImgSave, FxImgImport,
    FxImgMultiStart, FxImgMultiGetPage, FxImgMultiStop, FxImgTool, FxImgCfg;

begin
end.
