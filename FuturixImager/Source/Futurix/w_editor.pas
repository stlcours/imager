unit w_editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ieview, imageenview, ComCtrls, ToolWin, StdCtrls,
  imageenproc, AppEvnts, Clipbrd, Menus, hyieutils, hyiedefs, hsvbox,
  c_const, c_wndpos, c_utils, c_reg, c_tb, c_graphics, c_ie;

const
  FM_RECTSELECT         = 0;
  FM_HAND               = 1;
  FM_DRAW               = 2;
  FM_PREVIEW            = 3;
  FM_PENCIL             = 4;
  FM_FLOODFILL          = 5;

type
  TfrmEditor = class(TForm)
    cbrEditor: TCoolBar;
    tbrEditor: TToolBar;
    sbxBottom: TScrollBox;
    sbxSide: TScrollBox;
    img: TImageEnView;
    btnApply: TButton;
    btnCancel: TButton;
    tbnCut: TToolButton;
    tbnCopy: TToolButton;
    tbnZoom: TToolButton;
    Sep2: TToolButton;
    Sep3: TToolButton;
    tbnPaste: TToolButton;
    tbnRedo: TToolButton;
    tbnUndo: TToolButton;
    proc: TImageEnProc;
    sbxColor: TScrollBox;
    lblColor: TLabel;
    pnlColor: TPanel;
    lvwFilters: TListView;
    appEvents: TApplicationEvents;
    Sep5: TToolButton;
    Sep6: TToolButton;
    tbnResize: TToolButton;
    tbnRotate: TToolButton;
    imgPreview: TImageEnView;
    tbnSelection: TToolButton;
    popSelection: TPopupMenu;
    popZoom: TPopupMenu;
    piSelectAll: TMenuItem;
    piRemoveSelection: TMenuItem;
    piInvertSelection: TMenuItem;
    N1: TMenuItem;
    tbnCrop: TToolButton;
    tbnSetFit: TToolButton;
    tbnEraseSelection: TToolButton;
    tbnPasteSel: TToolButton;
    piZm6: TMenuItem;
    piZm12: TMenuItem;
    piZm25: TMenuItem;
    piZm50: TMenuItem;
    piZm75: TMenuItem;
    piZm100: TMenuItem;
    piZm150: TMenuItem;
    piZm200: TMenuItem;
    piZm400: TMenuItem;
    tbnModSel: TToolButton;
    tbnModDraw: TToolButton;
    tbnModHand: TToolButton;
    Sep1: TToolButton;
    pnlColorSelector: TPanel;
    boxColorSelector: THSVBox;
    pnlSep1: TPanel;
    pnlSep2: TPanel;
    tbnModPencil: TToolButton;
    tbnModFlood: TToolButton;
    pnlFlood: TPanel;
    lblTolerance: TLabel;
    pnlTolerance: TPanel;
    edtTolerance: TEdit;
    updTolerance: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tbnCutClick(Sender: TObject);
    procedure tbnCopyClick(Sender: TObject);
    procedure tbnPasteClick(Sender: TObject);
    procedure tbnUndoClick(Sender: TObject);
    procedure tbnRedoClick(Sender: TObject);
    procedure appEventsIdle(Sender: TObject; var Done: Boolean);
    procedure tbnResizeClick(Sender: TObject);
    procedure tbnRotateClick(Sender: TObject);
    procedure lvwFiltersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure piSelectAllClick(Sender: TObject);
    procedure piInvertSelectionClick(Sender: TObject);
    procedure piRemoveSelectionClick(Sender: TObject);
    procedure tbnCropClick(Sender: TObject);
    procedure tbnSetFitClick(Sender: TObject);
    procedure lvwFiltersDblClick(Sender: TObject);
    procedure tbnEraseSelectionClick(Sender: TObject);
    procedure tbnPasteSelClick(Sender: TObject);
    procedure piZm6Click(Sender: TObject);
    procedure piZm12Click(Sender: TObject);
    procedure piZm25Click(Sender: TObject);
    procedure piZm50Click(Sender: TObject);
    procedure piZm75Click(Sender: TObject);
    procedure piZm100Click(Sender: TObject);
    procedure piZm150Click(Sender: TObject);
    procedure piZm200Click(Sender: TObject);
    procedure piZm400Click(Sender: TObject);
    procedure tbnModSelClick(Sender: TObject);
    procedure tbnModHandClick(Sender: TObject);
    procedure tbnModDrawClick(Sender: TObject);
    procedure boxColorSelectorChange(Sender: TObject);
    procedure tbnModPencilClick(Sender: TObject);
    procedure tbnModFloodClick(Sender: TObject);
    procedure imgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    procedure HandleFilter(name: string);
    procedure SetCurrentMode(mode: integer);
  public
    nCurrentMode, nPreviousMode: integer;
  end;

var
  frmEditor: TfrmEditor;

function ProcessPreview(preview: HBITMAP): BOOL; cdecl;


implementation

uses w_main, w_resize, w_rotate, f_ui, w_show, w_sharpen;

{$R *.dfm}

procedure TfrmEditor.FormCreate(Sender: TObject);
var
  filters: TStringList;
  i: integer;
  wreg: TFRegistry;
begin
  wreg := TFRegistry.Create(RA_READONLY);
  wreg.RootKey := HKEY_CURRENT_USER;

  img.Blank();
  img.EnableShiftKey := false;
  tbnSelection.WholeDropDown := true;
  tbnZoom.WholeDropDown := true;

  nPreviousMode := FM_RECTSELECT;
  SetCurrentMode(FM_RECTSELECT);

  // XP or not XP - that is the question
  if IsThemed() then
    begin
    sbxSide.BevelEdges := [beTop, beLeft, beRight];
    imgPreview.BorderStyle := bsNone;
    img.BorderStyle := bsNone;
    sbxColor.BevelEdges := [];
    end;

  // reading settings
  if wreg.OpenKey(sSettings, false) then
    begin
    if wreg.RBool('Editor_ZoomToFit', true) then
      tbnSetFitClick(Self);

    updTolerance.Position := wreg.RInt('Editor_Tolerance', 10);
    sbxColor.Color := StringToColor(wreg.RStr('Editor_Color', 'clWhite'));

    wreg.CloseKey();
    end
  else
    begin
    tbnSetFitClick(Self);

    updTolerance.Position := 10;
    sbxColor.Color := clWhite;
    end;

  boxColorSelector.SetColor(sbxColor.Color);

  // getting window size
  RestoreWindowSize(@Self, sSettings + '\Wnd', 775, 575, 'Editor_');

  // getting main image
  img.Background := frmMain.sbxMain.Color;
  img.IEBitmap.Assign(frmMain.img.IEBitmap);
  img.Update();

  // getting filter names and creating entries for them
  filters := TStringList.Create();
  filters.Duplicates := dupIgnore;
  filters.Sorted := true;

  filters.AddStrings(fx.Plugins.ListFilter());

  filters.Add('Invert');
  filters.Add('Greyscale');
  filters.Add('Red Eye Removal');
  filters.Add('Resize');
  filters.Add('Rotate');
  filters.Add('Sharpen');
  filters.Add('Auto Fix');
  filters.Add('Auto Crop');
  filters.Add('Auto Gain');
  filters.Add('Auto Sharp');
  filters.Add('Auto Equalize');
  filters.Add('Auto White');
  filters.Add('Auto Glow');

  for i := 0 to (filters.Count - 1) do
    begin
    lvwFilters.AddItem(filters[i], nil);
    lvwFilters.Items[i].ImageIndex := 5;
    end;

  FreeAndNil(filters);
  FreeAndNil(wreg);

  lvwFilters.Refresh();
end;

procedure TfrmEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmEditor.FormDestroy(Sender: TObject);
begin
  frmEditor := nil;
end;

procedure TfrmEditor.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
     Self.Close();
end;

procedure TfrmEditor.btnApplyClick(Sender: TObject);
begin
  // saving window position
  SaveWindowSize(@Self, sSettings + '\Wnd', 'Editor_');

  // saving settings
  FxRegWBool('Editor_ZoomToFit', img.AutoShrink);
  FxRegWStr('Editor_Color', ColorToString(boxColorSelector.Color));
  FxRegWInt('Editor_Tolerance', updTolerance.Position);

  // working
  frmMain.img.Proc.SaveUndo();
  frmMain.img.Proc.ClearAllRedo();
  frmMain.img.IEBitmap.Assign(img.IEBitmap);
  frmMain.img.Update();

  Self.Close();
end;

procedure TfrmEditor.btnCancelClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TfrmEditor.tbnCutClick(Sender: TObject);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create();

  if img.Selected then
    img.CopySelectionToBitmap(bmp)
  else
    img.IEBitmap.CopyToTBitmap(bmp);

  Clipboard.Assign(bmp);
  FreeAndNil(bmp);

  proc.Fill(TColor2TRGB(sbxColor.Color));
  proc.ClearAllRedo();
end;

procedure TfrmEditor.tbnCopyClick(Sender: TObject);
begin
  if img.Selected then
    proc.SelCopyToClip()
  else
    proc.CopyToClipboard();
  proc.ClearAllRedo();
end;

procedure TfrmEditor.tbnPasteClick(Sender: TObject);
begin
  proc.AutoUndo := false;
  proc.SaveUndo();

  if img.Selected then
    proc.PointPasteFromClip(img.SelX1, img.SelY1)
  else
    proc.PasteFromClipboard();

  if (img.IEBitmap.PixelFormat <> ie32RGB) then
    proc.ConvertTo24Bit();
    
  proc.ClearAllRedo();
  proc.AutoUndo := true;
end;

procedure TfrmEditor.tbnPasteSelClick(Sender: TObject);
begin
  if img.Selected then
    begin
    proc.AutoUndo := false;
    proc.SaveUndo();

    proc.SelPasteFromClip();
    if (img.IEBitmap.PixelFormat <> ie32RGB) then
      proc.ConvertTo24Bit();

    proc.ClearAllRedo();
    proc.AutoUndo := true;
    end;
end;

procedure TfrmEditor.tbnUndoClick(Sender: TObject);
begin
  proc.SaveRedo();
  proc.Undo();
  proc.ClearUndo();
end;

procedure TfrmEditor.tbnRedoClick(Sender: TObject);
begin
  proc.SaveUndo();
  proc.Redo();
  proc.ClearRedo();
end;

procedure TfrmEditor.tbnSetFitClick(Sender: TObject);
begin
  img.AutoShrink := not img.AutoShrink;

  tbnSetFit.Down := img.AutoShrink;

  if img.AutoShrink then
    img.Update()
  else
    img.Zoom := 100.0;
end;

procedure TfrmEditor.tbnResizeClick(Sender: TObject);
begin
  HandleFilter('Resize');
end;

procedure TfrmEditor.tbnRotateClick(Sender: TObject);
begin
  HandleFilter('Rotate');
end;

procedure TfrmEditor.tbnCropClick(Sender: TObject);
begin
  proc.CropSel();
  proc.ClearAllRedo();

  if not img.AutoShrink then
    img.Fit();
end;

procedure TfrmEditor.tbnEraseSelectionClick(Sender: TObject);
begin
  proc.Fill(TColor2TRGB(sbxColor.Color));
  proc.ClearAllRedo();
end;

procedure TfrmEditor.appEventsIdle(Sender: TObject; var Done: Boolean);
begin
  tbnEraseSelection.Enabled := img.Selected;

  tbnZoom.Enabled := not img.AutoShrink;

  tbnCrop.Enabled := img.Selected;

  piInvertSelection.Enabled := img.Selected;
  piRemoveSelection.Enabled := img.Selected;

  tbnUndo.Enabled := proc.CanUndo;
  tbnRedo.Enabled := proc.CanRedo;

  tbnPaste.Enabled := Clipboard.HasFormat(CF_BITMAP);
  tbnPasteSel.Enabled := (tbnPaste.Enabled and img.Selected);
end;

procedure TfrmEditor.lvwFiltersDblClick(Sender: TObject);
begin
  if Assigned(lvwFilters.Selected) then
    HandleFilter(lvwFilters.Selected.Caption);
end;

procedure TfrmEditor.lvwFiltersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((Key = VK_RETURN) or (Key = VK_SPACE)) then
    Self.lvwFiltersDblClick(Self);
end;

procedure TfrmEditor.piSelectAllClick(Sender: TObject);
begin
  img.Select(0, 0, img.IEBitmap.Width, img.IEBitmap.Height);
end;

procedure TfrmEditor.piInvertSelectionClick(Sender: TObject);
begin
  img.InvertSelection();
end;

procedure TfrmEditor.piRemoveSelectionClick(Sender: TObject);
begin
  img.DeSelect();
end;

procedure TfrmEditor.HandleFilter(name: string);
var
  FxImgFilter: TFxImgFilter;
  func_result: HBITMAP;
  local_image, local_result: TBitmap;
  tmp_res: TFxImgResult;
begin
  // starting the stuff
  func_result := 0;
  nPreviousMode := nCurrentMode;

  // trying external filters
  FxImgFilter := fx.Plugins.ResolveFilter(name);

  if (@FxImgFilter <> nil) then
    begin
    local_image := TBitmap.Create();

    if img.Selected then
      img.CopySelectionToBitmap(local_image)
    else
      img.IEBitmap.CopyToTBitmap(local_image);

    local_image.ApplyLimits();

    tmp_res := FxImgFilter(PWideChar(name), local_image.ReleaseHandle(), @ProcessPreview, Application.Handle, Self.Handle, FxImgGlobalCallback);

    if (tmp_res.result_type = RT_HBITMAP) then
      func_result := tmp_res.result_value
    else
      func_result := 0;

    FreeAndNil(local_image);
    end;

  // well, if there is no externals... (rotate and resize should be last in the list)
  if (func_result = 0) then
    begin
    if (name = 'Invert') then
      begin
      proc.Negative();
      proc.ClearAllRedo();
      end

    else if (name = 'Greyscale') then
      begin
      proc.ConvertToGray();
      proc.ClearAllRedo();
      end

    else if (name = 'Red Eye Removal') then
      begin
      proc.RemoveRedEyes();
      proc.ClearAllRedo();
      end

    else if (name = 'Sharpen') then
      begin
      if not Assigned(frmSharpen) then
        begin
        Application.CreateForm(TfrmSharpen, frmSharpen);
        frmSharpen.ShowModal();
        end;
      end

    else if (name = 'Auto Fix') then
      begin
      proc.WallisFilter();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto Crop') then
      begin
      proc.AutoCrop2();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto Gain') then
      begin
      proc.AdjustGainOffset();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto Sharp') then
      begin
      proc.AutoSharp();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto Equalize') then
      begin
      proc.HistAutoEqualize();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto White') then
      begin
      proc.WhiteBalance_AutoWhite();
      proc.ClearAllRedo();
      end

    else if (name = 'Auto Glow') then
      begin
      proc.WhiteBalance_GrayWorld();
      proc.ClearAllRedo();
      end

    else if (name = 'Resize') then
      begin
      if not Assigned(frmResize) then
        begin
        Application.CreateForm(TfrmResize, frmResize);
        frmResize.ShowModal();
        end;
      end

    else if (name = 'Rotate') then
      begin
      if not Assigned(frmRotate) then
        begin
        Application.CreateForm(TfrmRotate, frmRotate);
        frmRotate.ShowModal();
        end;
      end;
    end;

  // end of fun - finalization of process
  if (func_result <> 0) then
    begin
    local_result := TBitmap.Create();
    local_result.Handle := func_result;
    local_result.ApplyLimits();

    proc.AutoUndo := false;
    proc.SaveUndo();

    if img.Selected then
      begin
      // insert into current selection
      if (HiWord(GetKeyState(VK_SHIFT)) = 0) then
        img.IEBitmap.Canvas.Draw(img.SelX1, img.SelY1, local_result)
      else
        img.IEBitmap.Canvas.StretchDraw(Rect(img.SelX1, img.SelY1, img.SelX2, img.SelY2), local_result);
      end
    else
      img.IEBitmap.Assign(local_result);

    img.Update();

    proc.ClearAllRedo();
    proc.AutoUndo := true;

    FreeAndNil(local_result);
    end;

  if (nPreviousMode = FM_PREVIEW) then
    nPreviousMode := FM_RECTSELECT;
            
  if (nCurrentMode = FM_PREVIEW) then
    SetCurrentMode(nPreviousMode);

  imgPreview.Blank();
end;

procedure TfrmEditor.piZm6Click(Sender: TObject);
begin
  img.Zoom := 6.25;
end;

procedure TfrmEditor.piZm12Click(Sender: TObject);
begin
  img.Zoom := 12.5;
end;

procedure TfrmEditor.piZm25Click(Sender: TObject);
begin
  img.Zoom := 25.0;
end;

procedure TfrmEditor.piZm50Click(Sender: TObject);
begin
  img.Zoom := 50.0;
end;

procedure TfrmEditor.piZm75Click(Sender: TObject);
begin
  img.Zoom := 75.0;
end;

procedure TfrmEditor.piZm100Click(Sender: TObject);
begin
  img.Zoom := 100.0;
end;

procedure TfrmEditor.piZm150Click(Sender: TObject);
begin
  img.Zoom := 150.0;
end;

procedure TfrmEditor.piZm200Click(Sender: TObject);
begin
  img.Zoom := 200.0;
end;

procedure TfrmEditor.piZm400Click(Sender: TObject);
begin
  img.Zoom := 400.0;
end;

procedure TfrmEditor.SetCurrentMode(mode: integer);
begin
  nCurrentMode := mode;

  case mode of
    FM_RECTSELECT:
      begin
      img.Visible := true;
      imgPreview.Visible := false;

      tbnModSel.Down := true;
      tbnModHand.Down := false;
      tbnModDraw.Down := false;
      tbnModPencil.Down := false;
      tbnModFlood.Down := false;
      tbrEditor.Enabled := true;

      Sep1.Visible := true;
      tbnCut.Visible := true;
      tbnCopy.Visible := true;
      tbnPaste.Visible := true;
      tbnPasteSel.Visible := true;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := true;
      tbnSelection.Visible := true;
      tbnEraseSelection.Visible := true;
      Sep6.Visible := true;
      tbnResize.Visible := true;
      tbnCrop.Visible := true;
      tbnRotate.Visible := true;

      pnlFlood.Visible := false;

      img.MouseInteract := [miSelect];
      end;

    FM_HAND:
      begin
      img.Visible := true;
      imgPreview.Visible := false;

      tbnModSel.Down := false;
      tbnModHand.Down := true;
      tbnModDraw.Down := false;
      tbnModPencil.Down := false;
      tbnModFlood.Down := false;
      tbrEditor.Enabled := true;

      Sep1.Visible := true;
      tbnCut.Visible := true;
      tbnCopy.Visible := true;
      tbnPaste.Visible := true;
      tbnPasteSel.Visible := false;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := true;
      tbnSelection.Visible := false;
      tbnEraseSelection.Visible := false;
      Sep6.Visible := false;
      tbnResize.Visible := true;
      tbnCrop.Visible := false;
      tbnRotate.Visible := true;

      pnlFlood.Visible := false;

      img.DeSelect();
      img.MouseInteract := [miScroll];
      end;

    FM_DRAW:
      begin
      img.Visible := true;
      imgPreview.Visible := false;

      tbnModSel.Down := false;
      tbnModHand.Down := false;
      tbnModDraw.Down := true;
      tbnModPencil.Down := false;
      tbnModFlood.Down := false;
      tbrEditor.Enabled := true;

      Sep1.Visible := false;
      tbnCut.Visible := false;
      tbnCopy.Visible := false;
      tbnPaste.Visible := false;
      tbnPasteSel.Visible := false;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := false;
      tbnSelection.Visible := false;
      tbnEraseSelection.Visible := false;
      Sep6.Visible := false;
      tbnResize.Visible := false;
      tbnCrop.Visible := false;
      tbnRotate.Visible := false;

      pnlFlood.Visible := false;

      img.DeSelect();
      img.MouseInteract := [];
      end;

    FM_PREVIEW:
      begin
      imgPreview.Visible := true;
      img.Visible := false;

      tbnModSel.Down := false;
      tbnModHand.Down := false;
      tbnModDraw.Down := false;
      tbnModPencil.Down := false;
      tbnModFlood.Down := false;
      tbrEditor.Enabled := false;

      Sep1.Visible := true;
      tbnCut.Visible := true;
      tbnCopy.Visible := true;
      tbnPaste.Visible := true;
      tbnPasteSel.Visible := true;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := true;
      tbnSelection.Visible := true;
      tbnEraseSelection.Visible := true;
      Sep6.Visible := true;
      tbnResize.Visible := true;
      tbnCrop.Visible := true;
      tbnRotate.Visible := true;

      pnlFlood.Visible := false;

      img.MouseInteract := [miSelect];
      end;

    FM_PENCIL:
      begin
      img.Visible := true;
      imgPreview.Visible := false;

      tbnModSel.Down := false;
      tbnModHand.Down := false;
      tbnModDraw.Down := false;
      tbnModPencil.Down := true;
      tbnModFlood.Down := false;
      tbrEditor.Enabled := true;

      Sep1.Visible := false;
      tbnCut.Visible := false;
      tbnCopy.Visible := false;
      tbnPaste.Visible := false;
      tbnPasteSel.Visible := false;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := false;
      tbnSelection.Visible := false;
      tbnEraseSelection.Visible := false;
      Sep6.Visible := false;
      tbnResize.Visible := false;
      tbnCrop.Visible := false;
      tbnRotate.Visible := false;

      pnlFlood.Visible := false;

      img.DeSelect();
      img.MouseInteract := [];
      end;

    FM_FLOODFILL:
      begin
      img.Visible := true;
      imgPreview.Visible := false;

      tbnModSel.Down := false;
      tbnModHand.Down := false;
      tbnModDraw.Down := false;
      tbnModPencil.Down := false;
      tbnModFlood.Down := true;
      tbrEditor.Enabled := true;

      Sep1.Visible := false;
      tbnCut.Visible := false;
      tbnCopy.Visible := false;
      tbnPaste.Visible := false;
      tbnPasteSel.Visible := false;
      Sep2.Visible := true;
      tbnUndo.Visible := true;
      tbnRedo.Visible := true;
      Sep3.Visible := true;
      tbnSetFit.Visible := true;
      tbnZoom.Visible := true;
      Sep5.Visible := false;
      tbnSelection.Visible := false;
      tbnEraseSelection.Visible := false;
      Sep6.Visible := false;
      tbnResize.Visible := false;
      tbnCrop.Visible := false;
      tbnRotate.Visible := false;

      pnlFlood.Visible := true;

      img.DeSelect();
      img.MouseInteract := [];
      end;
  end;
end;

procedure TfrmEditor.tbnModSelClick(Sender: TObject);
begin
  SetCurrentMode(FM_RECTSELECT);
end;

procedure TfrmEditor.tbnModHandClick(Sender: TObject);
begin
  SetCurrentMode(FM_HAND);
end;

procedure TfrmEditor.tbnModDrawClick(Sender: TObject);
begin
  SetCurrentMode(FM_DRAW);
end;

function ProcessPreview(preview: HBITMAP): BOOL;
var
  local_preview: TBitmap;
begin
  Result := false;

  if Assigned(frmEditor) then
    begin
    Result := true;

    if (preview = 0) then
      begin
      // reset preview
      if frmEditor.img.Selected then
        frmEditor.img.CopySelectionToIEBitmap(frmEditor.imgPreview.IEBitmap)
      else
        frmEditor.imgPreview.IEBitmap.Assign(frmEditor.img.IEBitmap);
      end
    else
      begin
      // updating preview
      local_preview := TBitmap.Create();
      local_preview.Handle := preview;
      local_preview.ApplyLimits();

      frmEditor.imgPreview.IEBitmap.Assign(local_preview);

      FreeAndNil(local_preview);
      end;

    frmEditor.imgPreview.Update();
    frmEditor.SetCurrentMode(FM_PREVIEW);
    end;
end;

procedure TfrmEditor.boxColorSelectorChange(Sender: TObject);
begin
  sbxColor.Color := boxColorSelector.Color;
end;

procedure TfrmEditor.tbnModPencilClick(Sender: TObject);
begin
  SetCurrentMode(FM_PENCIL);
end;

procedure TfrmEditor.tbnModFloodClick(Sender: TObject);
begin
  SetCurrentMode(FM_FLOODFILL);
end;

procedure TfrmEditor.imgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) then
    begin
    if (nCurrentMode = FM_PENCIL) then
      begin
      // pencil
      proc.AutoUndo := false;
      proc.SaveUndo();
      proc.ClearAllRedo();
      if (proc.AttachedIEBitmap.PixelFormat <> ie24RGB) then
        proc.ConvertTo24Bit();
      proc.AttachedIEBitmap.Pixels_ie24RGB[img.XScr2Bmp(X), img.Yscr2Bmp(Y)] := CreateRGB(boxColorSelector.Red, boxColorSelector.Green, boxColorSelector.Blue);
      img.Update();
      proc.AutoUndo := true;
      end
    else if (nCurrentMode = FM_FLOODFILL) then
      begin
      // flood fill
      proc.CastColor(img.XScr2Bmp(X), img.Yscr2Bmp(Y), CreateRGB(boxColorSelector.Red, boxColorSelector.Green, boxColorSelector.Blue), updTolerance.Position);
      end;
    end;
end;

procedure TfrmEditor.imgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ((ssLeft in Shift) and (nCurrentMode = FM_PENCIL)) then
    begin
    // pencil
    if (proc.AttachedIEBitmap.PixelFormat <> ie24RGB) then
        proc.ConvertTo24Bit();
    proc.AttachedIEBitmap.Pixels_ie24RGB[img.XScr2Bmp(X), img.Yscr2Bmp(Y)] := CreateRGB(boxColorSelector.Red, boxColorSelector.Green, boxColorSelector.Blue);
    img.Update();
    end;
end;

procedure TfrmEditor.FormShow(Sender: TObject);
begin
  btnApply.Realign();
  btnCancel.Realign();
end;

end.
