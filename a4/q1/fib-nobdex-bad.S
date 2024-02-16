    li t4, 2
    li t5, 15 # load arg here
    mv t1, x0
    li t2, 1 # answer will be present here
FIBLOOP:
    mv t3, t2
    add t2, t2, t1
    mv t1, t3
    addi t5, t5, -1
    bge t5, t4, FIBLOOP
