unit AllGames;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.ComCtrls, HideTreeView, Vcl.StdCtrls, HideComboBox,
  Vcl.Menus, Vcl.ExtCtrls;

type
  TTreeNodeEx = class(TTreeNode)
  public
    sUrl : String;
  end;

  TfrmAllGames = class(TForm)
    tvwTree: THideTreeView;
    popTvw: TPopupMenu;
    popAddFavorite: TMenuItem;
    Panel1: TPanel;
    cmbList: THideComboBox;
    Label1: TLabel;
    cmbSearch: THideComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tvwTreeCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvwTreeDblClick(Sender: TObject);
    procedure cmbListClick(Sender: TObject);
    procedure popAddFavoriteClick(Sender: TObject);
    procedure cmbSearchKeyPress(Sender: TObject; var Key: Char);
    procedure tvwTreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadIndexPage(sUrl: String);
    function _CreateCompetitionUrl(sUrl: String): String;
    procedure _SearchCompetition;
  public
    { Public 宣言 }
  end;

var
  frmAllGames: TfrmAllGames;

implementation

{$R *.dfm}

uses
  HideUtils,
  Main,
  UrlUtils,
  dp;

type
  TPrivateValues = record
    iSearchStartIndex : Integer;
  end;

var
  pv : TPrivateValues;

procedure TfrmAllGames.cmbListClick(Sender: TObject);
var
  s : String;
begin
  Case cmbList.ItemIndex of
    0 : s := 'http://beta.goal.com/ba/sva-natjecanja';
    1 : s := 'http://beta.goal.com/de/alle-wettbewerbe';
    2 : s := 'http://www.goal.com/en/all-competitions';
    3 : s := 'http://www.goal.com/es/todas-las-competiciones';
    4 : s := 'http://www.goal.com/fr/toutes-les-competitions';
    5 : s := 'http://beta.goal.com/hr/sva-natjecanja';
    6 : s := 'http://beta.goal.com/id/semua-kompetisi';
    7 : s := 'http://www.goal.com/it/tutte-le-competizioni';
    8 : s := 'http://beta.goal.com/hu/minden-versenysorozat';
    9 : s := 'http://beta.goal.com/nl/alle-competities';
    10 : s := 'http://beta.goal.com/br/todas-as-competi%C3%A7%C3%B5es';
    11 : s := 'http://beta.goal.com/sw/michuano-yote';
    12 : s := 'http://beta.goal.com/tr/t%C3%BCm-ligler';
    13 : s := 'http://www.goal.com/vn/giaidau-all';
    14 : s := 'http://beta.goal.com/kr/%EB%AA%A8%EB%93%A0-%EB%8C%80%ED%9A%8C';
    15 : s := 'http://www.goal.com/jp/%E5%85%A8%E3%81%A6%E3%81%AE%E5%A4%A7%E4%BC%9A';
    16 : s := 'http://beta.goal.com/zh-hk/%E6%89%80%E6%9C%89-%E8%B3%BD%E4%BA%8B';
  end;
  _LoadIndexPage(s);
end;

procedure TfrmAllGames.cmbSearchKeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    char(VK_RETURN) :
      begin
        Key := char(0);
      	_SearchCompetition;
      end;
  end;
end;

procedure TfrmAllGames.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmAllGames := nil;   //フォーム名に変更する
end;

procedure TfrmAllGames.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
end;

function TfrmAllGames._CreateCompetitionUrl(sUrl: String): String;
var
  sl : TStringList;
  s : String;
begin
  sl := TStringList.Create;
  try
    SplitByString(sUrl, '/', sl);
    if sl[3] = 'en' then
      s := 'fixtures-results'
    else if sl[3] = 'ba' then
      s := 'parovi-rezultati'
    else if sl[3] = 'de' then
      s := 'ergebnisse'
    else if sl[3] = 'es' then
      s := 'partidos-resultados'
    else if sl[3] = 'fr' then
      s := 'matches-resultats'
    else if sl[3] = 'hr' then
      s := 'parovi-rezultati'
    else if sl[3] = 'id' then
      s := 'jadwal-hasil'
    else if sl[3] = 'it' then
      s := 'partite-risultati'
    else if sl[3] = 'hu' then
      s := 'eredmények'
    else if sl[3] = 'nl' then
      s := 'wedstrijduitslagen'
    else if sl[3] = 'br' then
      s := 'partidas-resultados'
    else if sl[3] = 'sw' then
      s := 'matokeo-ya-mechi'
    else if sl[3] = 'tr' then
      s := 'maç-sonuçları'
    else if sl[3] = 'vn' then
      s := 'lichthidau-ketqua'
    else if sl[3] = 'kr' then
      s := '/일정-결과'
    else if sl[3] = 'zh-hk' then
      s := '賽程-賽果'
    else if sl[3] = 'jp' then
      s := '日程・結果';
    if sl.Count = 7 then
      Result := Format('http://%s/%s/%s/%s/%s',
                  [sl[2], sl[3], sl[4], s, sl[6]])
    else
      Result := Format('http://%s/%s/%s/%s/%s',
                  [sl[2], sl[3], sl[4], s, sl[5]])
  finally
    sl.Free;
  end;
end;

procedure TfrmAllGames._LoadIndexPage(sUrl: String);
var
  n, nGroup, nCompe : TTreeNodeEx;
  sl : TStringList;
  sSrc, sDiv, sCompe, sTmp : String;
  iPos, iGroup, iCompe : Integer;
begin
  tvwTree.Items.BeginUpdate;
  tvwTree.Items.Clear;
  sl := TStringList.Create;
  try
    DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);
    sl.Text := CopyStr(sl.Text, '<div class="main-content">', '<aside>');
    //大分類
    iPos := PosText('<p class="part-title clearfix">', sl.Text);
    repeat
      sSrc := CopyStrEx(sl.Text, '<p class="part-title clearfix">', '<p class="part-title clearfix">', iPos);
      sTmp := RemoveHTMLTags(CopyStr(sSrc, '<p class="part-title clearfix">', '</p>'));
      sTmp := ReplaceText(sTmp, '&#039;', '''');
      n := TTreeNodeEx(tvwTree.Items.Add(nil, sTmp));
      //中分類
      iGroup := PosText('/>', sSrc);
      repeat
        sDiv := RemoveLeft(CopyStrEx(sSrc, '/>', '/>', iGroup), 2);
        sTmp := CopyStr(sDiv, '<span class="widget', '</span>');
        sTmp := ReplaceText(RemoveHTMLTags(sTmp), '&#039;', '''');
        nGroup := TTreeNodeEx(tvwTree.Items.AddChild(n, sTmp));
        //小分類
        iCompe := PosText('<li>', sDiv);
        repeat
          sCompe := CopyStrEx(sDiv, '<li>', '</li>', iCompe);
          sTmp := RemoveHTMLTags(sCompe);
          sTmp := ReplaceText(sTmp, '&#039;', '''');
          //Url取得
          sUrl := RemoveLeft(CopyStr(sCompe, '<a href=', '" class'), 9);
          sUrl := frmMain._ConvertToValidUrl(sUrl);
          nCompe := TTreeNodeEx(tvwTree.Items.AddChild(nGroup, sTmp));
          nCompe.sUrl := sUrl;
          iCompe := PosTextEx('<li>', sDiv, iCompe+1);
        until iCompe = 0;
        iGroup := PosTextEx('/>', sSrc, iGroup+1);
      until iGroup = 0;
      iPos := PosTextEx('<p class="part-title clearfix">', sl.Text, iPos+1);
      n.Expanded := True;
    until iPos = 0;
  finally
    sl.Free;
    tvwTree.Items.EndUpdate;
  end;
end;

procedure TfrmAllGames._LoadSettings;
var
  ini : TMemIniFile;
begin
  pv.iSearchStartIndex := 0;
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmAllGames._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmAllGames._SearchCompetition;
var
  n : TTreeNode;
  s : String;
  i : Integer;
begin
  s := Trim(cmbSearch.Text);
  for i := pv.iSearchStartIndex to tvwTree.Items.Count-1 do
  begin
    n := tvwTree.Items[i];
    if ContainsText(n.Text, s) then
    begin
      n.Parent.Expand(True);
      n.Selected := True;
      n.Focused := True;
      pv.iSearchStartIndex := i + 1;
      Exit;
    end;
  end;
  pv.iSearchStartIndex :=0;
end;

procedure TfrmAllGames.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmAllGames.popAddFavoriteClick(Sender: TObject);
var
  n : TTreeNodeEx;
  item : TListItemEx;
  ini : TMemIniFile;
  s : String;
begin
  n := TTreeNodeEx(tvwTree.Selected);
  if n <> nil then
  begin
    s := _CreateCompetitionUrl(n.sUrl);
    ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.fav'), TEncoding.UTF8);
    try
      ini.WriteString('Favorite', n.Parent.Text + '/' + n.Text, s);
    finally
      ini.UpdateFile;
      ini.Free;
    end;
    //お気に入りに追加
    frmMain.pngFlags.PngImages.BeginUpdate;
    try
      item := TListItemEx(frmMain.lvwFav.Items.Add);
      item.Caption := n.Parent.Text + '/' + n.Text;
      item.sFavoriteUrl := s;
      item.iTimeZone := 0;
      s := ExtractElements(item.sFavoriteUrl, 3);
      frmMain.pngFlags.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s.png', [GetApplicationPath, s]));
      item.ImageIndex := frmMain.pngFlags.PngImages.Count-1;
    finally
      frmMain.pngFlags.PngImages.EndUpdate;
    end;
  end;
end;

procedure TfrmAllGames.tvwTreeCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTreeNodeEx;
end;

procedure TfrmAllGames.tvwTreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  tvwTree.ColorizeNodes(Node, State, DefaultDraw);
end;

procedure TfrmAllGames.tvwTreeDblClick(Sender: TObject);
var
  n : TTreeNodeEx;
begin
  n := TTreeNodeEx(tvwTree.Selected);
  if (n <> nil) and (tvwTree.GetSelectedNodeLevel = 2) then
  begin
    frmMain._GetGamesList(_CreateCompetitionUrl(n.sUrl));
  end;
end;

end.
