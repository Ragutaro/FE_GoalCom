{
    1		  日付
    2		  会場
    3		  ホームチーム
    4		  アウェイチーム
    5		  結果(○△●)
    6	  	H 前半
    7		  A 前半
    8		  H 後半
    9		  A 後半
    10		H 総得点
    11		A 総得点
    12		大会名
    13		H得点者(改行は %n%)
    14		A得点者(改行は %n%)
    15		観衆$気温$湿度
    16		コメント
    17		フォーメーション
    18		H 延長前半
    19		A 延長前半
    20		H 延長後半
    21		A 延長後半
    22		H PK
    23		A PK
    24		延長の有無(0|1)
    25		気候(Def='50')
    26		登録ファイル(a;b;c);
    27		節
    28		出場選手(H#A)
    29		スタッツ
    30		審判(Ref1;Ref2;Ref3;Ref4;Ref5;Ref6)
    31		K.O時間
    32		得点経過
    33		PK戦
    34		''
    35		''
    36		''
    37		''
    38		''
    39		''

    *改変履歴
    2014.06.08 作成

}
unit unt2017;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Forms;

  procedure _InitData;
  procedure _CreateFinalData(sUrl: String);
  procedure _CreateStats(sl: TStringList);
  procedure _CreateMeberList(const sUrl: String);
  procedure _CreateGameInformations(sl: TStringList; sTimeZone: String);
  function _CreateUrl(sUrl: String): String;
  procedure _CreateGameData(sUrl, sTimeZone: String);

implementation

uses
  HideUtils,
  Main,
  dp;

type
  TPrivateValues = record
    iYellowH, iYellowA, iRedH, iRedA : Integer;
  end;

var
  sGMD : array[1..39] of String;
  pv : TPrivateValues;
  slPlayer : TStringList;

procedure _InitData;
var
  i : Integer;
begin
  pv.iYellowH := 0;
  pv.iYellowA := 0;
  pv.iRedH := 0;
  pv.iRedA := 0;
  for i := 1 to 39 do
    sGMD[i] := '';
  for i := 6 to 9 do
    sGMD[i] := '0';
end;

procedure _CreateFinalData(sUrl: String);
var
  sl : TStringList;
  i : Integer;
begin
  sGMD[26] := sUrl + ';';
  sl := TStringList.Create;
  try
    for i := 1 to 39 do
    begin
      sl.Add(sGMD[i]);
    end;
    slGame.Add(sl.CommaText);
  finally
    sl.Free;
  end;
end;

procedure _CreateStats(sl: TStringList);
var
  src, sTmp, sPosH, sPosA, sShotTotalH, sShotTotalA, sShotOnGoalH, sShotOnGoalA : String;
begin
  src := CopyStr(sl.Text, 'data-module="match/stats">', '<div class="stats-passes">');
  sTmp := CopyStr(src, '<div class="stats-possession"', '">');
  sPosH := ExtractSelectedChar(sTmp, '0123456789.');
  sPosA := FloatToStr(100-StrToFloat(sPosH));
  sShotTotalH := RemoveHTMLTags(CopyStr(src, '<span class="value-home">', '</span>'));
  sShotTotalA := RemoveHTMLTags(CopyStr(src, '<span class="value-away">', '</span>'));
  sShotOnGoalH := RemoveHTMLTags(CopyStrNext(src, '<span class="value-home">', '</span>'));
  sShotOnGoalA := RemoveHTMLTags(CopyStrNext(src, '<span class="value-away">', '</span>'));
  sShotTotalH := IntToStr(StrToIntDefEx(sShotTotalH, 0) + StrToIntDefEx(sShotOnGoalH, 0));
  sShotTotalA := IntToStr(StrToIntDefEx(sShotTotalA, 0) + StrToIntDefEx(sShotOnGoalA, 0));
  sGMD[29] := Format('%s$%s$%s$%s$$$$$$$$$%d$%d$%d$%d$%s$%s',
                    [sShotTotalH, sShotTotalA, sShotOnGoalH, sShotOnGoalA, pv.iYellowH, pv.iYellowA, pv.iRedH, pv.iRedA, sPosH, sPosA]);
end;

procedure _CreateMeberList(const sUrl: String);
var
  sl, sm : TStringList;
  sSrc, sTmp, sTime, sIn, sOut, sHome, sAway : String;
  iPos, i : Integer;
begin
  sl := TStringList.Create;
  sm := TStringList.Create;
  try
    DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);
    //選手交代、カード
    sSrc := CopyStr(sl.Text, '<h2 class="card-title">', '<div class="overview">');
    iPos := PosText('<div class="event-time">', sSrc);
    repeat
      sTmp := CopyStrEx(sSrc, '<div class="event-time">', '<div class="event">', iPos);
      //ゴールの場合は処理を飛ばす
      if Not ContainsText(sTmp, 'match-event-icon type-goal') then
      begin
        sTime := RemoveRight(RemoveHTMLTags(CopyStrToStr(sTmp, '&')), 1);
        sIn := RemoveHTMLTags(CopyStr(sTmp, '<div class="event-text-main">', '</div>'));
        sOut := RemoveHTMLTags(CopyStr(sTmp, '<div class="event-text-additional">', '</div>'));

        sm.Delimiter := '$';
        if ContainsText(sTmp, 'match-event-icon type-substitution') then
        begin
          for i := 0 to slPlayer.Count-1 do
          begin
            SplitByString(slPlayer[i], '$', sm);
            //途中出場
            if sm[3] = sIn then
            begin
              sm[4] := sTime;
              slPlayer[i] := Format('%s$%s$%s$%s$%s$%s$%s', [sm[0], sm[1], sm[2], sm[3], sm[4], sm[5], sm[6]]);
            end
            //途中交代
            else if sm[3] = sOut then
            begin
              sm[5] := sTime;
              slPlayer[i] := Format('%s$%s$%s$%s$%s$%s$%s', [sm[0], sm[1], sm[2], sm[3], sm[4], sm[5], sm[6]]);
            end;
          end;
        end
        else if ContainsText(sTmp, 'match-event-icon type-yellow_card') then
        begin
          for i := 0 to slPlayer.Count-1 do
          begin
            SplitByString(slPlayer[i], '$', sm);
            if sm[3] = sIn then
            begin
              if sm[6] = '1' then
                sm[6] := '2'
              else
                sm[6] := '1';
              //Yellowの集計
              if sm[0] = 'H' then
                pv.iYellowH := pv.iYellowH + 1
              else
                pv.iYellowA := pv.iYellowA + 1;
              slPlayer[i] := Format('%s$%s$%s$%s$%s$%s$%s', [sm[0], sm[1], sm[2], sm[3], sm[4], sm[5], sm[6]]);
              Break;
            end;
          end;
        end
        else if ContainsText(sTmp, 'match-event-icon type-red_card') then
        begin
          for i := 0 to slPlayer.Count-1 do
          begin
            SplitByString(slPlayer[i], '$', sm);
            if sm[3] = sIn then
            begin
              sm[5] := sTime;
              if sm[6] = '1' then
                sm[6] := '4'
              else
                sm[6] := '3';
              //Redの集計
              if sm[0] = 'H' then
                pv.iRedH := pv.iRedH + 1
              else
                pv.iRedA := pv.iRedA + 1;
              slPlayer[i] := Format('%s$%s$%s$%s$%s$%s$%s', [sm[0], sm[1], sm[2], sm[3], sm[4], sm[5], sm[6]]);
              Break;
            end;
          end;
        end;
      end;
      iPos := PosTextEx('<div class="event-time">', sSrc, iPos+1);
    until iPos = 0;

    sHome := '';  sAway := '';
    for i := 0 to slPlayer.Count-1 do
    begin
      if LeftStr(slPlayer[i], 1) = 'H' then
        sHome := sHome + RemoveLeft(slPlayer[i], 2) + '%'
      else if LeftStr(slPlayer[i], 1) = 'A' then
        sAway := sAway + RemoveLeft(slPlayer[i], 2) + '%';
    end;
    sGMD[28] := sHome + '#' + sAway;
    //スタッツ
    _CreateStats(sl);
  finally
    sl.Free;
    sm.Free;
  end;
end;

procedure _CreateGameInformations(sl: TStringList; sTimeZone: String);
  procedure in_CreateScore(src: String; var s1st, s2nd, sEx1st, sEx2nd, sTotal: String);
  var
    sl : TStringList;
    i, iNum : Integer;
    sTmp : String;
  begin
    sl := TStringList.Create;
    try
      SplitByString(src, '%n%', sl);
      for i := 0 to sl.Count-1 do
      begin
        sTmp := RemoveStringFromA(ExtractNumber(sl[i], True, False), '+');
        iNum := StrToIntDefEx(sTmp, -1);
        Case iNum of
           0..45  : s1st :=  IntToStr(StrToIntDefEx(s1st, 0) + 1);
          46..90  : s2nd :=  IntToStr(StrToIntDefEx(s2nd, 0) + 1);
          91..105 : sEx1st :=  IntToStr(StrToIntDefEx(sEx1st, 0) + 1);
          106..120: sEx2nd :=  IntToStr(StrToIntDefEx(sEx2nd, 0) + 1);
        end;
      end;
      sTotal := IntToStr(StrToIntDefEx(s1st, 0) + StrToIntDefEx(s2nd, 0) + StrToIntDefEx(sEx1st, 0) + StrToIntDefEx(sEx2nd, 0));
    finally
      sl.Free;
    end;
  end;

  function in_RemoveUnder(src: String): String;
  begin
    Result := ReplaceTextEx(src, ['U16', 'U17', 'U18', 'U19', 'U20', 'U21', 'U22', 'U23'],
                                 ['','','','','','','','']);
    Result := Trim(Result);
  end;

var
  ini : TMemIniFile;
  sTmp, sNum, sName, sUrl : String;
  iPos : Integer;
begin
  //スタッツのURL取得
  sTmp := CopyStr(sl.Text, 'data-tab-name="details">', '</a>');
  sTmp := CopyStr(sTmp, '<a href', '">');
  sUrl := frmMain._ConvertToValidUrl(RemoveLeft(sTmp, 9));
  //日付
  sTmp := RemoveLeft(CopyStr(sl.Text, '<meta itemprop="startDate"', 'T'), 36);
  sGMD[1] := ReplaceText(sTmp, '-', '/');
  //K.O時間
  sTmp := CopyStr(sl.Text, '<meta itemprop="startDate"', '/>');
  sTmp := RemoveRight(RemoveLeft(CopyStr(sTmp, 'T', '+'), 1), 3);
  sGMD[31] := frmMain._SetTimeZone(sTmp, sTimeZone);
  //場所
  sTmp := RemoveLeft(CopyStr(sl.Text, '<meta itemprop="location"', '" />'), 35);
  sGMD[2] := sTmp;
  //Home
  sTmp := CopyStr(sl.Text, '<div class="widget-match-header__name">', '</span>');
  sGMD[3] := ReplaceTextEx(RemoveHTMLTags(sTmp),
              ['&amp;', '&#039;'],
              ['&', '''']);
  if frmMain.chkDeleteUnderAge.Checked then
    sGMD[3] := in_RemoveUnder(sGMD[3]);
  //Away
  sTmp := CopyStrNext(sl.Text, '<div class="widget-match-header__name">', '</span>');
  sGMD[4] := ReplaceTextEx(RemoveHTMLTags(sTmp),
              ['&amp;', '&#039;'],
              ['&', '''']);
  if frmMain.chkDeleteUnderAge.Checked then
    sGMD[4] := in_RemoveUnder(sGMD[4]);
  ini := TMemIniFile.Create(ExtractParentPath(GetApplicationPath) + 'TeamNames.ini', TEncoding.Unicode);
  try
    sGMD[3] := ini.ReadString('Teams', sGMD[3], sGMD[3]);
    sGMD[4] := ini.ReadString('Teams', sGMD[4], sGMD[4]);
  finally
    ini.Free;
  end;
  //得点者
  sTmp := CopyStr(sl.Text, '<div class="widget-match-header__scorers-names', '</div>');
  sGMD[13] := RemoveHTMLTags(ReplaceTextEx(sTmp,
                        ['</span> ', '(', ')', '&#039;'],
                        ['%n%', '', '', '''']));
  sTmp := CopyStrNext(sl.Text, '<div class="widget-match-header__scorers-names', '</div>');
  sGMD[14] := RemoveHTMLTags(ReplaceTextEx(sTmp,
                        ['</span> ', '(', ')', '&#039;'],
                        ['%n%', '', '', '''']));
  //得点
  in_CreateScore(sGMD[13], sGMD[6], sGMD[8], sGMD[18], sGMD[20], sGMD[10]);
  in_CreateScore(sGMD[14], sGMD[7], sGMD[9], sGMD[19], sGMD[21], sGMD[11]);
  //結果
  if sGMD[10] > sGMD[11] then
    sGMD[5] := '○'
  else if sGMD[10] = sGMD[11] then
    sGMD[5] := '△'
  else
    sGMD[5] := '●';
  //延長の有無
  if sGMD[18] = '' then
    sGMD[24] := '0'
  else
    sGMD[24] := '1';
  //大会名
  sTmp := CopyStr(sl.Text, '<h2 class="widget-headline">', '</span>');
  sGMD[12] := RemoveHTMLTags(sTmp);
  //スタメンHome
  sTmp := CopyStr(sl.Text, '<h2 class="widget-match-lineups__headline"', '<h2 class="widget-match-lineups__headline" title=');
  iPos := PosText('<li itemprop="athlete"', sTmp);
  repeat
    sNum := RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__number">', '</span>', iPos));
    sName:= RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__name"', '</span>', iPos));
    slPlayer.Add(Format('H$$%s$%s$$$0', [sNum, ReplaceText(sName, '&#039;', '''')]));
    iPos := PosTextEx('<li itemprop="athlete"', sTmp, iPos+1);
  until iPos = 0;
  //スタメンAway
  sTmp := CopyStrFromN(sl.Text, '<h2 class="widget-match-lineups__headline"', '<div class="commercial">', 2);
  iPos := PosText('<li itemprop="athlete"', sTmp);
  repeat
    sNum := RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__number">', '</span>', iPos));
    sName:= RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__name"', '</span>', iPos));
    slPlayer.Add(Format('A$$%s$%s$$$0', [sNum, ReplaceText(sName, '&#039;', '''')]));
    iPos := PosTextEx('<li itemprop="athlete"', sTmp, iPos+1);
  until iPos = 0;
  //サブHome
  slPlayer.Add('H$Header$$Substitutes$$$');
  sTmp := CopyStrFromN(sl.Text, '<h2 class="widget-match-lineups__headline"', '<li itemprop="coach"', 3);
  iPos := PosText('<li itemprop="athlete"', sTmp);
  repeat
    sNum := RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__number">', '</span>', iPos));
    sName:= RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__name"', '</span>', iPos));
    slPlayer.Add(Format('H$$%s$%s$$$0', [sNum, ReplaceText(sName, '&#039;', '''')]));
    iPos := PosTextEx('<li itemprop="athlete"', sTmp, iPos+1);
  until iPos = 0;
  //監督Home
  sTmp := CopyStr(sl.Text, '<li itemprop="coach"', '</span>');
  sTmp := RemoveHTMLTags(CopyStrToEnd(sTmp, '<span class="widget-match-lineups__name"'));
  slPlayer.Add('H$Header$$Coach/Manager$$$');
  slPlayer.Add(Format('H$$$%s$$$0', [sTmp]));
  //サブAway
  slPlayer.Add('A$Header$$Substitutes$$$');
  sTmp := CopyStrFromN(sl.Text, '<h2 class="widget-match-lineups__headline"', '<li itemprop="coach"', 5);
  iPos := PosText('<li itemprop="athlete"', sTmp);
  repeat
    sNum := RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__number">', '</span>', iPos));
    sName:= RemoveHTMLTags(CopyStrEx(sTmp, '<span class="widget-match-lineups__name"', '</span>', iPos));
    slPlayer.Add(Format('A$$%s$%s$$$0', [sNum, ReplaceText(sName, '&#039;', '''')]));
    iPos := PosTextEx('<li itemprop="athlete"', sTmp, iPos+1);
  until iPos = 0;
  //監督Away
  sTmp := CopyStrNext(sl.Text, '<li itemprop="coach"', '</span>');
  sTmp := RemoveHTMLTags(CopyStrToEnd(sTmp, '<span class="widget-match-lineups__name"'));
  slPlayer.Add('A$Header$$Coach/Manager$$$');
  slPlayer.Add(Format('A$$$%s$$$0', [sTmp]));

  //データがない部分を初期値で埋める
  sGMD[15] := '$$';
  sGMD[24] := '0';
  sGMD[25] := '50';
  sGMD[30] := ';;;;;';  //審判
  //メンバーリストを取得する
  _CreateMeberList(sUrl);
end;

function _CreateUrl(sUrl: String): String;
var
  sl : TStringList;
  s : String;
begin
  sl := TStringList.Create;
  try
    SplitByString(sUrl, '/', sl);
    if sl[3] = 'en' then
      s := 'lineups'
    else if sl[3] = 'jp' then
      s := '%E3%83%A1%E3%83%B3%E3%83%90%E3%83%BC'
    else if sl[3] = 'de' then
      s := 'aufstellungen'
    else if sl[3] = 'es' then
      s := 'alineaciones'
    else if sl[3] = 'fr' then
      s := 'compositions'
    else if sl[3] = 'it' then
      s := 'formazioni'
    else if sl[3] = 'nl' then
      s := 'opstellingen'
    else if sl[3] = 'br' then
      s := 'escalações'
    else if sl[3] = 'zh-hk' then
      s := '%E9%99%A3%E5%AE%B9'
    else if sl[3] = 'kr' then
      s := '%EB%AA%85%EB%8B%A8'
    else if sl[3] = 'ba' then
      s := 'sastavi'
    else if sl[3] = 'hr' then
      s := 'sastavi'
    else if sl[3] = 'id' then
      s := 'susunan-pemain'
    else if sl[3] = 'hu' then
      s := 'kezdőcsapatok'
    else if sl[3] = 'sw' then
      s := 'vikosi'
    else if sl[3] = 'tr' then
      s := 'kadrolar'
    else if sl[3] = 'vn' then
      s := 'doihinh';
    Result := Format('http://%s/%s/%s/%s/%s/%s', [sl[2], sl[3], sl[4], sl[5], s, sl[6]]);
  finally
    sl.Free;
  end;
end;

procedure _CreateGameData(sUrl, sTimeZone: String);
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  slPlayer := TStringList.Create;
  try
    _InitData;
    sUrl := _CreateUrl(sUrl);
    DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);
    if ContainsText(sl.Text, 'data-tab-name="lineups">') then
    begin
      _CreateGameInformations(sl, sTimeZone);
      _CreateFinalData(sUrl);
    end;
  finally
    sl.Free;
    slPlayer.Free;
  end;
end;

end.
