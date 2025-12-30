IDENTIFICATION DIVISION.
PROGRAM-ID. SAMPLE04.

ENVIRONMENT DIVISION.
*外部ファイルとプログラム内のファイル名の対応（割当）を記述
INPUT-OUTPUT SECTION.
FILE-CONTROL.
* 論理名 INFILE を物理ファイル 'data/in.txt' に割り当て、同じく行単位として扱います。
  SELECT INFILE ASSIGN TO 'data/in.txt'
  ORGANIZATION IS LINE SEQUENTIAL.
*出力用ファイル OUTFILE を 'data/out.txt' に割り当て、同じく行単位として扱います。
  SELECT OUTFILE ASSIGN TO 'data/out.txt'
  ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
*ファイルのレコード構造を定義する場所
FILE SECTION.
*INFILEのレコード記述。1 レコードは最大 200 バイトの文字列として扱う定義
FD  INFILE.
01  IN-LINE  PIC X(200).
*OUTFILEのレコード記述。書き出すレコード領域は 220 バイト
FD  OUTFILE.
01  OUT-LINE PIC X(220).

WORKING-STORAGE SECTION.
01  WS-EOF   PIC X VALUE 'N'.

PROCEDURE DIVISION.
MAIN.
  OPEN INPUT INFILE
    OUTPUT OUTFILE
*入力ファイルの各行を読み取り、そのまま出力ファイルに書く処理を繰り返す
  PERFORM UNTIL WS-EOF = 'Y'
    READ INFILE
*     読み取りがEOFに達したときに実行（WS-EOFに'Y'をセットしてループを抜ける）
      AT END 
        MOVE 'Y' TO WS-EOF
*     正常にレコードが読めたときに実行（IN-LINEの内容をOUT-LINEにMOVEしてWRITEで書き出す）
      NOT AT END
        MOVE IN-LINE TO OUT-LINE
        WRITE OUT-LINE
    END-READ
  END-PERFORM
*ファイルをクローズしてリソースを解放
  CLOSE INFILE OUTFILE
  GOBACK.
