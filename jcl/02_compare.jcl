//*ジョブの開始。
//* -ジョブ名: CMPJOB、会計区分: ACCT、ジョブクラス、メッセージ出力先などを指定
//* -NOTIFY=&SYSUID はジョブ完了時にジョブのサブミットユーザへ通知する指示
//CMPJOB  JOB (ACCT),'COMPARE',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID

//*ステップ名STEP1でPGM IEBCOMPR（IBM 標準ユーティリティのデータ比較PGM）を実行する指定
//STEP1   EXEC PGM=IEBCOMPR

//*入力データ定義（比較対象）
//*- SYSUT1とSYSUT2が比較する2つのデータセットを指します。
//*- DISP=SHR：既存データセットを「共有」モードでオープン（読み取り）する指定
//*- DSN=YOUR.FILE.A / YOUR.FILE.B はプレースホルダ（代替文字列）なので実際は比較したいデータセット名に置き換える
//SYSUT1  DD  DISP=SHR,DSN=YOUR.FILE.A
//SYSUT2  DD  DISP=SHR,DSN=YOUR.FILE.B

//*出力（レポートやメッセージ）
//*- IEBCOMPRの結果（差分レポートやエラー等）をSYSOUTに出力。DSNを指定しないので標準の出力クラスへ送られる
//SYSOUT  DD  SYSOUT=*

//*制御入力（オプション指定）
//*- IEBCOMPRの追加制御を渡すSYSINをここで指定できる
//*- DUMMY:何も渡さない（デフォルト動作）
//SYSIN   DD  DUMMY

//*コメント（リターンコードRCの意図）
//*- RC = 0：2つのデータセットは同一
//*- RC = 4：差分が見つかった
//*- RC >= 8：何らかの実行時エラー（指定したデータセットが存在しない、アクセス権限エラー、フォーマット不一致等）
//* RC idea (typical):
//* 0 = identical
//* 4 = differences found
//* 8+ = error
