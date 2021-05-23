// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

//アドレス計算を行う場合はAレジスタを使用しなければならない?

//最大スクリーンを求める
@8192 //32(行の末尾のピクセル番号)*256（列）= 最後のピクセルアドレスが8192 @valueはAレジスタに値（8192）を設定する。
D=A // 8192という値を設定するからA。Aはデータ値と解釈されたり、アドレスと解釈される。明示的にアドレスを参照させたい場合はMを使用する　常に固定とかも関係ある？
@SCREEN // Aレジスタに16384が格納される @SCREENは元から存在するアドレス @SCREENは16384(0x4000)を表すex.0x1000=4096
D=D+A //8192とAレジスタの16384を合計する
@MAXADDRESS //　Aレジスタに222222（適当）が格納される
M=D //Memory[222222]にDが保存される @MAXADDRESS=スクリーンの開始アドレス＋スクリーンの最後のアドレス

(LOOP) //ラベルシンボル gotoの行き先
@SCREEN // Aレジスタに16384が格納される
D=A //Aレジスタの16384を格納
@CURRENT // スクリーンアドレス初期化(適当にアドレス99999を取得) D経由でアドレスが渡されてもアドレスを変更することができる？
// 初回は@CURRENTに値が入っていないので、Aレジスタにはアドレスが格納される？
M=D // @CURRENTが指すメモリアドレス(Memory[99999])にD(16384)を設定
@KBD // Aレジスタに24576が格納される
D=M // Memory[24576]の値がDレジスタに格納される Aにしてしまうと24576が格納されてしまうのでダメ

@WHITE //WHITE用のアドレスを取得
D;JEQ //Dは@KBDの値 D=0 goto WHITEアドレスにjump
@BLACK
0;JMP // else句みたいなもの whiteでjumpしなかったらBLACKのアドレスにjump

(WHITE)
@COLOR
M=0 // COLOR用のアドレスに0を設定
@FILL 
0;JMP // 強制的にFILLにjump

(BLACK)
@COLOR
M=-1 //1の補数(11...1)を使用して16ビットすべてを1にする
@FILL
0;JMP // 強制的にFILLにjump

//キーボードから取得した色でスクリーンを埋める(スクリーンの最大最後のアドレスまで行ったらループを抜ける)
(FILL)
//現在が最後のスクリーンアドレスより大きい場合はスクリーンをすべて埋めたのでループを抜ける
@MAXADDRESS //　Aレジスタに222222（適当）が格納される
D=M // Memory[222222]の値がDレジスタに設定される
@CURRENT // Aレジスタに99999が格納される
D=D-M //(24576-Memory[99999]=16384)(初回)　24576-(Memory[99999]=16385)(二回目)CURRENTのメモリアドレス値は固定だけど、データ値（インクリメントされた現在のアドレス）が計算される
@LOOP //実際は24575が最後のアドレス。JLTにしてout<0とすると最大スクリーンを超えて色を塗ることになりバグる。@MAXADDRESS-1すればJLTでおｋ。
D;JEQ
//現在のアドレスに色を埋める
@COLOR
D=M //@COLORのアドレス（アドレスが解決されデータが入るのかも）をDレジスタに保存
@CURRENT // Aレジスタに99999が格納される
// 予めAレジスタにメモリのアドレスを設定することでその後に続くC命令においてAレジスタで指定したメモリ位置にあるデータを操作することができる
A=M // Memory[99999]の値(16385)をAレジスタに格納する。（Aレジスタに16385を格納することでMemory[16385]の操作が可能になる）
M=D //MはAレジスタの値（16385）をアドレスとするので、Memory[16385]にCOLORのデータ値を保存

D=A+1 // これがないと色が塗られない。16385+1を行う
@CURRENT // Aレジスタに99999が格納される
M=D // Memory[99999]に現在のアドレス値＋１の値を格納する
@FILL
0;JMP
(END)