#!/bin/bash

echo "=========================== Tema 3 PCLP2 =========================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR" || { echo -e "Can't find root folder!"; exit 1; }

# add task1 & task2 when the checkers are implemented
TASKS=("task3" "task4")

for TASK in "${TASKS[@]}"; do
    if [ -d "src/$TASK" ]; then
        # clean then make
        make clean -C "src/$TASK" #> /dev/null 2>&1
        make -C "src/$TASK" #> /dev/null 2>&1
        
        if [ $? -ne 0 ]; then
            echo "Compilation failed for $TASK!"
            exit 1
        fi
    else
        echo "Directory src/$TASK not found!"
        exit 1
    fi
done

TOTAL_SCORE=0

echo "----------------------------- TASK 3 ------------------------------"
TASK3_SCORE=0
NUM_TESTS=5
POINTS_PER_TEST=5

# move to task 3 dir
cd src/task3
# make output dir
mkdir -p output

# make sure you keep the exec name "checker"
if [ ! -f "./checker" ]; then
    echo -e "Executable not found\n"
else
    for (( i=1; i<=NUM_TESTS; i++ ))
    do
        # timeout in case of infinite loop
        timeout 2s ./checker $i > /dev/null 2>&1
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            printf "Test %d---------------------------------------------------PASSED: %dp\n" $i $POINTS_PER_TEST
            TASK3_SCORE=$((TASK3_SCORE + POINTS_PER_TEST))
        elif [ $EXIT_CODE -eq 124 ]; then
            printf "Test %d--------------------------------------FAILED (Time Limit): 0p\n" $i
        elif [ $EXIT_CODE -eq 139 ]; then
            printf "Test %d--------------------------------------FAILED (Seg  Fault): 0p\n" $i
        else
            printf "Test %d--------------------------------------FAILED (Wrong  Ans): 0p\n" $i
        fi
    done
fi

TOTAL_SCORE=$((TOTAL_SCORE + TASK3_SCORE))
printf -- "---------------------- TASK 3 SCORE: %d/25 ----------------------\n\n" $TASK3_SCORE

# clean
make clean > /dev/null 2>&1

# return to root dir
cd ../../

echo "---------------------------- TASK 4 -----------------------------"
TASK4_SCORE=0
NUM_TESTS=5
POINTS_PER_TEST=4

cd src/task4
mkdir -p output

if [ ! -f "./checker" ]; then
    echo -e "Executable not found\n"
else
    for (( i=1; i<=NUM_TESTS; i++ ))
    do
        timeout 2s ./checker $i > /dev/null 2>&1
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            printf "Test %d---------------------------------------------------PASSED: %dp\n" $i $POINTS_PER_TEST
            TASK4_SCORE=$((TASK4_SCORE + POINTS_PER_TEST))
        elif [ $EXIT_CODE -eq 124 ]; then
            printf "Test %d--------------------------------------FAILED (Time Limit): 0p\n" $i
        elif [ $EXIT_CODE -eq 139 ]; then
            printf "Test %d--------------------------------------FAILED (Seg  Fault): 0p\n" $i
        else
            printf "Test %d--------------------------------------FAILED (Wrong  Ans): 0p\n" $i
        fi
    done
fi
TOTAL_SCORE=$((TOTAL_SCORE + TASK4_SCORE))
printf -- "---------------------- TASK 4 SCORE: %d/20 ----------------------\n\n" $TASK4_SCORE

make clean > /dev/null 2>&1
cd ../../

echo "=========================== Linter ================================"

LINTER_SCORE=10
LINTER_FAILED=0

ASM_FILES=$(find "$ROOT_DIR/src" -name "*.asm")

if [ -z "$ASM_FILES" ]; then
    echo "where are the .asm files bro"
    LINTER_FAILED=1
else
    for FILE in $ASM_FILES; do
        # run the linter
        LINTER_OUT=$(PYTHONPATH="$ROOT_DIR" python3 "$ROOT_DIR/checker/linter/linter-script-file" "$FILE" 2>&1)

        # check if anything was printed
        if [ -n "$LINTER_OUT" ]; then
            echo "Linter warnings in $FILE:"
            echo "$LINTER_OUT"
            LINTER_FAILED=1
        fi
    done
fi

if [ $LINTER_FAILED -eq 0 ]; then
    printf -- "LINTER---------------------------------------------------PASSED: 10p\n"
else
    printf -- "LINTER---------------------------------------------------FAILED: 0p\n"
    LINTER_SCORE=0
fi
echo ""

TOTAL_SCORE=$((TOTAL_SCORE + LINTER_SCORE))

printf "Total:%d/100\n" $TOTAL_SCORE
