# 61C Spring 2022 Project 2: CS61Classify

Spec: [https://cs61c.org/sp22/projects/proj2/](https://cs61c.org/sp22/projects/proj2/)

TODO: describe what you did
Bug fixed log:
1. callers can assume that the callee will not modify saved registers
2. Save all the a registers before make a function call
3. You cannot assume t registers are not modified between function calls
4. s0 is modified? typo in prologue
5. m1 stands for mum of clms
6. using ebreak to circumscribe the scope
