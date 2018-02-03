unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Vcl.ComCtrls, HideListView, TB2Item, SpTBXItem,
  System.ImageList, Vcl.ImgList, PngImageList, TB2Dock, TB2Toolbar, Vcl.ExtCtrls,
  HideLabel, Web.Httpapp, System.NetEncoding, Vcl.Menus, Vcl.ClipBrd,
  SpTBXEditors, System.DateUtils;

type
  TListItemEx = class(TListItem)
  public
    sGameUrl, sFavoriteUrl, sKOTime : String;
    iTimeZone : Integer;
  end;


  TfrmMain = class(TForm)
    SpTBXDock1: TSpTBXDock;
    tbrTools: TSpTBXToolbar;
    pngToolbar: TPngImageList;
    btnDownload: TSpTBXItem;
    Panel1: TPanel;
    splVert: TSplitter;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    btnGoWeb: TSpTBXItem;
    btnUncheck: TSpTBXItem;
    btnCheck: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    panFavorite: TPanel;
    lvwFav: THideListView;
    tbrEditFavorite: TSpTBXToolWindow;
    tbrFavorite: TSpTBXToolbar;
    btnDown: TSpTBXItem;
    btnUp: TSpTBXItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    btnDelete: TSpTBXItem;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    btnSave: TSpTBXItem;
    Panel2: TPanel;
    lvwList: THideListView;
    lblSetsu: THideLabel;
    lblInfo: THideLabel;
    popLvw: TPopupMenu;
    popLvw_AddToConvertList: TMenuItem;
    lblPrev: TLabel;
    lblNext: TLabel;
    popLvw_CopyUrl: TMenuItem;
    panWait: TPanel;
    pngFlags: TPngImageList;
    popInfoBar: TPopupMenu;
    popInfoBar_CopyUrl: TMenuItem;
    btnInputUrl: TSpTBXItem;
    tbrTool3: TSpTBXToolWindow;
    cmbTimeZone: TComboBox;
    tbrTool2: TSpTBXToolWindow;
    chkDeleteUnderAge: TCheckBox;
    N1: TMenuItem;
    popSetTimeZone: TMenuItem;
    btnSetLocalTime: TSpTBXItem;
    popSetTimeZoneEx: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lvwListCreateItemClass(Sender: TCustomListView;
      var ItemClass: TListItemClass);
    procedure btnDownloadClick(Sender: TObject);
    procedure lvwListCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvwFavCreateItemClass(Sender: TCustomListView;
      var ItemClass: TListItemClass);
    procedure lvwFavCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnGoWebClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnUncheckClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lvwFavMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lvwFavDblClick(Sender: TObject);
    procedure popLvw_AddToConvertListClick(Sender: TObject);
    procedure lblPrevClick(Sender: TObject);
    procedure lblNextClick(Sender: TObject);
    procedure lblPrevMouseEnter(Sender: TObject);
    procedure lblPrevMouseLeave(Sender: TObject);
    procedure lvwListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure popLvw_CopyUrlClick(Sender: TObject);
    procedure popInfoBar_CopyUrlClick(Sender: TObject);
    procedure btnInputUrlClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvwFavSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure cmbTimeZoneClick(Sender: TObject);
    procedure popSetTimeZoneClick(Sender: TObject);
    procedure btnSetLocalTimeClick(Sender: TObject);
    procedure popSetTimeZoneExClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadFavorite;
    procedure _RefreshTarget;
    procedure _LoadTimeZoneComboBox;
    procedure _SaveTimeZone;
    procedure _SetKickOffTimeToJST;
    function _SetKickOffTimeToLocalTime(item: TListItemEx): String;
  public
    { Public 宣言 }
    procedure _GetGamesList(const sUrl: String);
    function _ConvertToValidUrl(const sUrl: String): String;
    function _SetTimeZone(src, sTimeZone: String): String;
  end;

var
  frmMain: TfrmMain;
  slGame : TStringList;
  sTargetFile : String;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp,
  unitPluginsCommon,
  AllGames,
  Convert,
  UrlUtils,
  SetTime,
  unt2017;

procedure TfrmMain.btnCheckClick(Sender: TObject);
var
  item : TListItem;
  i : Integer;
begin
  for i := 0 to lvwList.Items.Count-1 do
  begin
    item := lvwList.Items[i];
    if item.Selected then
      item.Checked := True;
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  lvwFav.DeleteSelected;
end;

procedure TfrmMain.btnDownClick(Sender: TObject);
var
  tmpItem : TListItemEx;
  idx : Integer;
begin
  idx := lvwFav.Selected.Index;
  if idx < lvwFav.Items.Count-1 then
  begin
    tmpItem := TListItemEx.Create(lvwFav.Items);
    try
      tmpItem.Assign(TListItemEx(lvwFav.Items[idx+1]));
      tmpItem.sFavoriteUrl := TListItemEx(lvwFav.Items[idx+1]).sFavoriteUrl;
      TListItemEx(lvwFav.Items[idx+1]).Assign(TListItemEx(lvwFav.Items[idx]));
      TListItemEx(lvwFav.Items[idx+1]).sFavoriteUrl := TListItemEx(lvwFav.Items[idx]).sFavoriteUrl;
      TListItemEx(lvwFav.Items[idx]).Assign(tmpItem);
      TListItemEx(lvwFav.Items[idx]).sFavoriteUrl := tmpItem.sFavoriteUrl;
      lvwFav.Items[idx].Selected := False;
      lvwFav.Items[idx+1].Selected := True;
      lvwFav.Items[idx+1].Focused := True;
    finally
      tmpItem.Free;
    end;
  end;
end;

procedure TfrmMain.btnDownloadClick(Sender: TObject);
var
  item : TListItemEx;
  i : Integer;
begin
  _RefreshTarget;
  slGame := TStringList.Create;
  try
    if Not IsDebugMode then
    begin
    	_RefreshTargetFile(Self);
      slGame.LoadFromFile(sTargetFile, TEncoding.Unicode);
    end;

    for i := 0 to lvwList.Items.Count-1 do
    begin
      item := TListItemEx(lvwList.Items[i]);
      if item.Checked and (Not ContainsText(item.Caption, ':'))then
      begin
        lblInfo.Caption := Format('%s x %s を取得中...', [item.SubItems[0], item.SubItems[2]]);
        item.Selected := True;
        item.Focused := True;
        Application.ProcessMessages;
      	_CreateGameData(item.sGameUrl, item.SubItems[3]);
        item.Checked := False;
        item.Selected := False;
        item.Focused := False;
      end;
      Application.ProcessMessages;
    end;

    if IsDebugMode then
      slGame.SaveToFile('C:\Users\ragu\Desktop\' + 'CreatedData.txt', TEncoding.Unicode)
    else
      slGame.SaveToFile(sTargetFile, TEncoding.Unicode);
  finally
    slGame.Free;
  end;
  lblInfo.Caption := '終了しました。';
  _ReloadGamedataFile;
end;

procedure TfrmMain.btnGoWebClick(Sender: TObject);
begin
  Application.CreateForm(TfrmAllGames, frmAllGames);
  frmAllGames.Show;
end;

procedure TfrmMain.btnInputUrlClick(Sender: TObject);
var
  s : String;
begin
  s := InputBox('URLの入力', 'URLを入力して下さい。', '');
  if s <> '' then
  begin
    _RefreshTarget;
    slGame := TStringList.Create;
    try
      if Not IsDebugMode then
      begin
        _RefreshTargetFile(Self);
        slGame.LoadFromFile(sTargetFile, TEncoding.Unicode);
      end;

      lblInfo.Caption := Format('%s を取得中...', [s]);
      _CreateGameData(s, RightStr(cmbTimeZone.Items[cmbTimeZone.ItemIndex], 5));
      if IsDebugMode then
        slGame.SaveToFile('C:\Users\ragu\Desktop\' + 'CreatedData.txt', TEncoding.Unicode)
      else
        slGame.SaveToFile(sTargetFile, TEncoding.Unicode);
    finally
      slGame.Free;
    end;
    lblInfo.Caption := '終了しました。';
    _ReloadGamedataFile;
  end;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
var
  item : TListItemEx;
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.fav'), TEncoding.UTF8);
  try
    ini.Clear;
    for i := 0 to lvwFav.Items.Count-1 do
    begin
      item := TListItemEx(lvwFav.Items[i]);
      ini.WriteString('Favorite', item.Caption, item.sFavoriteUrl + '\' + IntToStr(item.iTimeZone));
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain.btnSetLocalTimeClick(Sender: TObject);
begin
  _SaveTimeZone;
end;

procedure TfrmMain.btnUncheckClick(Sender: TObject);
var
  item : TListItem;
  i : Integer;
begin
  for i := 0 to lvwList.Items.Count-1 do
  begin
    item := lvwList.Items[i];
    if item.Selected then
      item.Checked := False;
  end;
end;

procedure TfrmMain.btnUpClick(Sender: TObject);
var
  tmpItem : TListItemEx;
  idx : Integer;
begin
  idx := lvwFav.Selected.Index;
  if idx > 0 then
  begin
    tmpItem := TListItemEx.Create(lvwFav.Items);
    try
      tmpItem.Assign(TListItemEx(lvwFav.Items[idx-1]));
      tmpItem.sFavoriteUrl := TListItemEx(lvwFav.Items[idx-1]).sFavoriteUrl;
      TListItemEx(lvwFav.Items[idx-1]).Assign(TListItemEx(lvwFav.Items[idx]));
      TListItemEx(lvwFav.Items[idx-1]).sFavoriteUrl := TListItemEx(lvwFav.Items[idx]).sFavoriteUrl;
      TListItemEx(lvwFav.Items[idx]).Assign(tmpItem);
      TListItemEx(lvwFav.Items[idx]).sFavoriteUrl := tmpItem.sFavoriteUrl;
      lvwFav.Items[idx].Selected := False;
      lvwFav.Items[idx-1].Selected := True;
      lvwFav.Items[idx-1].Focused := True;
    finally
      tmpItem.Free;
    end;
  end;
end;

procedure TfrmMain.cmbTimeZoneClick(Sender: TObject);
var
  item : TListItemEx;
  i : Integer;
begin
  for i := 0 to lvwList.Items.Count-1 do
  begin
    item := TListItemEx(lvwList.Items[i]);
    if item.Selected then
    begin
    	item.SubItems[3] := RightStr(cmbTimeZone.Items[cmbTimeZone.ItemIndex], 5);
      item.SubItems[1] := _SetKickOffTimeToLocalTime(item);
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmMain := nil;   //フォーム名に変更する
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
  _LoadFavorite;
  _LoadTimeZoneComboBox;
end;

function TfrmMain._ConvertToValidUrl(const sUrl: String): String;
begin
  if ContainsText(sUrl, 'cxresources') then
    Result := CopyStr(sUrl, 'http://www.goal.com', '">')
  else
    Result := sUrl;
end;

procedure TfrmMain._GetGamesList(const sUrl: String);
var
  ini, iniTMZ : TMemIniFile;
  item : TListItemEx;
  sl : TStringList;
  sSrc, sDate, sStatus, sHome, sAway, sScoH, sScoA, sGameUrl, sPrev, sNext, sSetsu, sSco, sTmz : String;
  iPos : Integer;
begin
  lvwList.Items.BeginUpdate;
  lvwList.Items.Clear;
  sl := TStringList.Create;
  ini := TMemIniFile.Create(ExtractParentPath(Application.ExeName) + 'TeamNames.ini', TEncoding.Unicode);
  iniTMZ := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.tmz'), TEncoding.UTF8);
  try
    panWait.Caption := '取得中...';
    panWait.Top := (Self.Height div 2) - 30;
    panWait.Left := (Self.Width div 2) - 100;
    panWait.Visible := True;
    lblInfo.Caption := String(HTTPDecode(AnsiString(sUrl)));
    Application.ProcessMessages;
    DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);
    sl.SaveToFile(GetApplicationPath + 'Download.html', TEncoding.UTF8);
    iPos := PosText('<div class="match-row', sl.Text);
    repeat
      sSrc := CopyStrEx(sl.Text, '<div class="match-row', '<div class="match-additional-data', iPos);
      sDate := ReplaceText(RemoveLeft(CopyStr(sSrc, 'datetime=', 'T'), 10), '-', '/');
      sStatus := RemoveHTMLTags(CopyStr(sSrc, '<span data-bind="state">', '</span>'));
      if sStatus = '' then
        sStatus := RemoveHTMLTags(CopyStr(sSrc, '<meta itemprop="eventStatus"', ' </time>'));
      sHome := RemoveHTMLTags(CopyStr(sSrc, '<span itemprop="name"', '</span>'));
      sHome := ReplaceTextEx(sHome, ['&amp;', '&#039;'], ['&', '''']);
      sAway := RemoveHTMLTags(CopyStrNext(sSrc, '<span itemprop="name"', '</span>'));
      sAway := ReplaceTextEx(sAway, ['&amp;', '&#039;'], ['&', '''']);
      sHome := ini.ReadString('Teams', sHome, sHome);
      sAway := ini.ReadString('Teams', sAway, sAway);
      sScoH := RemoveHTMLTags(CopyStr(sSrc, '<span class="goals"', '</span>'));
      sScoA := RemoveHTMLTags(CopyStrNext(sSrc, '<span class="goals"', '</span>'));
      if ContainsText(sStatus, ':') then
        sSco := sStatus
      else
        sSco := sScoH + '-' + sScoA;
      sGameUrl := RemoveLeft(CopyStr(sSrc, 'href="', '">'), 6);
      sGameUrl := _ConvertToValidUrl(sGameUrl);
      //ホームチームのタイムゾーンの取得
      sTmz := RightStr(cmbTimeZone.Items[cmbTimeZone.ItemIndex], 5);
      sTmz := iniTMZ.ReadString('TimeZone', sHome, sTmz);
      //Add items
      item := TListItemEx(lvwList.Items.Add);
      item.Caption := sDate + ' ' + ReplaceText(sStatus, '&#039;', chr(39));
      item.SubItems.Add(sHome);
      item.SubItems.Add(sSco);
      item.SubItems.Add(sAway);
      item.SubItems.Add(sTmz);
      item.sGameUrl := sGameUrl;
      item.sKOTime  := sSco;
      iPos := PosTextEx('<div class="match-row', sl.Text, iPos + 1);
    until (iPos = 0);
    //表示中の節を取得
    sSrc := CopyStr(sl.Text, '<div class="nav-switch__label">', '</div>');
    sSetsu := RemoveHTMLTags(sSrc);
    lblSetsu.Caption := sSetsu;
    //前節
    sSrc := CopyStr(sl.Text, '<div class="nav-switch">', '<div class="match-row');
    sPrev := RemoveLeft(CopyStr(sSrc, '<a href=', '" class='), 9);
    sPrev := _ConvertToValidUrl(sPrev);
    sNext := RemoveLeft(CopyStrNext(sSrc, '<a href=', '" class='), 9);
    sNext := _ConvertToValidUrl(sNext);
    lblPrev.Visible := True;
    lblNext.Visible := True;
    if sNext <> '' then
    begin
      lblPrev.Hint := sPrev;
      lblNext.Hint := sNext;
    end
    else
    begin
      lblNext.Hint := sPrev;
      lblPrev.Visible := False;
    end;

    //JSTに変換
    _SetKickOffTimeToJST;

  finally
    sl.Free;
    ini.Free;
    iniTMZ.Free;
    lvwList.Items.EndUpdate;
    panWait.Visible := False;
  end;
end;

procedure TfrmMain._LoadFavorite;
var
  item : TListItemEx;
  ini : TMemIniFile;
  sl : TStringList;
  i : Integer;
  s, sUrl, sIndex : String;
begin
  pngFlags.PngImages.BeginUpdate;
  pngFlags.PngImages.Clear;
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.fav'), TEncoding.UTF8);
  sl := TStringList.Create;
  try
    ini.ReadSection('Favorite', sl);
    for i := 0 to sl.Count-1 do
    begin
      item := TListItemEx(lvwFav.Items.Add);
      item.Caption := sl[i];
      s := ini.ReadString('Favorite', sl[i], '');
      SplitStringsToAandB(s, '\', sUrl, sIndex);
      item.sFavoriteUrl := sUrl;
      item.iTimeZone := StrToIntDefEx(sIndex, 0);
      s := ExtractElements(item.sFavoriteUrl, 3);
      pngFlags.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s.png', [GetApplicationPath, s]));
      item.ImageIndex := pngFlags.PngImages.Count-1;
    end;
  finally
    ini.Free;
    sl.Free;
    pngFlags.PngImages.EndUpdate;
  end;
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
    lvwList.Column[0].Width := ini.ReadInteger(Self.Name, 'lvwListColumn[0]Width', lvwList.Column[0].Width);
    lvwList.Column[1].Width := ini.ReadInteger(Self.Name, 'lvwListColumn[1]Width', lvwList.Column[1].Width);
    lvwList.Column[2].Width := ini.ReadInteger(Self.Name, 'lvwListColumn[2]Width', lvwList.Column[2].Width);
    lvwList.Column[3].Width := ini.ReadInteger(Self.Name, 'lvwListColumn[3]Width', lvwList.Column[3].Width);
    lvwList.Column[4].Width := ini.ReadInteger(Self.Name, 'lvwListColumn[4]Width', lvwList.Column[4].Width);
    panFavorite.Width := ini.ReadInteger(Self.Name, 'panFavorite.Width', panFavorite.Width);
    tbrTools.DockPos := ini.ReadInteger(Self.Name, 'tbrTools.DockPos', -1);
    tbrTools.DockRow := ini.ReadInteger(Self.Name, 'tbrTools.DockRow', 0);
    tbrTool2.DockPos := ini.ReadInteger(Self.Name, 'tbrTool2.DockPos', tbrTool2.DockPos);
    tbrTool2.DockRow := ini.ReadInteger(Self.Name, 'tbrTool2.DockRow', tbrTool2.DockRow);
    tbrTool3.DockPos := ini.ReadInteger(Self.Name, 'tbrTool3.DockPos', tbrTool3.DockPos);
    tbrTool3.DockRow := ini.ReadInteger(Self.Name, 'tbrTool3.DockRow', tbrTool3.DockRow);
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._LoadTimeZoneComboBox;
begin
  cmbTimeZone.Items.Add('グリニッジ標準時 +0000');
  cmbTimeZone.Items.Add('日本標準時 +0900');
  cmbTimeZone.Items.Add('--- 北中米 ---');
  cmbTimeZone.Items.Add('米国東部標準時 -0500');
  cmbTimeZone.Items.Add('米国東部標準時(夏時間) -0400');
  cmbTimeZone.Items.Add('米国中部標準時 -0600');
  cmbTimeZone.Items.Add('米国中部標準時(夏時間) -0500');
  cmbTimeZone.Items.Add('米国山岳部標準時(夏時間) -0600');
  cmbTimeZone.Items.Add('米国山岳部標準時 -0700');
  cmbTimeZone.Items.Add('米国太平洋標準時 -0800');
  cmbTimeZone.Items.Add('米国太平洋標準時(夏時間) -0700');
  cmbTimeZone.Items.Add('アラスカ標準時 -0900');
  cmbTimeZone.Items.Add('アラスカ標準時(夏時間) -0800');
  cmbTimeZone.Items.Add('ハワイ標準時 -1000');
  cmbTimeZone.Items.Add('キューバ標準時 -0500');
  cmbTimeZone.Items.Add('キューバ標準時(夏時間) -0400');
  cmbTimeZone.Items.Add('--- 南米 ---');
  cmbTimeZone.Items.Add('ブラジル時間 -0300');
  cmbTimeZone.Items.Add('アルゼンチン時間 -0300');
  cmbTimeZone.Items.Add('ウルグアイ時間 -0300');
  cmbTimeZone.Items.Add('チリ標準時 -0400');
  cmbTimeZone.Items.Add('チリ標準時(夏時間) -0300');
  cmbTimeZone.Items.Add('ボリビア時間 -0400');
  cmbTimeZone.Items.Add('エクアドル時間 -0500');
  cmbTimeZone.Items.Add('コロンビア時間 -0500');
  cmbTimeZone.Items.Add('ペルー時間 -0500');
  cmbTimeZone.Items.Add('サモア標準時 -1100');
  cmbTimeZone.Items.Add('--- 欧州 ---');
  cmbTimeZone.Items.Add('西ヨーロッパ時間 +0000');
  cmbTimeZone.Items.Add('西ヨーロッパ時間(夏時間) +0100');
  cmbTimeZone.Items.Add('英国 +0000');
  cmbTimeZone.Items.Add('英国(夏時間) +0100');
  cmbTimeZone.Items.Add('中央ヨーロッパ時間 +0100');
  cmbTimeZone.Items.Add('中央ヨーロッパ時間(夏時間) +0200');
  cmbTimeZone.Items.Add('東ヨーロッパ時間 +0200');
  cmbTimeZone.Items.Add('東ヨーロッパ時間(夏時間) +0300');
  cmbTimeZone.Items.Add('--- アフリカ ---');
  cmbTimeZone.Items.Add('西アフリカ時間 +0100');
  cmbTimeZone.Items.Add('中央アフリカ時間 +0200');
  cmbTimeZone.Items.Add('東アフリカ時間 +0300');
  cmbTimeZone.Items.Add('--- アジア ---');
  cmbTimeZone.Items.Add('イスラエル標準時 +0200');
  cmbTimeZone.Items.Add('イスラエル標準時(夏時間) +0300');
  cmbTimeZone.Items.Add('イラン標準時 +0330');
  cmbTimeZone.Items.Add('湾岸標準時 +0400');
  cmbTimeZone.Items.Add('イラン標準時(夏時間) +0430');
  cmbTimeZone.Items.Add('アフガニスタン時間 +0430');
  cmbTimeZone.Items.Add('パキスタン標準時 +0500');
  cmbTimeZone.Items.Add('インド標準時 +0530');
  cmbTimeZone.Items.Add('ネパール時間 +0545');
  cmbTimeZone.Items.Add('バングラデシュ時間 +0600');
  cmbTimeZone.Items.Add('ブータン時間 +0600');
  cmbTimeZone.Items.Add('ココス諸島時間 +0630');
  cmbTimeZone.Items.Add('ミュンマー時間 +0630');
  cmbTimeZone.Items.Add('インドシナ時間 +0700');
  cmbTimeZone.Items.Add('インドネシア西部標準時 +0700');
  cmbTimeZone.Items.Add('インドネシア中部標準時 +0800');
  cmbTimeZone.Items.Add('インドネシア東部標準時 +0900');
  cmbTimeZone.Items.Add('フィリピン標準時 +0800');
  cmbTimeZone.Items.Add('マレーシア時間 +0800');
  cmbTimeZone.Items.Add('ブルネイ時間 +0800');
  cmbTimeZone.Items.Add('香港時間 +0800');
  cmbTimeZone.Items.Add('中国標準時 +0800');
  cmbTimeZone.Items.Add('韓国標準時 +0900');
  cmbTimeZone.Items.Add('パラオ時間 +0900');
  cmbTimeZone.Items.Add('オーストラリア西部標準時 +0800');
  cmbTimeZone.Items.Add('オーストラリア西部標準時(夏時間) +0900');
  cmbTimeZone.Items.Add('オーストラリア中部標準時 +0930');
  cmbTimeZone.Items.Add('オーストラリア中部標準時(夏時間) +1030');
  cmbTimeZone.Items.Add('オーストラリア東部標準時 +1000');
  cmbTimeZone.Items.Add('オーストラリア東部標準時(夏時間) +1100');
  cmbTimeZone.Items.Add('ニュージーランド時間 +1200');
  cmbTimeZone.Items.Add('ニュージーランド時間(夏時間) +1300');
  cmbTimeZone.Items.Add('チャモロ標準時 +1000');
  cmbTimeZone.Items.Add('フィジー時間 +1200');
  cmbTimeZone.Items.Add('フィジー時間(夏時間) +1300');
end;

procedure TfrmMain._RefreshTarget;
var
  ini : TMemIniFile;
begin
  //通常時
  ini := TMemIniFile.Create(ExtractParentPath(Application.ExeName) + 'CurrentFileName.tmp', TEncoding.Unicode);
  try
    sTargetFile := ini.ReadString('Setting', 'Name', '');
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
    ini.WriteInteger(Self.Name, 'lvwListColumn[0]Width', lvwList.Column[0].Width);
    ini.WriteInteger(Self.Name, 'lvwListColumn[1]Width', lvwList.Column[1].Width);
    ini.WriteInteger(Self.Name, 'lvwListColumn[2]Width', lvwList.Column[2].Width);
    ini.WriteInteger(Self.Name, 'lvwListColumn[3]Width', lvwList.Column[3].Width);
    ini.WriteInteger(Self.Name, 'lvwListColumn[4]Width', lvwList.Column[4].Width);
    ini.WriteInteger(Self.Name, 'panFavorite.Width', panFavorite.Width);
    ini.WriteInteger(Self.Name, 'tbrTools.DockPos', tbrTools.DockPos);
    ini.WriteInteger(Self.Name, 'tbrTools.DockRow', tbrTools.DockRow);
    ini.WriteInteger(Self.Name, 'tbrTool2.DockPos', tbrTool2.DockPos);
    ini.WriteInteger(Self.Name, 'tbrTool2.DockRow', tbrTool2.DockRow);
    ini.WriteInteger(Self.Name, 'tbrTool3.DockPos', tbrTool3.DockPos);
    ini.WriteInteger(Self.Name, 'tbrTool3.DockRow', tbrTool3.DockRow);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain._SaveTimeZone;
var
  item : TListItemEx;
  ini : TMemIniFile;
  s : String;
begin
  item := TListItemEx(lvwFav.Selected);
  if item <> nil then
  begin
    ini := TMemIniFile.Create(GetApplicationPath + 'plugin_GoalCom2017.fav', TEncoding.UTF8);
    try
      item.iTimeZone := cmbTimeZone.ItemIndex;
      s := item.sFavoriteUrl + '\' + IntToStr(cmbTimeZone.ItemIndex);
      ini.WriteString('Favorite', item.Caption, s);
    finally
      ini.UpdateFile;
      ini.Free;
    end;
  end;
end;

procedure TfrmMain._SetKickOffTimeToJST;
var
  item : TListItemEx;
  i, iInc : Integer;
  d : TDateTime;
begin
  iInc := 9;
  for i := 0 to lvwList.Items.Count-1 do
  begin
    item := TListItemEx(lvwList.Items[i]);
    if Pos(':', item.Caption) > 1 then
    begin
      d := StrToDateTime(item.Caption + ':00');
      d := IncHour(d, iInc);
      item.Caption := FormatDateTime('YYYY/MM/DD HH:NN', d);
      //K.O Time
      item.SubItems[1] := _SetKickOffTimeToLocalTime(item);
    end;
  end;
end;

function TfrmMain._SetKickOffTimeToLocalTime(item: TListItemEx): String;
var
  iHour, iMin : Integer;
  t : TTime;
begin
  if Pos(':', item.sKOTime) > 0 then
  begin
    iHour := StrToInt(Copy(item.SubItems[3], 2, 2));
    iMin  := StrToInt(RightStr(item.SubItems[3], 2));
    t     := StrToTime(item.sKOTime);
    if LeftStr(item.SubItems[3], 1) = '+' then
    begin
      t := IncHour(t, iHour);
      t := IncMinute(t, iMin);
    end
    else
    begin
      t := IncHour(t, -1*iHour);
      t := IncMinute(t, -1*iMin);
    end;
    Result := FormatDateTime('HH:NN', t);
  end;
end;

function TfrmMain._SetTimeZone(src, sTimeZone: String): String;
var
  t : TDateTime;
  iHour, iMin : Integer;
begin
  t := StrToDateTime('2017/01/01 ' + src);
  iHour := StrToInt(Copy(sTimeZone, 2, 2)); //9
  iMin  := StrToInt(Copy(sTimeZone, 4, 2)); //30
  if LeftStr(sTimeZone, 1) = '+' then
  begin
    t := IncHour(t, iHour);
    t := IncMinute(t, iMin);
  end
  else
  begin
    t := IncHour(t, -1 * iHour);
    t := IncMinute(t, -1 * iMin);
  end;
  Result := FormatDateTime('HH:NN', t);
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  cmbTimeZone.ItemIndex := 0;
end;

procedure TfrmMain.lblNextClick(Sender: TObject);
begin
  if lblNext.Hint <> '' then
    _GetGamesList(lblNext.Hint);
end;

procedure TfrmMain.lblPrevClick(Sender: TObject);
begin
  if lblPrev.Hint <> '' then
    _GetGamesList(lblPrev.Hint);
end;

procedure TfrmMain.lblPrevMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clRed;
  TLabel(Sender).Font.Style := [fsUnderline];
  lblInfo.Caption := TLabel(Sender).Hint;
end;

procedure TfrmMain.lblPrevMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clWhite;
  TLabel(Sender).Font.Style := [];
  lblInfo.Caption := '';
end;

procedure TfrmMain.lvwFavCreateItemClass(Sender: TCustomListView;
  var ItemClass: TListItemClass);
begin
  ItemClass := TListItemEx;
end;

procedure TfrmMain.lvwFavCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  lvwFav.SetListitemBackgroundColor(Item, $00FEFAF8, False, DefaultDraw);
  lvwFav.SetHoverStyle(State, DefaultDraw);
end;

procedure TfrmMain.lvwFavDblClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwFav.Selected);
  if item <> nil then
  begin
    _GetGamesList(item.sFavoriteUrl);
  end;
end;

procedure TfrmMain.lvwFavMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  item : TListItemEx;
begin
  if Y > (lvwFav.Height - 30) then
    tbrEditFavorite.Visible := True
  else
    tbrEditFavorite.Visible := False;

  item := TListItemEx(lvwFav.GetItemAt(X, Y));
  if item <> nil then
    lblInfo.Caption := String(HTTPDecode(AnsiString(item.sFavoriteUrl)));
end;

procedure TfrmMain.lvwFavSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  cmbTimeZone.ItemIndex := TListItemEx(item).iTimeZone;
end;

procedure TfrmMain.lvwListCreateItemClass(Sender: TCustomListView;
  var ItemClass: TListItemClass);
begin
  ItemClass := TListItemEx;
end;

procedure TfrmMain.lvwListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  lvwList.SetListitemBackgroundColor(Item, $00FEFAF8, False, DefaultDraw);
  lvwList.SetHoverStyle(State, DefaultDraw);
  with lvwList.Canvas do
  begin
    if Pos(':', Item.SubItems[1]) > 0 then
    begin
      Font.Color := clLtGray;
    end;
  end;
end;

procedure TfrmMain.lvwListMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.GetItemAt(X, Y));
  if item <> nil then
    lblInfo.Caption := String(HTTPDecode(AnsiString(item.sGameUrl)));
end;

procedure TfrmMain.popInfoBar_CopyUrlClick(Sender: TObject);
begin
  Clipboard.AsText := lblInfo.Caption;
end;

procedure TfrmMain.popLvw_AddToConvertListClick(Sender: TObject);
begin
  Application.CreateForm(TfrmConvert, frmConvert);
  frmConvert.Show;
end;

procedure TfrmMain.popLvw_CopyUrlClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
    Clipboard.AsText := item.sGameUrl;
end;

procedure TfrmMain.popSetTimeZoneClick(Sender: TObject);
var
  item : TListItem;
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.tmz'), TEncoding.UTF8);
  try
    for i := 0 to lvwList.Items.Count-1 do
    begin
      item := lvwList.Items[i];
      if item.Selected then
        ini.WriteString('TimeZone', item.SubItems[0], item.SubItems[3]);
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain.popSetTimeZoneExClick(Sender: TObject);
begin
  Application.CreateForm(TfrmSetTime, frmSetTime);
  frmSetTime.Show;
end;

end.
