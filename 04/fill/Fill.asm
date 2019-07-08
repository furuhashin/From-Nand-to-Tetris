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
@8192 //32*256 @valueはAレジスタに値を設定する。よってAレジスタにて取り出す
D=A
@SCREEN //@SCREENは16384(0x4000)を表すex.0x1000=4096
D=D+A
@MAXADDRESS //多分24576が入っている。Mが参照するメモリのワードは、現在のAレジスタの値をアドレスとするメモリのワードの値。@MAXADDRESSのアドレスがAレジスタに入り、そこにDレジスタの値をセットしている
M=D

(LOOP)
@SCREEN //@SCREENのアドレスをAレジスタに設定
D=A
@CURRENT // スクリーンアドレス初期化 D経由でアドレスが渡されてもアドレスを変更することができる？@CURRENTのアドレスは16384？？
M=D
// キーボードから色を取得(値を取得しているからMレジスタを使用。KBDのアドレスが欲しい場合はAレジスタを使用すると24576が取得できる)
@KBD
D=M

@WHITE
D;JEQ
@BLACK
0;JMP

(WHITE)
@COLOR
M=0
@FILL
0;JMP

(BLACK)
@COLOR
M=-1 //1の補数(11...1)を使用して16ビットすべてを1にする
@FILL
0;JMP

//キーボードから取得した色でスクリーンを埋める
(FILL)
//現在が最後のスクリーンアドレスより大きい場合はスクリーンをすべて埋めたのでループを抜ける
@MAXADDRESS //アドレスではなく、値が欲しいためMレジスタを使用。Aレジスタを使用した場合,変数シンボルとして取得したアドレスが返る
D=M
@CURRENT //アドレスではなく、値が欲しいためMレジスタを使用。Aレジスタを使用した場合,変数シンボルとして取得したアドレスが返る
D=D-M //24576-16384
@LOOP //実際は24575が最後のアドレス。JLTにしてout<0とすると最大スクリーンを超えて色を塗ることになりバグる。@MAXADDRESS-1すればJLTでおｋ。
D;JEQ
//現在のアドレスに色を埋める
@COLOR
D=M //@COLORのアドレスに保持されているデータ値が欲しいためMレジスタを使用
@CURRENT
A=M //アドレスを移動するために前のアドレスを保持する。@CURRENTのアドレスは17とか。値は16384。A=16384となる
M=D //@CURRENT=アドレス16とかに黒を入れても意味なくない？？？？何か勘違いしている。。Mは現在のAレジスタの値をアドレスとするのでアドレス16384にDを設定=スクリーンに色が入る。

D=A+1 // これがないと色が塗られない。データ値16384に1を足す。
// アドレスを１つ進める
@CURRENT //Aレジスタに17とかが設定される。アドレス17に値D=16385が設定される
M=D // Mは現在のAレジスタの値をアドレスとするのでM=A+1を実行するとアドレス16385にA+1が設定される。本来、色のデータが入るアドレスに無効な値が入ってしまう。 
@FILL
0;JMP
(END)