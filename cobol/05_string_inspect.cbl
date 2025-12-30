IDENTIFICATION DIVISION.
PROGRAM-ID. SAMPLE05.

DATA DIVISION.
WORKING-STORAGE SECTION.
*元の入力文字列。固定長20バイト、残りはスペースでパディングされる
01  WS-IN     PIC X(20) VALUE 'A,B,C'.
*分割後を格納する各フィールド
01  WS-A      PIC X(10).
01  WS-B      PIC X(10).
01  WS-C      PIC X(10).

*再結合後の結果格納領域（長さ40）
01  WS-JOINED PIC X(40).
*STRINGの書き込み位置を示すポインタ。COMPは内部形式（バイナリ）で保持される数値フィールド
01  WS-PTR    PIC 9(4) COMP VALUE 1.

*カンマとスペースの出現回数を格納するカウンタ
01 WS-COMMA-CNT PIC 9(3) VALUE 0.
01 WS-SPACE-CNT PIC 9(3) VALUE 0.

PROCEDURE DIVISION.
MAIN.
*> UNSTRING: split by delimiter
* WS-A/B/C を空白で初期化
  MOVE SPACES TO WS-A WS-B WS-C
* 文字列を区切り文字（はカンマ）で分割して、INTOの各フィールドに順に格納
  UNSTRING WS-IN DELIMITED BY ','
  INTO WS-A WS-B WS-C
  END-UNSTRING

*> INSPECT: count occurrences
* INSPECT ... TALLYING:指定文字の出現回数を数えてカウンタに入れる
* WS-COMMA-CNT:WS-IN中の','の個数（"A,B,C"にカンマが2つなので2）
* WS-SPACE-CNT:WS-IN中のスペース個数（'A,B,C'で空白はないため0）
  INSPECT WS-IN TALLYING WS-COMMA-CNT FOR ALL ','
  INSPECT WS-IN TALLYING WS-SPACE-CNT FOR ALL SPACE

 *> STRING: join fields with delimiter, using pointer
  MOVE SPACES TO WS-JOINED
  MOVE 1 TO WS-PTR
* STRING:複数のデータ要素を連結してINTO領域に格納する→WS-JOINEDの先頭に "A-B-C"が格納され、残りはスペースでパディングされる
  STRING
* WS-A の先頭から最初のスペースまで（＝実質トークン本体 'A'）を取り出す
  WS-A DELIMITED BY SPACE
* '-' 全体をそのまま挿入（SIZEは文字列の全長を示すため、ハイフン1文字が入る）
  '-' DELIMITED BY SIZE
  WS-B DELIMITED BY SPACE
  '-' DELIMITED BY SIZE
  WS-C DELIMITED BY SPACE
  INTO WS-JOINED
* WITH POINTER:書き込み開始位置をWS-PTRで指定し、格納後にWS-PTRが進む
  WITH POINTER WS-PTR
  END-STRING

 DISPLAY 'IN  =' WS-IN
 DISPLAY 'A  =' WS-A
 DISPLAY 'B  =' WS-B
 DISPLAY 'C  =' WS-C
 DISPLAY 'JOINED =' WS-JOINED
 DISPLAY 'COMMA =' WS-COMMA-CNT
 DISPLAY 'SPACE =' WS-SPACE-CNT

 GOBACK.
