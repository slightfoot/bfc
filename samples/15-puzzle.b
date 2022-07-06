[
A working 15-puzzle.
Press two keys and it will shuffle.
Controlled using WASD.
Pressing V will break the game.
By Bjarne.
8th version.
d/m/y
9/11/20
]

++++++++[>++++>++++++>++++++++>++++++++++>++++++++++++<<<<<-]>
>>>.>++++++++++++++++++.-------------.++++++++++++++..<<<<.>++.<.>>>>-.<
+++++++++++++++++.>----.<+++.>+.--.<<<<.>>>>--.<+.>++++++++++++++.------
.<<------.<<.
[>]<[[-]<]          ;; writes "Press 2 random keys: "
>>>>>>,.>,.         ;; the random keys K_1 and K_2
<<<<< <<
+++++ +++++..[-]    ;; newline

++++++++[>++++>++++++>++++++++>++++++++++>++++++++++++<<<<<-]>
>>+++.>>+.+++++++++++.---------.++++++++++++++++++.---------.-----------
.+++++++++++++++++++.-----------.+++++.-------.<<<<.>>>>++++++++++++.---
-------------.+++++++++++++++.<+++++++++++++++++.>-----.<+.>-.<+++.<<--.
..
>>>[[-]<]-
>>>>> >>>>>         ;; writes "Calculating scramble..."

+++++ +[<+++++ +++++>-]<      ;; number of shuffling moves
[
<<[>>>+>+<<<<-]>>>>[<<<<+>>>>-]
<<<<<[>>>>+>+<<<<<-]>>>>>[<<<<<+>>>>>-]
>+++++ +[<+++++ +>-]<+
<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]
>>[<<<<+>>>>-]
>[-]<<[-]
<<<<<<++++
>[-<-[<+<<]<[+[->+<]<+<<]>>>>>]
<<[<<<+>>>-]>[-]<<[-]
>>>>>>[>+<-]>-
]
<<[-]<[-]
[
        ;; generating a string of moves R_x with the formula
           N_1 = (K_1 + K_2)%37         R_1 = (N_1)%4
           N_2 = (K_2 + N_1)%37         R_2 = (N_2)%4
           N_3 = (N_1 + N_2)%37         R_3 = (N_3)%4
           N_x = (N_x-2 + N_x-1)%37     R_x = (N_x)%4
]
<
->
>>-->-->-->-->-->-->
>+>+++>++++>--
>+++++>++>+++++ +>+++++ ++>--
>+++++ ++++>+++++ +++++>+++++ +++++ +>+++++ +++>--
>+++++ +++++ +++>+++++ +++++ ++++>+++++ +++++ +++++>+++++ +++++ ++>-->-->-->-->-->-->
+++++ +++++
[>+++++ +++++ +++> +++++ +++++ +++> +++++ +++++ +++++ ++++> +++++ +++++ +++++> +++++ +++++ +++++ +++++ +++>+>+++<<<<<<<-]
>-->>-->-->---->>++>-<
+[-<+]-
        ;; setting the board in memory
<<<<<
+[
-[-[-[->]>]>]>+ +[->+]-
<[++[-->++]-- [>]> ++[--[<+>-] ++[-->++]]--[<] +[-<+]-<-]
<[++[-->++]-- [>]< ++[--[>+<-] ++[--<++]]--[>] +[-<+]-<<-]
<[++[-->++]-- [>]<<<<< ++[--[>>>>>+<<<<<-] ++[--<++]]--[>] +[-<+]-<<<-]
<[++[-->++]-- [>]>>>>> ++[--[<<<<<+>>>>>-] ++[-->++]]--[<] +[-<+]-<<<<-]
>>>>+<-
<<<<<
+]-
        ;; executing the shuffling moves

++[-->++]--
<<<<<<<-
[
>>>>> >>++>++>++>++>++<<->
+++++ +++++ +++++ +++++ +
[
>>
+++[-<+>[--<++>[-<+>[-<+>[-<+>[-<+>[-<+>[-<+>[-<+>[-<+>[-<+>[[-<+>]<[<]]]]]]]]]]<[<]] <[<]] <[<]]+
+[->+]-
<[>>+[->+]- >++++<<<.<.<.<.>>>>> >[<<<<.<.<<<.>>>>.<.<<<.>>>>.<.<.>>>>> >-]<<<.<.<.<<. +[-<+]-<-]
<[>>>+[->+]- <..<<.<.<<. +[-<+]-<<-]
<[>>>>>[<<<<+>+>>>-]<<<[>>>+<<<-] +++++[<+++++ ++++>-] >>+[->+]-<.+[-<+]- <<.[-]>>> +[->+]-<<<.<.<<.+[-<+]- <<<-]
<[> >>>>>[<<<<+>+>>>-]<<<[>>>+<<<-] +++++[<+++++ ++>-] <<+++++ +[<+++++ +++>-]<.[-]>>.[-]>>> +[->+]-<<<.<.<<. +[-<+]- <<<<]
>>>>> >[<<<<< <+>>>>> >-]<[>+<-]<+>->-
]
<+<<<<<+[-[>>>>> >>+<< <<<<<-]>>>>> >>---<<<<< <<<+]-
>>>>>>>-->+>+>+>+ +[-<+]-
       ;; printing the board

>,>+++++ +++++ ++[<----- --->-]<-[---[----- ----- -----[---->]>]>]>++[-<+]->[+]
>[>>>>>[>]> ++[--[<+>-] ++[-->++]]>[<--[<]] +[-<+]->>-]
>[>>>>[>]< ++[--[>+<-] ++[--<++]]<[>--[>]] +[-<+]->>>-]
>[>>>[>]<<<<< ++[--[>>>>>+<<<<<-] ++[--<++]]<[>--[>]] +[-<+]->>>>-]
>[>>[>]>>>>> ++[--[<<<<<+>>>>>-] ++[-->++]]>[<--[<]] +[-<+]->>>>>-]
+[->+]- <<... +[-<+]-
       ;; taking WASD inputs
]