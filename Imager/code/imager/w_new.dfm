object frmNew: TfrmNew
  Left = 190
  Top = 79
  ActiveControl = btnOK
  BorderStyle = bsDialog
  Caption = 'New Image'
  ClientHeight = 93
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object gbxSize: TGroupBox
    Left = 5
    Top = 3
    Width = 176
    Height = 58
    Caption = ' Size '
    TabOrder = 0
    object lblWidth: TLabel
      Left = 12
      Top = 14
      Width = 32
      Height = 13
      Caption = 'Width:'
    end
    object lblHeight: TLabel
      Left = 88
      Top = 14
      Width = 35
      Height = 13
      Caption = 'Height:'
    end
    object edtWidth: TEdit
      Left = 12
      Top = 27
      Width = 70
      Height = 21
      TabOrder = 0
      Text = '500'
    end
    object edtHeight: TEdit
      Left = 88
      Top = 27
      Width = 75
      Height = 21
      TabOrder = 1
      Text = '350'
    end
  end
  object gbxColor: TGroupBox
    Left = 188
    Top = 3
    Width = 167
    Height = 58
    Caption = ' Background Color '
    TabOrder = 1
    object btnColor: TColorPickerButton
      Left = 13
      Top = 20
      Width = 139
      Height = 25
      CustomText = 'Custom'
      DefaultText = 'Default'
      Flat = True
      PopupSpacing = 8
      SelectionColor = clWhite
      ShowSystemColors = False
    end
  end
  object btnCancel: TButton
    Left = 280
    Top = 65
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 202
    Top = 65
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
end
