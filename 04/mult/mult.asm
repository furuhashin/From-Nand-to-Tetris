// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
// 初期化 loop変数にR1（RAM[1]の値を設定）@sum変数に0を設定
// loop = R1みたいなことはできないので、Dレジスタに値を移してから再度loop用のアドレスのメモリに設定する
@R1 //@valueは数値もしくは数値を表すシンボル。Aレジスタに1が設定される
D=M // Memory[1]=RAM[1]の値がDに格納される
@loop // Aレジスタにアドレス（99999）を設定
M=D // RAM[99999]にDを設定
@sum // Aレジスタに適当なsumというアドレス(000000)を設定
M=0 // RAM[000000]に0を設定

// 3*5は3+3+・・・を５回やるということ
(LOOP)
    //check
    @loop // Aレジスタにアドレス（99999）を設定
    D=M // DレジスタにRAM[99999]の値を設定 適当に5とする
    @END
    D;JLE //If D<_ 0 jump
    //calc
    @R0 // Aレジスタにアドレス（0）を設定　適当に3とする
    D=M // RAM[0]の値をDに設定
    @sum // Aレジスタに000000を設定
    M=M+D //現在のsumの値(RAM[000000])とR0(RAM[0])の値を足してRAM[000000]に設定
    //decrement
    @loop // Aレジスタにアドレス（99999）を設定
    M=M-1 //RAM[99999]の値を-1してRAM[99999]に設定
    @LOOP 
    0;JMP // LOOPへ移動
(END)
@sum // Aレジスタに000000を設定
D=M // sumの値(RAM[000000])をDレジスタに保存
@R2 // Aレジスタに2を設定
M=D // 結果を格納するRAM[2]にsumを設定
@END
0;JMP