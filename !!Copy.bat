SET SRC=C:\!MyData\MyBetaSoftware\Seattle\FEditor\GoalCom2017\Win64\Release\
SET dstRelease=C:\!MyData\FEditor\Plugins\
SET dstDebug=C:\!MyData\MyBetaSoftware\D7\FEditor\Plugins\
SET FIlename=plugin_GoalCom2017.exe

copy "%SRC%%Filename%" "%dstDebug%%Filename%"
copy "%SRC%%Filename%" "%dstRelease%%Filename%"
