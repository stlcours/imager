object fraOptIconLib: TfraOptIconLib
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
    Caption = 'Select icon set:'
    ExplicitWidth = 73
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
    Margins.Bottom = 2
    Align = alTop
    WordWrap = True
    ExplicitWidth = 3
  end
  object imgPreview: TImage
    Left = 0
    Top = 53
    Width = 503
    Height = 361
    Align = alClient
    Center = True
    ExplicitLeft = 75
    ExplicitTop = 183
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object cbxIconLibs: TComboBox
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
    AutoCloseUp = True
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnSelect = cbxIconLibsSelect
  end
end
