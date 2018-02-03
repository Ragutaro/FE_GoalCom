object frmWeb: TfrmWeb
  Left = 332
  Top = 452
  Caption = 'Goal.com 2017 Web'
  ClientHeight = 200
  ClientWidth = 384
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object SpTBXDock1: TSpTBXDock
    Left = 0
    Top = 0
    Width = 384
    Height = 34
    ExplicitWidth = 392
    DesignSize = (
      384
      34)
    object SpTBXToolbar1: TSpTBXToolbar
      Left = 0
      Top = 0
      BorderStyle = bsNone
      Images = frmMain.pngToolbar
      TabOrder = 0
      Caption = 'SpTBXToolbar1'
      object btnAddFavorite: TSpTBXItem
        Caption = #12362#27671#12395#20837#12426#12395#36861#21152
        ImageIndex = 3
        OnClick = btnAddFavoriteClick
      end
    end
    object edtUrl: TEdit
      Left = 44
      Top = 3
      Width = 329
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object web: TWebBrowser
    Left = 0
    Top = 34
    Width = 384
    Height = 166
    Align = alClient
    TabOrder = 1
    OnNavigateComplete2 = webNavigateComplete2
    ExplicitLeft = 4
    ExplicitTop = 46
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000B0270000281100000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
