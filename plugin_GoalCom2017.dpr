program plugin_GoalCom2017;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  unt2017 in 'unt2017.pas',
  Vcl.Themes,
  Vcl.Styles,
  unitPluginsCommon in '..\unitPluginsCommon.pas',
  AllGames in 'AllGames.pas' {frmAllGames},
  Convert in 'Convert.pas' {frmConvert},
  SetTime in 'SetTime.pas' {frmSetTime};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
