unit fx_internalp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms,
  ImageEnIO, ImageEnProc, hyieutils, hyiedefs, iewic,
  c_const, c_utils, c_locales, c_graphics, c_reg, c_ie;

var
  image: TBitmap;

function InternalCore2(p_intf: ULONG; app_query: TAppCallBack): TFxCore2Result; cdecl;
function InternalPluginQuery(plugin_path: PWideChar; info_call: TPlugInCallBack; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
function InternalPluginOpen(document_path, info: PWideChar; page: ULONG; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
function InternalPluginSave(document_path, info: PWideChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
function InternalPluginImport(info: PWideChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;
function InternalPluginTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult; cdecl;


implementation

uses w_save_JPEG, w_save_JPEG2K, w_save_TIFF, w_save_XR, w_lsJPEG_cut,
  w_lsJPEG_rotate, w_setwall, w_viewwall;

function InternalCore2(p_intf: ULONG; app_query: TAppCallBack): TFxCore2Result;
begin
  Result.res := FX_FALSE;
  Result.data := nil;

  case p_intf of
    CP_FQUERY:
      begin
      Result.res := FX_TRUE;
      Result.data := @InternalPluginQuery;
      end;

    CP_FOPEN:
      begin
      Result.res := FX_TRUE;
      Result.data := @InternalPluginOpen;
      end;

    CP_FSAVE:
      begin
      Result.res := FX_TRUE;
      Result.data := @InternalPluginSave;
      end;

    CP_FIMPORT:
      begin
      Result.res := FX_TRUE;
      Result.data := @InternalPluginImport;
      end;

    CP_FTOOL:
      begin
      Result.res := FX_TRUE;
      Result.data := @InternalPluginTool;
      end;
  end;
end;

function InternalPluginQuery(plugin_path: PWideChar; info_call: TPlugInCallBack; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
  wic: TIEWICReader;
begin
  Result.result_type := RT_BOOL;
  Result.result_value := FX_TRUE;

  info_call(PT_FOPEN, 'jpg', '');
  info_call(PT_FOPEN, 'jpeg', '');
  info_call(PT_FOPEN, 'jfif', '');
  info_call(PT_FOPEN, 'jpe', '');
  info_call(PT_FOPEN, 'jp2', '');
  info_call(PT_FOPEN, 'jpc', '');
  info_call(PT_FOPEN, 'j2k', '');
  info_call(PT_FOPEN, 'j2c', '');
  info_call(PT_FOPEN, 'gif', '');
  info_call(PT_FOPEN, 'pbm', '');
  info_call(PT_FOPEN, 'pgm', '');
  info_call(PT_FOPEN, 'ppm', '');
  info_call(PT_FOPEN, 'bmp', '');
  info_call(PT_FOPEN, 'dib', '');
  info_call(PT_FOPEN, 'emf', '');
  info_call(PT_FOPEN, 'wmf', '');
  info_call(PT_FOPEN, 'pcx', '');
  info_call(PT_FOPEN, 'dcx', '');
  info_call(PT_FOPEN, 'png', '');
  info_call(PT_FOPEN, 'tga', '');
  info_call(PT_FOPEN, 'tif', '');
  info_call(PT_FOPEN, 'tiff', '');
  info_call(PT_FOPEN, 'wbmp', '');
  info_call(PT_FOPEN, 'wbm', '');
  info_call(PT_FOPEN, 'psd', '');
  info_call(PT_FOPEN, 'cur', '');

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
  info_call(PT_FSAVE, 'psd', '');

  info_call(PT_FNOTREC, 'dcx', '');
  info_call(PT_FNOTREC, 'jpe', '');
  info_call(PT_FNOTREC, 'jfif', '');

  info_call(PT_FDESCR, 'jpg', PWideChar(LoadLStr(1000)));
  info_call(PT_FDESCR, 'jpeg', PWideChar(LoadLStr(1000)));
  info_call(PT_FDESCR, 'jfif', PWideChar(LoadLStr(1000)));
  info_call(PT_FDESCR, 'jpe', PWideChar(LoadLStr(1000)));
  info_call(PT_FDESCR, 'jp2', PWideChar(LoadLStr(1001)));
  info_call(PT_FDESCR, 'jpc', PWideChar(LoadLStr(1001)));
  info_call(PT_FDESCR, 'j2k', PWideChar(LoadLStr(1001)));
  info_call(PT_FDESCR, 'j2c', PWideChar(LoadLStr(1001)));
  info_call(PT_FDESCR, 'gif', PWideChar(LoadLStr(1002)));
  info_call(PT_FDESCR, 'pbm', PWideChar(LoadLStr(1003)));
  info_call(PT_FDESCR, 'pgm', PWideChar(LoadLStr(1004)));
  info_call(PT_FDESCR, 'ppm', PWideChar(LoadLStr(1005)));
  info_call(PT_FDESCR, 'bmp', PWideChar(LoadLStr(1006)));
  info_call(PT_FDESCR, 'dib', PWideChar(LoadLStr(1006)));
  info_call(PT_FDESCR, 'emf', PWideChar(LoadLStr(1007)));
  info_call(PT_FDESCR, 'wmf', PWideChar(LoadLStr(1008)));
  info_call(PT_FDESCR, 'pcx', PWideChar(LoadLStr(1009)));
  info_call(PT_FDESCR, 'dcx', PWideChar(LoadLStr(1010)));
  info_call(PT_FDESCR, 'png', PWideChar(LoadLStr(1011)));
  info_call(PT_FDESCR, 'tga', PWideChar(LoadLStr(1012)));
  info_call(PT_FDESCR, 'tif', PWideChar(LoadLStr(1013)));
  info_call(PT_FDESCR, 'tiff', PWideChar(LoadLStr(1013)));
  info_call(PT_FDESCR, 'wbmp', PWideChar(LoadLStr(1014)));
  info_call(PT_FDESCR, 'wbm', PWideChar(LoadLStr(1014)));
  info_call(PT_FDESCR, 'psd', PWideChar(LoadLStr(1020)));
  info_call(PT_FDESCR, 'pdf', PWideChar(LoadLStr(1031)));
  info_call(PT_FDESCR, 'ps', PWideChar(LoadLStr(1032)));
  info_call(PT_FDESCR, 'cur', PWideChar(LoadLStr(1033)));
  info_call(PT_FDESCR, 'txt', PWideChar(LoadLStr(1034)));

  info_call(PT_FIMPORT, PWideChar(LoadLStr(3080)), '');

  info_call(PT_FTOOL, PWideChar(LoadLStr(3401)), '');
  info_call(PT_FTOOL, PWideChar(LoadLStr(3000)), '');
  info_call(PT_FTOOL, PWideChar(LoadLStr(3001)), '');

  info_call(PT_FROLE, PR_SCAN, '');
  info_call(PT_FROLE, PR_JPEGLL, '');

  // Windows Imaging Component
  wic := TIEWICReader.Create();

  if wic.IsAvailable then
    begin
    info_call(PT_FOPEN, 'hdp', '');
    info_call(PT_FOPEN, 'wdp', '');
    info_call(PT_FOPEN, 'jxr', '');

    info_call(PT_FSAVE, 'hdp', '');
    info_call(PT_FSAVE, 'jxr', '');

    info_call(PT_FNOTREC, 'wdp', '');

    info_call(PT_FDESCR, 'hdp', PWideChar(LoadLStr(1065)));
    info_call(PT_FDESCR, 'wdp', PWideChar(LoadLStr(1065)));
    info_call(PT_FDESCR, 'jxr', PWideChar(LoadLStr(1065)));

    wic.Free();
    end;
end;

function InternalPluginOpen(document_path, info: PWideChar; page: ULONG; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
  bmp, tmp: TBitmap;
  io: TImageEnIO;
  imh: THandle;
  pic: TPicture;
  iif: TIconInfo;
  ext: string;
begin
  Result.result_type := RT_HBITMAP;
  Result.result_value := 0;
  Result.result_xtra := 1;

  ext := LowerCase(ExtractExt(string(document_path)));

  if (ext = 'cur') then
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
      bmp.ApplyLimits();

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
    io.Params.IsNativePixelFormat := true;

    if (ext = 'dcx') then
      begin
      io.Params.DCX_ImageIndex := page;
      Result.result_xtra := EnumDCXIm(String(document_path));


      if (Result.result_xtra > 0) then
        io.LoadFromFileDCX(String(document_path));
      end
    else if ((ext = 'tif') or (ext = 'tiff')) then
      begin
      io.Params.TIFF_ImageIndex := page;

      Result.result_xtra := io.LoadFromFileTIFF(String(document_path));
      end
    else
      io.LoadFromFile(String(document_path));

    if not io.Aborting then
      begin
      io.IEBitmap.PrepareAlphaForExternalUse();
      if (io.IEBitmap.PixelFormat <> ie32RGB) then
        io.IEBitmap.PixelFormat := ie24RGB;

      io.IEBitmap.CopyToTBitmap(bmp);
      bmp.ApplyLimits();
      Result.result_value := bmp.ReleaseHandle();
      end;

    FreeAndNil(io);
    FreeAndNil(bmp);
    end;
end;

function InternalPluginSave(document_path, info: PWideChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
  bmp: TBitmap;
  mex: string;
  io: TImageEnIO;
  proc: TImageEnProc;
begin
  Result.result_type := RT_BOOL;
  Result.result_value := FX_FALSE;

  iegEnableCMS := true;

  bmp := TBitmap.Create();
  bmp.Handle := img;
  bmp.ApplyLimits();

  mex := ExtractExt(String(document_path));

  if ((mex = 'jp2') or (mex = 'j2k')) then
    begin
    frmJPsave := TfrmJPsave.Create(nil);
    frmJPsave.ShowModal();

    if frmJPsave.jp2_confirm then
      begin
      io := TImageEnIO.Create(nil);
      io.IEBitmap.Assign(bmp);
      io.IEBitmap.PrepareAlphaAfterAssignment();

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
    io := TImageEnIO.Create(nil);
    io.IEBitmap.Assign(bmp);
    io.IEBitmap.PrepareAlphaAfterAssignment();

    io.Params.BMP_HandleTransparency := true;

    io.SaveToFileBMP(String(document_path));

    if not io.Aborting then
      Result.result_value := FX_TRUE;

    FreeAndNil(io);
    end

  else if (mex = 'jpg') then
    begin
    frmJPEGsave := TfrmJPEGsave.Create(nil);
    frmJPEGsave.ShowModal();

    if frmJPEGsave.jpeg_confirm then
      begin
      io := TImageEnIO.Create(nil);
      io.IEBitmap.Assign(bmp);
      io.IEBitmap.PrepareAlphaAfterAssignment();

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

  else if ((mex = 'hdp') or (mex = 'jxr')) then
    begin
    frmXRsave := TfrmXRsave.Create(nil);
    frmXRsave.ShowModal();

    if frmXRsave.xr_confirm then
      begin
      io := TImageEnIO.Create(nil);
      io.IEBitmap.Assign(bmp);
      io.IEBitmap.PrepareAlphaAfterAssignment();

      io.Params.HDP_ImageQuality := frmXRsave.tbrQuality.Position / 100;
      io.Params.HDP_Lossless := frmXRsave.cbxLossless.Checked;

      io.SaveToFileHDP(String(document_path));

      if not io.Aborting then
        Result.result_value := FX_TRUE;

      FreeAndNil(io);
      end;

    FreeAndNil(frmXRsave);
    end

  else if (mex = 'pcx') then
    begin
    io := TImageEnIO.Create(nil);
    io.IEBitmap.Assign(bmp);
    io.IEBitmap.PrepareAlphaAfterAssignment();

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
    io.IEBitmap.PrepareAlphaAfterAssignment();

    io.Params.PNG_Filter := ioPNG_FILTER_SUB;
    io.Params.PNG_Compression := 9;
    io.SaveToFilePNG(String(document_path));

    if not io.Aborting then
      Result.result_value := FX_TRUE;

    FreeAndNil(io);
    end

  else if (mex = 'psd') then
    begin
    io := TImageEnIO.Create(nil);
    io.IEBitmap.Assign(bmp);
    io.IEBitmap.PrepareAlphaAfterAssignment();

    io.SaveToFilePSD(String(document_path));

    if not io.Aborting then
      Result.result_value := FX_TRUE;

    FreeAndNil(io);
    end

  else if ((mex = 'pbm') or (mex = 'pgm') or (mex = 'ppm')) then
    begin
    io := TImageEnIO.Create(nil);
    io.IEBitmap.Assign(bmp);
    io.IEBitmap.PrepareAlphaAfterAssignment();

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
      io.IEBitmap.PixelFormat := ie24RGB;
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
    io.IEBitmap.PrepareAlphaAfterAssignment();

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
    io.IEBitmap.PrepareAlphaAfterAssignment();

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
    io.IEBitmap.PrepareAlphaAfterAssignment();
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
    io.IEBitmap.PrepareAlphaAfterAssignment();
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
    io.IEBitmap.PrepareAlphaAfterAssignment();

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

    if frmTIFFsave.tiff_confirm then
      begin
      io := TImageEnIO.Create(nil);
      io.IEBitmap.Assign(bmp);
      io.IEBitmap.PrepareAlphaAfterAssignment();

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
      else if frmTIFFsave.rbnZIP.Checked then
        io.Params.TIFF_Compression := ioTIFF_ZIP
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

function InternalPluginImport(info: PWideChar; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
  bmp: TBitmap;
  io: TImageEnIO;
  api: TIEAcquireApi;
begin
  Result.result_type := RT_HBITMAP;
  Result.result_value := 0;

  if ((string(info) = LoadLStr(3080)) or (string(info) = PR_SCAN)) then
    begin
    api := ieaWIA;

    if (FxRegRInt('Imaging_Subsystem', 0) = 1) then
      api := ieaTWain;

    // working
    io := TImageEnIO.Create(nil);
    bmp := TBitmap.Create();

    if ((api = ieaWIA) and (io.WIAParams.DevicesInfoCount = 0)) then
      MessageBox(wnd, PWideChar(LoadLStr(3707)), sAppName, MB_OK or MB_ICONERROR);

    if (io.SelectAcquireSource(api) and io.Acquire(api)) then
      begin
      io.IEBitmap.PrepareAlphaForExternalUse();
      io.IEBitmap.CopyToTBitmap(bmp);
      bmp.ApplyLimits();
      Result.result_value := bmp.ReleaseHandle();
      end;

    FreeAndNil(io);
    FreeAndNil(bmp);
    end;
end;

function InternalPluginTool(document_path, info: PChar; img: HBITMAP; app, wnd: HWND; app_query: TAppCallBack): TFxImgResult;
var
  io: TImageEnIO;
  markers: TIEJpegCopyMarkers;
begin
  Result.result_type := RT_BOOL;
  Result.result_value := FX_TRUE;

  if ((string(info) = LoadLStr(3401)) or (string(info) = PR_JPEGLL)) then
    begin
    // lossless JPEG transformations
    io := TImageEnIO.Create(nil);
    io.ParamsFromFile(PWideChar(document_path));

    if ((not io.Aborting) and (io.Params.FileType = ioJPEG)) then
      begin
      if (((io.Params.Width mod 8) <> 0) or ((io.Params.Height mod 8) <> 0)) then
        MessageBox(wnd, PWideChar(LoadLStr(3413)), sAppName, MB_OK or MB_ICONWARNING);

      frmJPEG := TfrmJPEG.Create(Application);

      frmJPEG.img_width := io.Params.Width;
      frmJPEG.img_height := io.Params.Height;
      frmJPEG.cut_rect := Rect(0, 0, 0, 0);

      frmJPEG.ShowModal();

      if (frmJPEG.apply_transf) then
        begin
        if (frmJPEG.transf = jtNone) then
          markers := jcCopyNone
        else
          markers := jcCopyAll;

        if (frmJPEG.cbxBackup.Checked) then
          CopyFile(document_path, PWideChar(ChangeFileExt(string(document_path), '.jpg.bak')), false);

        JpegLosslessTransform2(document_path, frmJPEG.transf, false, markers, frmJPEG.cut_rect, frmJPEG.cbxEXIF.Checked);

        Result.result_type := RT_INT;
        Result.result_value := 1;
        StrLCopy(Result.result_string_data, document_path, 2048);
        end;

      FreeAndNil(frmJPEG);
      end
    else
      MessageBox(wnd, PWideChar(LoadLStr(3402)), sAppName, MB_OK or MB_ICONWARNING);

    FreeAndNil(io);
    end

  else if (string(info) = LoadLStr(3001)) then
    begin
    // set as wallpaper
    image := TBitmap.Create();
    image.Handle := img;

    frmWallpaperS := TfrmWallpaperS.Create(Application);
    frmWallpaperS.ShowModal();
    FreeAndNil(frmWallpaperS);

    FreeAndNil(image);
    end

  else if (string(info) = LoadLStr(3000)) then
    begin
    // view as wallpaper
    image := TBitmap.Create();
    image.Handle := img;

    frmWallpaper := TfrmWallpaper.Create(Application);

    frmWallpaper.imgWallpaper.Blank();
    frmWallpaper.imgWallpaper.MouseWheelParams.Action := iemwNone;
    frmWallpaper.imgWallpaper.WallPaper.Assign(image);
    frmWallpaper.ShowModal();

    FreeAndNil(frmWallpaper);

    FreeAndNil(image);
    end;
end;

end.
