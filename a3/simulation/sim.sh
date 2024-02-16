#!/bin/bash
cd ~/git/ChampSim || exit
trace_loc="$HOME/acad/comporg ee2003/assign3/bzip2_259B.trace.xz"
out_dir="$HOME/acad/comporg ee2003/assign3/out"

# 2^((x - 3) * n) * p = 2^((X - 3) * N) * p
# x * n + lg p  = X * N + lg P
# x = ((X - 3) * N + lg (P) - lg(p))) / n + 3

run_champsim () {
	bin/champsim --warmup-instructions 20000000 --simulation-instructions 100000000 "$trace_loc" |& tee "$out_dir/sim_$1pg_$2col_$3lvl.txt"
	echo "2^$1 page size, $2 columns, $3 levels -- done with sim"
}

# args are lg2(page_size), col, num_levels
sim () {
	echo "2^$1 page size, $2 columns, $3 levels"
	pg_size=$(echo "$1" | awk ' { printf "%d", 2^$1 } ')
	sed -i "4s/[0-9][0-9]*/$pg_size/" champsim_config.json # page_size
	sed -i "167s/[0-9][0-9]*/$2/" champsim_config.json # cols
	sed -i "179s/[0-9][0-9]*/$3/" champsim_config.json # num_levels

	pte_pg_size=$(echo $1 $3 | awk 'function ceil(x, y){ y=int(x); return(x>y?y+1:y) } { printf "%.0f\n", 2^(ceil((48 - $1)/$2) + 3) }')
	echo "multilevel page table size = $pte_pg_size"

	sed -i "178s/[0-9][0-9]*/$pte_pg_size/" champsim_config.json # adjust pte_page_size to keep vmem constant
	./config.sh champsim_config.json
	make -j9 > /dev/null
	echo "2^$1 page size, $2 columns, $3 levels -- done building"
	run_champsim $1 $2 $3 &
	sleep 1
}

lg2_pg_sizes=(6 10 14)
cols=(8 32 128 512)
levels=(3 4)

for l in "${levels[@]}"
do
	for c in "${cols[@]}"
	do
		for p in "${lg2_pg_sizes[@]}"
		do
			sim $p $c $l
		done
	done
done

echo "and now we wait"
