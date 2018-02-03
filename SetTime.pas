unit SetTime;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, HideComboBox, Vcl.ComCtrls, HideListView;

type
  TfrmSetTime = class(TForm)
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
    procedure _LoadTimeZone;
    procedure _SaveTimeZones;
  public
    { Public 宣言 }
  end;

var
  frmSetTime: TfrmSetTime;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp,
  Main;

procedure TfrmSetTime.btnApplyClick(Sender: TObject);
begin
  _SaveTimeZones;
end;

procedure TfrmSetTime.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSetTime.btnOkClick(Sender: TObject);
begin
  _SaveTimeZones;
  Close;
end;

procedure TfrmSetTime.FormActivate(Sender: TObject);
var
  item : TListItem;
begin
  item := frmMain.lvwList.Selected;
  if item <> nil then
  begin
    lblHome.Caption := item.SubItems[0];
    lblAway.Caption := item.SubItems[2];
  end;
end;

procedure TfrmSetTime.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmSetTime := nil;   //フォーム名に変更する
end;

procedure TfrmSetTime.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
  _LoadTimeZone;
end;

procedure TfrmSetTime._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 9);
  finally
    ini.Free;
  end;
end;

procedure TfrmSetTime._LoadTimeZone;
begin
  cmbHome.Items.Assign(frmMain.cmbTimeZone.Items);
  cmbAway.Items.Assign(frmMain.cmbTimeZone.Items);
end;

procedure TfrmSetTime._SaveSettings;
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

procedure TfrmSetTime._SaveTimeZones;
var
  ini : TMemIniFile;
begin

  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.tmz'), TEncoding.UTF8);
  try
    if (cmbHome.ItemIndex > -1) and (LeftStr(cmbHome.Text, 1) <> '-') then
      ini.WriteString('TimeZone', lblHome.Caption, RightStr(cmbHome.Text, 5));
    if (cmbAway.ItemIndex > -1) and (LeftStr(cmbAway.Text, 1) <> '-') then
      ini.WriteString('TimeZone', lblAway.Caption, RightStr(cmbAway.Text, 5));
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmSetTime.FormKeyPress(Sender: TObject; var Key: Char);
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

