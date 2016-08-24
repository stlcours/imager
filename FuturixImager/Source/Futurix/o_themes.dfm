object fraOptThemes: TfraOptThemes
  Left = 0
  Top = 0
  Width = 503
  Height = 414
  TabOrder = 0
  object lblSelect: TLabel
    Left = 0
    Top = 0
    Width = 503
    Height = 13
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Select theme:'
    ExplicitWidth = 66
  end
  object lblInfo: TLabel
    AlignWithMargins = True
    Left = 0
    Top = 38
    Width = 503
    Height = 13
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alTop
    ExplicitWidth = 3
  end
  object cbxThemes: TComboBox
    AlignWithMargins = True
    Left = 0
    Top = 15
    Width = 503
    Height = 21
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 2
    Align = alTop
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
    OnSelect = cbxThemesSelect
  end
  object sbxPreview: TScrollBox
    Left = 0
    Top = 57
    Width = 503
    Height = 357
    Align = alClient
    AutoScroll = False
    BorderStyle = bsNone
    TabOrder = 1
    ExplicitTop = 53
    ExplicitHeight = 361
    object tbrPreview: TToolBar
      Left = 0
      Top = 0
      Width = 503
      Height = 22
      AutoSize = True
      Caption = 'tbrPreview'
      Images = imlPreview
      TabOrder = 0
      Wrapable = False
    end
  end
  object imlPreview: TImageList
    ColorDepth = cd32Bit
    Left = 463
    Top = 65
  end
end
