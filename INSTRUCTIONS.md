# First step
To `build`, `run`, `test`, and `benchmark` the code first navigate to the `src` folder of this repository.

# Build

## Build
```console
make energy_storms_<version>
```
Builds the program according to the version given. `version`: `seq` or `mpi`.

Example: Build MPI version
```console
make energy_storms_mpi
```

## Run
```console
make run_<version> LAYERSIZE=layersize> TEST="<storm_1_file> [ <storm_i_file> ] ..."
```
Builds and runs the program according to the version given. `version`: `seq` or `mpi`.

Optional Parameters:
- `layersize`: defines the size of the layer. Default values is: `35`
- `<storm_1_file> [ <storm_i_file> ] ...`: defines the test storms to feed to the program. Default is: `../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4`

Example: Build and run MPI version
```console
make run_mpi LAYERSIZE=77 TEST="test_files/test_02_a30k_p20k_w1 ../test_files/test_01_a35_p7_w2 ../test_files/test_09_a16-17_p3_w1"
```

## Test
```console
make test BENCHMARK_FILE=<benchmark_file> TESTCASE=<testcase> ENV=<env>
```
Builds, runs and checks the correctness of the MPI version.

Optional Parameters:
- `benchmark_file`: name of the text file that will contain the benchmark of the sequential version.
- `testcase`: defines the test case to use to feed to the program. Default is: `1`.
- `env`: defines environment where the MPI version will run. Possible values are: `local` or `cluster`. Default is: `local`.

Testcases:
- 1: `../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4`. Layer size: `35`.
- 2: `../test_files/test_02_a30k_p20k_w1 ../test_files/test_02_a30k_p20k_w2 ../test_files/test_02_a30k_p20k_w3 ../test_files/test_02_a30k_p20k_w4 ../test_files/test_02_a30k_p20k_w5 ../test_files/test_02_a30k_p20k_w6`. Layer size: `30000`. 
- 3: `../test_files/test_03_a20_p4_w1`. Layer size: `20`.
- 4: `../test_files/test_04_a20_p4_w1`. Layer size: `20`.
- 5: `../test_files/test_05_a20_p4_w1`. Layer size: `20`.
- 6: `../test_files/test_06_a20_p4_w1`. Layer size: `20`.
- 7: `../test_files/test_07_a1M_p5k_w1 ../test_files/test_07_a1M_p5k_w2 ../test_files/test_07_a1M_p5k_w3 ../test_files/test_07_a1M_p5k_w4`. Layer size: `1000000`.
- 8: `../test_files/test_08_a100M_p1_w1 ../test_files/test_08_a100M_p1_w2 ../test_files/test_08_a100M_p1_w3`. Layer size: `100000000`.
- 9: `../test_files/test_09_a16-17_p3_w1`. Layer size: `16`.
- 10: `../test_files/test_09_a16-17_p3_w1`. Layer size: `17`.

Example: Check correctness for testcase `7` in the DI-Cluster
```console
make test BENCHMARK_FILE=benchmark.txt TESTCASE=7 ENV=cluster
```

Example: Check correctness for testcase `7` in local machine
```console
make test BENCHMARK_FILE=benchmark.txt TESTCASE=7
```

## Benchmark
### Create sequential benchmark
```console
make benchmark NUM_REPS=<num_reps>
```
Creates a text file, `benchmark.txt`, with the benchmark of the sequential version for each of the 10 test cases.

Optional Parameters:
- `num_reps`: defines the number of repetitions that each test should run to get an average runtime.

Example: Creates a benchmark where the average runtime of each test case is for `10` runs.
```console
make benchmark NUM_REPS=10
```

### Compare against sequential benchmark
```console
make speedup BENCHMARK_FILE=<benchmark_file> TESTCASE=<testcase> NUM_REPS=<num_reps> ENV=<env>
```
Builds, runs and compares the performance of the sequential version with the MPI version.

Optional Parameters:
- `benchmark_file`: name of the text file that will contain the benchmark of the sequential version.
- `testcase`: defines the test case to use to feed to the program. Default is: `1`.
- `num_reps`: defines the number of repetitions that each test should run to get an average runtime. Should be equal to number given when creating the sequential benchmark.
- `env`: defines environment where the MPI version will run. Possible values are: `local` or `cluster`. Default is: `local`.

Testcases:
- 1: `../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4`. Layer size: `35`.
- 2: `../test_files/test_02_a30k_p20k_w1 ../test_files/test_02_a30k_p20k_w2 ../test_files/test_02_a30k_p20k_w3 ../test_files/test_02_a30k_p20k_w4 ../test_files/test_02_a30k_p20k_w5 ../test_files/test_02_a30k_p20k_w6`. Layer size: `30000`.
- 3: `../test_files/test_03_a20_p4_w1`. Layer size: `20`.
- 4: `../test_files/test_04_a20_p4_w1`. Layer size: `20`.
- 5: `../test_files/test_05_a20_p4_w1`. Layer size: `20`.
- 6: `../test_files/test_06_a20_p4_w1`. Layer size: `20`.
- 7: `../test_files/test_07_a1M_p5k_w1 ../test_files/test_07_a1M_p5k_w2 ../test_files/test_07_a1M_p5k_w3 ../test_files/test_07_a1M_p5k_w4`. Layer size: `1000000`.
- 8: `../test_files/test_08_a100M_p1_w1 ../test_files/test_08_a100M_p1_w2 ../test_files/test_08_a100M_p1_w3`. Layer size: `100000000`.
- 9: `../test_files/test_09_a16-17_p3_w1`. Layer size: `16`.
- 10: `../test_files/test_09_a16-17_p3_w1`. Layer size: `17`.

Example: Compare performance of the MPI version against the sequential version in the DI-Cluster for test case `7` using an average runtime for `10` runs.
```console
make speedup BENCHMARK_FILE=benchmark.txt TESTCASE=7 NUM_REPS=10 ENV=cluster
```

Example: Compare performance of the MPI version against the sequential version in the local machine for test case `2` using an average runtime for `20` runs.
```console
make speedup BENCHMARK_FILE=benchmark.txt TESTCASE=2 NUM_REPS=20
```

