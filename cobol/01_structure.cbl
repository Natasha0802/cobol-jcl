*プログラムの識別情報を置く場所
IDENTIFICATION DIVISION.
PROGRAM-ID. SAMPLE01.

*プログラムが動作する外部環境との橋渡しを定義
ENVIRONMENT DIVISION. 

*データ（変数）を定義する区分
DATA DIVISION.
*実行中に値を保持する変数を定義する領域
WORKING-STORAGE SECTION.
01  WS-MSG PIC X(30) VALUE 'HELLO COBOL'.

*実際の処理（文）を記述する区分
PROCEDURE DIVISION.
*手続きのラベル（段落名）です。ここから一連の命令が始まる
MAIN.
* WS-MSG の内容を出力
  DISPLAY WS-MSG
* 呼び出し元へ戻る
  GOBACK.
