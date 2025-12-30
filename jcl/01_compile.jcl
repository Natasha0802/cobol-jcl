//*ジョブカード：ジョブ名CBLCAT、課金アカウントなど。NOTIFY=&SYSUID は完了通知を依頼
//CBLCAT  JOB (ACCT),'COBOL BUILD',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID

//*実行PGM IGYCRCTLを起動。コンパイラ引数はPARM='LIB'
//COBOL    EXEC PGM=IGYCRCTL,PARM='LIB'
//*コンパイル時の出力（リスト、エラー等）をプリント/スプールするDD SYSOUTへ出力（DD: ステートメント）
//SYSPRINT DD  SYSOUT=*
//SYSOUT   DD  SYSOUT=*
//*コンパイラに渡す。
//* -DISP:「DDで指定するデータセットの状態と、処理終了時の取り扱い」を指定するパラメータ。SHR：既存データセットを共有で開く（読み取りなど）
//* -DSN: データセット名、ここではPDS（ライブラリー、例：YOUR.SOURCE）を指す。YOUR.SOURCE(SAMPLE09)を参照
//SYSIN    DD  DISP=SHR,DSN=YOUR.SOURCE(SAMPLE09)
//*COPY文で参照されるcopybook（ライブラリ）。コンパイル時に参照される場所。
//SYSLIB   DD  DISP=SHR,DSN=YOUR.COPYLIB
//*コンパイラが生成する中間オブジェクト（モジュール）を置くための一時データセット。
//* -DISP=(MOD,PASS)は後続ステップへパスする目的で作成する設定。
//SYSMDECK DD  DISP=(MOD,PASS),DSN=&&OBJ,SPACE=(TRK,(5,5))
//*コンパイラ用の作業領域（ワークファイル）。サイズ/数はコンパイラの要件に依存。
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT4   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))

//*リンク編集ステップ（LKED）
//* -IEWL（Link-Editor）を起動してオブジェクトをリンク、ロードモジュール（実行可能モジュール）を生成
//* -PARMでオプション（相互参照表等）
//* -COND: 通常指定条件 (COBOLステップのリターンコードが0より小さい) が真な場合にこのステップをスキップする
//LKED EXEC PGM=IEWL, PARM='XREF,LIST', COND=(0,LT,COBOL)

//*リンクの出力と作業用領域
//SYSPRINT  DD  SYSOUT=*
//SYSUT1    DD  UNIT  =SYSDA,SPACE=(CYL,(1,1))
//*リンク編集が作成する「ロードモジュール」を格納するライブラリ（SAMPLE09）で貼られる
//SYSLMOD   DD  DISP=SHR,DSN=YOUR.LOADLIB(SAMPLE09)

//*リンカ制御文。主な行の意味：
//* -INCLUDE &&OBJ: コンパイルで作成したオブジェクト
//* -ENTRY SAMPLE09: ロードモジュールのエントリポイント（呼び出し名）を指定
//* -NAME SAMPLE09(R): ロードモジュール名とオプション。"(R)" は再入可能（REENTRANT）フラグを立てる等、ロード属性の指定
//SYSIN    DD  *
  INCLUDE &&OBJ
  ENTRY   SAMPLE09
  NAME    SAMPLE09(R)
/*

//*実行ステップ: 生成したロードモジュールSAMPLE09を実行する
//* -CONDは前のLKEDステップの結果（このステップはスキップ）
//GO  EXEC PGM=SAMPLE09,COND=(0,LT,LKED)
//*実行時に使用するロードライブラリを指定。ここを参照してSAMPLE09が見つかれば実行される
//STEPLIB  DD  DISP=SHR,DSN=YOUR.LOADLIB
//*実行時の標準出力やログ（SYSOUT/SYSPRINT）と、PGMが使用する入出力データセット（INFILE/OUTFILE）
//* -プログラム側のDD名（INFILE/OUTFILE）と一致している必要がある
//SYSOUT   DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//INFILE   DD  DISP=SHR,DSN=YOUR.INPUT
//OUTFILE  DD  DISP=SHR,DSN=YOUR.OUTPUT
