IDENTIFICATION DIVISION.
PROGRAM-ID. SAMPLE08.

DATA DIVISION.
*サブルーチンが呼び出し元からパラメータを受け取るための領域宣言
*ここに宣言した項目には、このサブルーチン自身のデータ領域は割り当てられず、呼び出し元のメモリが参照される
LINKAGE SECTION.
01  L-IN-A    PIC 9(4).
01  L-IN-B    PIC 9(4).
01  L-OUT     PIC 9(6).

*USINGに列挙した順序が、呼び出し側CALL ... USINGの渡し順と一致している必要がある（順序・数・意味を合わせる）
PROCEDURE DIVISION USING L-IN-A L-IN-B L-OUT.
* 簡単な加算を行い、結果を呼び出し側の変数に返す
  COMPUTE L-OUT = L-IN-A + L-IN-B
  GOBACK.
