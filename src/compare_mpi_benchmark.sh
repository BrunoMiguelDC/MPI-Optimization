#!/bin/bash


if [ $# -eq 0 ]
  then
    echo "Usage: ./compare_mpi_benchmark.sh [BENCHMARK_FILE] [TESTCASE] [NUM_REPS] [ENV]"
    exit 1
fi

if [ ! -f $1  ]
  then
    echo $1 "Does not exists"
    exit 1
fi

benchmark=$1
testnum=$2
num_reps=$3
env="local"
if [ ! -z "$4" ]
then
  env=$4
fi

LC_NUMERIC="en_US.UTF-8"

echo "Using test case:" $testnum
case $testnum in

  1)
    test="../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4"
    layer_size=35
    num_storms=4 
    ;;

  2)
    test="../test_files/test_02_a30k_p20k_w1 ../test_files/test_02_a30k_p20k_w2 ../test_files/test_02_a30k_p20k_w3 ../test_files/test_02_a30k_p20k_w4 ../test_files/test_02_a30k_p20k_w5 ../test_files/test_02_a30k_p20k_w6"
    layer_size=30000
    num_storms=6 
    ;;

  3)
    test="../test_files/test_03_a20_p4_w1"
    layer_size=20
    num_storms=1 
    ;;

  4)
    test="../test_files/test_04_a20_p4_w1"
    layer_size=20
    num_storms=1  
    ;;

  5)
    test="../test_files/test_05_a20_p4_w1"
    layer_size=20
    num_storms=1  
    ;;
  
  6)
    test="../test_files/test_06_a20_p4_w1"
    layer_size=20
    num_storms=1  
    ;;

  7)
    test="../test_files/test_07_a1M_p5k_w1 ../test_files/test_07_a1M_p5k_w2 ../test_files/test_07_a1M_p5k_w3 ../test_files/test_07_a1M_p5k_w4"
    layer_size=1000000
    num_storms=4  
    ;;

  8)
    test="../test_files/test_08_a100M_p1_w1 ../test_files/test_08_a100M_p1_w2 ../test_files/test_08_a100M_p1_w3"
    layer_size=100000000
    num_storms=3  
    ;;

  9)
    test="../test_files/test_09_a16-17_p3_w1"
    layer_size=16
    num_storms=1  
    ;;

  10)
    test="../test_files/test_09_a16-17_p3_w1"
    layer_size=17
    num_storms=1  
    ;;
esac
echo "Layer size:" $layer_size

echo 

echo "Running MPI"

runtime_sum=0
runtime_avg=0
for ((k=1; k<=$num_reps; k++)); do
  if [ $env = "local" ]; then
    out_mpi=$(mpirun energy_storms_mpi $layer_size $test)
  else
    out_mpi=$(mpirun --hostfile myhostfile --mca btl_tcp_if_include 172.30.10.0/24 energy_storms_mpi $layer_size $test)
  fi

  runtime_mpi=$(echo $out_mpi | cut -d ' ' -f 2)

  runtime_sum=$(awk "BEGIN { printf(\"%f\", $runtime_sum + $runtime_mpi) }")
done

for (( i=0; i<$num_storms; i++ ))
do
    posval_mpi[$i]=$(echo $out_mpi | cut -d ' ' -f $(( 4 + (2 * $i) ))-$(( 4 + (2 * $i) + 1 )))
done
echo "Result:" ${posval_mpi[*]}

runtime_avg=$(awk "BEGIN { printf(\"%f\", $runtime_sum / $num_reps) }")
echo "Average runtime" $runtime_avg



echo
echo "Comparing results"
echo

runtime_posval_seq=$(awk -v t=$testnum '$0 == t {i=1;next};i && i++ <= 2' $benchmark)
runtime_seq=$(echo $runtime_posval_seq | cut -d ' ' -f 1)
posval_seq=$(echo $runtime_posval_seq | cut -d ' ' -f 2-)

echo "Sequential version"
echo "Average runtime" $runtime_seq
echo "Result:" $posval_seq
echo

if [[ "${posval_mpi[*]}" == "$posval_seq" ]]; then
    echo "Results are equal."
else
    echo "Results are not equal."
fi


speedup=$(awk "BEGIN { printf(\"%f\", $runtime_seq / $runtime_avg) }")
echo "SPEEDUP" $speedup
