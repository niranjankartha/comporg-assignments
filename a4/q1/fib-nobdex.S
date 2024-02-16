    mv t1, x0
    li t2, 1 # answer will be present here
    li t5, 15 # load arg here
    li t4, 2
FIBLOOP:
    add t3, t2, t1
    addi t5, t5, -1
    mv t1, t2
    mv t2, t3
    bge t5, t4, FIBLOOP
