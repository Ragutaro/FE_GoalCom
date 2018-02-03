object frmSetTime: TfrmSetTime
  Left = 347
  Top = 473
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12525#12540#12459#12523#12479#12452#12512#12398#35373#23450
  ClientHeight = 171
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 18
  object lblHome: TLabel
    Left = 14
    Top = 14
    Width = 48
    Height = 18
    Caption = 'lblHome'
  end
  object lblAway: TLabel
    Left = 14
    Top = 72
    Width = 45
    Height = 18
    Caption = 'lblAway'
  end
  object btnOk: TButton
    Left = 182
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 136
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object cmbHome: THideComboBox
    Left = 14
    Top = 34
    Width = 413
    Height = 26
    AutoComplete = False
    DropDownCount = 20
    TabOrder = 2
  end
  object cmbAway: THideComboBox
    Left = 14
    Top = 92
    Width = 413
    Height = 26
    AutoComplete = False
    DropDownCount = 20
    TabOrder = 3
  end
  object btnApply: TButton
    Left = 268
    Top = 136
    Width = 75
    Height = 25
    Caption = #36969#29992
    TabOrder = 4
    OnClick = btnApplyClick
  end
end
