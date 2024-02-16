    li t2, 1 # answer will be present here
    li t5, 15 # load arg here
    mv t1, x0
    li t4, 2
FIBLOOP:
    addi t5, t5, -1
    mv t3, t2
    add t2, t2, t1
    bge t5, t4, FIBLOOP
    mv t1, t3
