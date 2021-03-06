object frmShow: TfrmShow
  Left = 190
  Top = 79
  ActiveControl = btnStart
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Slide Show'
  ClientHeight = 102
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lblTimer: TLabel
    Left = 143
    Top = 7
    Width = 30
    Height = 13
    Caption = 'Timer:'
  end
  object btnStart: TButton
    Left = 2
    Top = 2
    Width = 57
    Height = 25
    Caption = 'Start'
    Default = True
    TabOrder = 0
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 62
    Top = 2
    Width = 54
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = btnStopClick
  end
  object btnSet: TButton
    Left = 220
    Top = 2
    Width = 85
    Height = 25
    Caption = 'Set'
    TabOrder = 2
    OnClick = btnSetClick
  end
  object gbxDirection: TGroupBox
    Left = 2
    Top = 31
    Width = 303
    Height = 38
    Caption = ' Direction '
    TabOrder = 3
    object rbnNormal: TRadioButton
      Left = 10
      Top = 15
      Width = 70
      Height = 17
      Caption = 'Normal'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbnReverse: TRadioButton
      Left = 98
      Top = 15
      Width = 74
      Height = 17
      Caption = 'Reverse'
      TabOrder = 1
    end
    object rbnRandom: TRadioButton
      Left = 197
      Top = 15
      Width = 77
      Height = 17
      Caption = 'Random'
      TabOrder = 2
    end
  end
  object edtTimer: TEdit
    Left = 177
    Top = 4
    Width = 40
    Height = 21
    TabOrder = 4
    Text = '5'
  end
  object stxHint: TStaticText
    Left = 0
    Top = 85
    Width = 307
    Height = 17
    Align = alBottom
    Alignment = taCenter
    Caption = 'Press [F3] to toggle this toolbar during slide show'
    ShowAccelChar = False
    TabOrder = 5
    ExplicitTop = 98
    ExplicitWidth = 241
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerTimer
    Left = 2
    Top = 125
  end
end
