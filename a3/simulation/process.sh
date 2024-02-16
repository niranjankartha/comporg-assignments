#!/bin/bash

outfile="output.csv"

echo "lg2_pagesize,columns,levels,IPC,DTLB hit,DTLB miss,ITLB hit,ITLB miss,STLB hit,STLB miss" | tee "$outfile"

# move out the failed simulations
# rg -ic "failed" | sed "s/:.*$//" | awk ' {system("mv " $1 " ./fails") }'
# rg -ic "deadlock" | sed "s/:.*$//" | awk ' {system("mv " $1 " ./fails") }'

# take a filename, grep, and add to file
append () {
    pagesize=$(echo $1 | sed -r "s/^.*_([0-9]+)pg.*$/\1/")
    cols=$(echo $1 | sed -r "s/^.*_([0-9]+)col.*$/\1/")
    lvl=$(echo $1 | sed -r "s/^.*_([0-9]+)lvl.*$/\1/")

    ipc=$(rg "CPU 0 cumulative IPC:" $1 | sed -r "s/^.*IPC:\s+([0-9.]+)\s.*$/\1/")
    dtlbh=$(rg "cpu0_DTLB TOTAL" $1 | sed -r "s/^.*HIT:\s+([0-9]+)\s.*$/\1/")
    dtlbm=$(rg "cpu0_DTLB TOTAL" $1 | sed -r "s/^.*MISS:\s+([0-9]+)$/\1/")
    itlbh=$(rg "cpu0_ITLB TOTAL" $1 | sed -r "s/^.*HIT:\s+([0-9]+)\s.*$/\1/")
    itlbm=$(rg "cpu0_ITLB TOTAL" $1 | sed -r "s/^.*MISS:\s+([0-9]+)$/\1/")
    stlbh=$(rg "cpu0_STLB TOTAL" $1 | sed -r "s/^.*HIT:\s+([0-9]+)\s.*$/\1/")
    stlbm=$(rg "cpu0_STLB TOTAL" $1 | sed -r "s/^.*MISS:\s+([0-9]+)$/\1/")
    # echo $dtlbh $dtlbm
    echo "$pagesize,$cols,$lvl,$ipc,$dtlbh,$dtlbm,$itlbh,$itlbm,$stlbh,$stlbm" | tee -a "$outfile"
}

# iterate through the files
while read -r filename
do
    append $filename
done < <(find ./out -type f)
