# JCL Sheet

## 基本
- JOB / EXEC / DD
- STEPNAME、PGM=
- SYSOUT / SYSPRINT / SYSUDUMP
- DISP（SHR/NEW/CATLG/DELETE）
- SPACE、DCB（RECFM/LRECL/BLKSIZE）
- 代表的RCの考え方（0/4/8/12など）

## COBOLコンパイル（典型）
- コンパイラ: IGYCRCTL（例）
- リンク: IEWL（例）
- 実行: EXEC PGM=...

## コンペア（比較）
- IEBCOMPRで2ファイル比較
- RC=0: 一致、RC=4: 差異あり、RC>=8: 異常（例）
