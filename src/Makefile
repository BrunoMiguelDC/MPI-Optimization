#
# Simplified simulation of high-energy particle storms
#
# Parallel computing (Degree in Computer Engineering)
# 2017/2018
#
# EduHPC 2018: Peachy assignment
#
# (c) 2018 Arturo Gonzalez-Escribano, Eduardo Rodriguez-Gutiez
# Grupo Trasgo, Universidad de Valladolid (Spain)
#
# This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
# https://creativecommons.org/licenses/by-sa/4.0/
#
#
# The current Parallel Computing course includes contests using:
# OpenMP, MPI, and CUDA.
#

# Compilers
CC=gcc
MPICC=mpicc

# Flags for optimization and libs
FLAGS=-O3
LIBS=-lm

# Targets to build
OBJS=energy_storms_seq energy_storms_mpi

# Default test case to be used with check_results.sh. Values perimited: 1, 2, 3, 4, 5, 6, 7, 8, 9
TESTCASE=1

# Default test
TEST=../test_files/test_01_a35_p5_w3 ../test_files/test_01_a35_p7_w2 ../test_files/test_01_a35_p8_w1 ../test_files/test_01_a35_p8_w4

# Default layer size
LAYERSIZE=35

# Default benchmark filename
BENCHMARK_FILE="benchmark.txt"

# Default environment
ENV="local"

# Default number of repetitions to get average speedup
NUM_REPS=20


# Rules. By default show help
help:
	@echo
	@echo "Simplified simulation of high-energy particle storms"
	@echo
	@echo "Group Trasgo, Universidad de Valladolid (Spain)"
	@echo "EduHPC 2018: Peachy assignment"
	@echo "DI, FCT NOVA"
	@echo "CAD 2023/2024"
	@echo
	@echo "make energy_storms_seq	Build only the sequential version"
	@echo "make energy_storms_mpi	Build only the MPI version"
	@echo
	@echo "make all	Build all versions (Sequential, MPI)"
	@echo "make debug	Build all version with demo output for small arrays (size<=35)"
	@echo "make clean	Remove targets"
	@echo

all: $(OBJS)

energy_storms_seq: energy_storms_seq.c
	$(CC) $(FLAGS) $(DEBUG) $< $(LIBS) $(PROF) -o $@

energy_storms_mpi: energy_storms_mpi.c
	$(MPICC) $(DEBUG) $< $(LIBS) $(PROF) -o $@

# Remove the target files
clean:
	rm -rf $(OBJS)

# Compile in debug mode
debug:
	make DEBUG=-DDEBUG all

# Compile sequential version with gprof
prof_seq:
	make PROF=-pg energy_storms_seq

# Compile MPI version with gprof
prof_mpi:
	make PROF=-pg energy_storms_mpi

# Run sequential version
run_seq:
	make energy_storms_seq
	./energy_storms_seq $(LAYERSIZE) $(TEST)

# Run MPI version
run_mpi:
	@make energy_storms_mpi
	@if [ "$(ENV)" = "local" ]; \
	then \
      	mpirun energy_storms_mpi $(LAYERSIZE) $(TEST); \
    else \
    	mpirun --hostfile myhostfile --mca btl_tcp_if_include 172.30.10.0/24 energy_storms_mpi $(LAYERSIZE) $(TEST); \
    fi

# Run gprof with sequential version
run_prof_seq:
	make PROF=-pg energy_storms_seq
	./energy_storms_seq $(LAYERSIZE) $(TEST)
	gprof energy_storms_seq gmon.out

# Run gprof with MPI version
run_prof_mpi:
	make PROF=-pg energy_storms_mpi
	@if [ "$(ENV)" = "local" ]; \
    then \
    	mpirun energy_storms_mpi $(LAYERSIZE) $(TEST); \
    else \
    	mpirun --hostfile myhostfile --mca btl_tcp_if_include 172.30.10.0/24 energy_storms_mpi $(LAYERSIZE) $(TEST); \
    fi
	gprof energy_storms_mpi gmon.out

# Compile and test results for a given testcase
test:
	make energy_storms_seq
	make energy_storms_mpi
	./check_results.sh $(BENCHMARK_FILE) $(TESTCASE) $(ENV)

benchmark:
	make energy_storms_seq
	./create_benchmark.sh $(NUM_REPS)

speedup:
	make energy_storms_seq
	make energy_storms_mpi
	./compare_mpi_benchmark.sh $(BENCHMARK_FILE) $(TESTCASE) $(NUM_REPS) $(ENV)

