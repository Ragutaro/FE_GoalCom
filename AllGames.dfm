object frmAllGames: TfrmAllGames
  Left = 320
  Top = 449
  BorderStyle = bsSizeToolWin
  Caption = #22823#20250#12539#12522#12540#12464#12398#36984#25246
  ClientHeight = 274
  ClientWidth = 338
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
  PixelsPerInch = 96
  TextHeight = 18
  object tvwTree: THideTreeView
    Left = 0
    Top = 26
    Width = 338
    Height = 248
    Align = alClient
    HideSelection = False
    Indent = 19
    PopupMenu = popTvw
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    OnCreateNodeClass = tvwTreeCreateNodeClass
    OnDblClick = tvwTreeDblClick
    ExplicitTop = 234
    ExplicitWidth = 300
    ExplicitHeight = 158
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 26
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 120
      Top = 3
      Width = 29
      Height = 18
      Caption = #26908#32034':'
    end
    object cmbList: THideComboBox
      Left = 0
      Top = 0
      Width = 111
      Height = 26
      Align = alLeft
      AutoComplete = False
      Style = csDropDownList
      DropDownCount = 20
      TabOrder = 0
      OnClick = cmbListClick
      Items.Strings = (
        'Bosanski'
        'Deutsch'
        'English'
        'Espa'#241'ol'
        'Fran'#231'ais'
        'Hrvatski'
        'Indonesia'
        'Italiano'
        'Magyar'
        'Nederlands'
        'Portugu'#234's'
        'Swahili'
        'T'#252'rk'#231'e'
        'Vi'#7879't Nam'
        #54620#44397#50612
        #26085#26412#35486
        #32321#39636#20013#25991)
    end
    object cmbSearch: THideComboBox
      Left = 155
      Top = 0
      Width = 183
      Height = 26
      Align = alRight
      AutoComplete = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      OnKeyPress = cmbSearchKeyPress
    end
  end
  object popTvw: TPopupMenu
    Left = 104
    Top = 54
    object popAddFavorite: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152
      OnClick = popAddFavoriteClick
    end
  end
end
