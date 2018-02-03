unit Web;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, TB2Dock, TB2Toolbar, SpTBXItem, TB2Item,
  Vcl.OleCtrls, SHDocVw;

type
  TfrmWeb = class(TForm)
    SpTBXDock1: TSpTBXDock;
    SpTBXToolbar1: TSpTBXToolbar;
    btnAddFavorite: TSpTBXItem;
    web: TWebBrowser;
    edtUrl: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddFavoriteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure webNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      const [Ref] URL: OleVariant);
    procedure FormResize(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
  public
    { Public 宣言 }
  end;

var
  frmWeb: TfrmWeb;

implementation

{$R *.dfm}

uses
  HideUtils,
  Main,
  dp;

procedure TfrmWeb.btnAddFavoriteClick(Sender: TObject);
var
  item : TListItemEx;
  ini : TMemIniFile;
  s : String;
begin
  s := Trim(InputBox('お気に入りに追加', 'お気に入りに表示する名称を入力してください。', ''));
  if s <> '' then
  begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.fav'), TEncoding.UTF8);
    try
      ini.WriteString('Favorite', s, edtUrl.Text);
    finally
      ini.UpdateFile;
      ini.Free;
    end;
    //お気に入りに追加
    item := TListItemEx(frmMain.lvwFav.Items.Add);
    item.Caption := s;
    item.sFavoriteUrl := edtUrl.Text;
  end;
end;

procedure TfrmWeb.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmWeb := nil;   //フォーム名に変更する
end;

procedure TfrmWeb.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  WriteIEVersionToRegistry;
  _LoadSettings;
end;

procedure TfrmWeb._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmWeb._SaveSettings;
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

procedure TfrmWeb.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmWeb.FormResize(Sender: TObject);
begin
  edtUrl.Width := Self.Width - 70;
end;

procedure TfrmWeb.FormShow(Sender: TObject);
begin
  web.Navigate('http://www.goal.com/en/all-competitions');
end;

procedure TfrmWeb.webNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
  const [Ref] URL: OleVariant);
begin
  edtUrl.Text := web.LocationURL;
end;

end.
