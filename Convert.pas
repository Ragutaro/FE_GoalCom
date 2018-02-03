unit Convert;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.ComCtrls, HideListView, Vcl.StdCtrls, HideComboBox;

type
  TfrmConvert = class(TForm)
    lblHome: TLabel;
    lblAway: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    cmbHome: THideComboBox;
    cmbAway: THideComboBox;
    btnApply: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadNames;
    procedure _SaveConvert;
    procedure _LoadConvert;
  public
    { Public 宣言 }
  end;

var
  frmConvert: TfrmConvert;

implementation

{$R *.dfm}

uses
  HideUtils,
  Main,
  dp;

procedure TfrmConvert.btnApplyClick(Sender: TObject);
begin
  _SaveConvert;
end;

procedure TfrmConvert.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConvert.btnOkClick(Sender: TObject);
begin
  _SaveConvert;
  Close;
end;

procedure TfrmConvert.FormActivate(Sender: TObject);
begin
  _LoadNames;
end;

procedure TfrmConvert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmConvert := nil;   //フォーム名に変更する
end;

procedure TfrmConvert.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
  _LoadConvert;
end;

procedure TfrmConvert._LoadConvert;
var
  ini : TMemIniFile;
  sl : TStringList;
  i : Integer;
begin
  ini := TMemIniFile.Create(ExtractParentPath(Application.ExeName) + 'TeamNames.ini', TEncoding.Unicode);
  sl := TStringList.Create;
  try
    ini.ReadSection('Teams', sl);
    for i := 0 to sl.Count-1 do
    begin
      cmbHome.Items.Add(ini.ReadString('Teams', sl[i], ''));
    end;
    cmbAway.Items.Assign(cmbHome.Items);
  finally
    ini.Free;
    sl.Free;
  end;
end;

procedure TfrmConvert._LoadNames;
var
  item : TListItem;
begin
  item := frmMain.lvwList.Selected;
  if item <> nil then
  begin
    lblHome.Caption := item.SubItems[0];
    lblAway.Caption := item.SubItems[2];
    cmbHome.Text := '';
    cmbAway.Text := '';
  end;
end;

procedure TfrmConvert._LoadSettings;
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

procedure TfrmConvert._SaveConvert;
var
  item : TListItem;
  ini : TMemIniFile;
  s : String;
begin
  item := frmMain.lvwList.Selected;
  if item = nil then Exit;

  ini := TMemIniFile.Create(ExtractParentPath(Application.ExeName) + 'TeamNames.ini', TEncoding.Unicode);
  try
    s := Trim(cmbHome.Text);
    if s <> '' then
    begin
    	ini.WriteString('Teams', lblHome.Caption, s);
      item.SubItems[0] := s;
    end;
    s := Trim(cmbAway.Text);
    if s <> '' then
    begin
    	ini.WriteString('Teams', lblAway.Caption, s);
      item.SubItems[2] := s;
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmConvert._SaveSettings;
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

procedure TfrmConvert.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

end.
