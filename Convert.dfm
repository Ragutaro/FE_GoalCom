object frmConvert: TfrmConvert
  Left = 320
  Top = 432
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12481#12540#12512#21517#22793#25563#12522#12473#12488#12395#36861#21152
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
    Width = 38
    Height = 18
    Caption = 'Label1'
  end
  object btnOk: TButton
    Left = 182
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 136
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object cmbHome: THideComboBox
    Left = 14
    Top = 34
    Width = 413
    Height = 26
    AutoComplete = False
    DropDownCount = 20
    TabOrder = 0
  end
  object cmbAway: THideComboBox
    Left = 14
    Top = 92
    Width = 413
    Height = 26
    AutoComplete = False
    DropDownCount = 20
    TabOrder = 1
  end
  object btnApply: TButton
    Left = 268
    Top = 136
    Width = 75
    Height = 25
    Caption = #36969#29992
    TabOrder = 3
    OnClick = btnApplyClick
  end
end
