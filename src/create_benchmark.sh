#!/bin/bash


if [ $# -eq 0 ]
  then
    echo "Usage: ./create_benchmark.sh [NUM_REPS]"
    exit 1
fi

num_reps=$1

echo "CREATING BENCHMARK"

filename="benchmark.txt"

echo -n > $filename


test1="../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4"
num_storms1=4 
layersize1=35

test2="../test_files/test_02_a30k_p20k_w1 ../test_files/test_02_a30k_p20k_w2 ../test_files/test_02_a30k_p20k_w3 ../test_files/test_02_a30k_p20k_w4 ../test_files/test_02_a30k_p20k_w5 ../test_files/test_02_a30k_p20k_w6"
num_storms2=6
layersize2=30000

test3="../test_files/test_03_a20_p4_w1"
num_storms3=1 
layersize3=20

test4="../test_files/test_04_a20_p4_w1"
num_storms4=1  
layersize4=20

test5="../test_files/test_05_a20_p4_w1"
num_storms5=1  
layersize5=20

test6="../test_files/test_06_a20_p4_w1"
num_storms6=1  
layersize6=20

test7="../test_files/test_07_a1M_p5k_w1 ../test_files/test_07_a1M_p5k_w2 ../test_files/test_07_a1M_p5k_w3 ../test_files/test_07_a1M_p5k_w4"
num_storms7=4  
layersize7=1000000

test8="../test_files/test_08_a100M_p1_w1 ../test_files/test_08_a100M_p1_w2 ../test_files/test_08_a100M_p1_w3"
num_storms8=3  
layersize8=100000000

test9_16="../test_files/test_09_a16-17_p3_w1"
num_storms9_16=1  
layersize9_16=16

test9_17="../test_files/test_09_a16-17_p3_w1"
num_storms9_17=1  
layersize9_17=17


testcases=("$test1" "$test2" "$test3" "$test4" "$test5" "$test6" "$test7" "$test8" "$test9_16" "$test9_17")
num_storms=($num_storms1 $num_storms2 $num_storms3 $num_storms4 $num_storms5 $num_storms6 $num_storms7 $num_storms8 $num_storms9_16 $num_storms9_17)
layersizes=($layersize1 $layersize2 $layersize3 $layersize4 $layersize5 $layersize6 $layersize7 $layersize8 $layersize9_16 $layersize9_17)

LC_NUMERIC="en_US.UTF-8"

for i in ${!testcases[@]}; do
  echo $(($i + 1)) >> $filename
  echo "test = " "${testcases[$i]}"
  echo "num_storms =" ${num_storms[$i]}
  echo "layersize =" ${layersizes[$i]}

  runtime_sum=0
  runtime_avg=0
  for ((k=1; k<=$num_reps; k++)); do
    out_seq=$(./energy_storms_seq ${layersizes[$i]} ${testcases[$i]})
    runtime_seq=$(echo $out_seq | cut -d ' ' -f 2)

    runtime_sum=$(awk "BEGIN { printf(\"%f\", $runtime_sum + $runtime_seq) }")
  done

  echo $out_seq
  runtime_avg=$(awk "BEGIN { printf(\"%f\", $runtime_sum / $num_reps) }")
  echo "Average runtime" $runtime_avg
  echo $runtime_avg >> $filename

  posval_seq=()
  for (( j=0; j<${num_storms[$i]}; j++ )) do
      posval_seq[$j]=$(echo $out_seq | cut -d ' ' -f $(( 4 + (2 * $j) ))-$(( 4 + (2 * $j) + 1 )))
  done
  echo ${posval_seq[*]} >> $filename
  echo
done








