#include <stdio.h>
#include <stdlib.h>

#define NUM_TESTS 5
#define TASK_VALUE 20.0
#define MAX_DRIVERS 10000

int count_errors(char *errors, int num_drivers);
void fix_lap_times(unsigned int *in_times, char *errors, 
                   int num_drivers, unsigned int *out_times, 
                   int *error_count);

void load_test(int test_no, int *num_drivers, unsigned int **in_times, 
               char **errors, unsigned int **out_times_ref, int *error_count_ref) {
    FILE* input_file;
    char file_name[30];

    sprintf(file_name, "./input/monaco%d.in", test_no);

    input_file = fopen(file_name, "r");
    if (input_file == NULL) {
        perror("Error opening input file");
        return;
    }

    fscanf(input_file, "%d", num_drivers);
    
    *in_times = (unsigned int *)malloc(*num_drivers * sizeof(unsigned int));
    *errors = (char *)malloc(*num_drivers * sizeof(char));
    
    for (int i = 0; i < *num_drivers; i++) {
        fscanf(input_file, "%u %hhd", &(*in_times)[i], &(*errors)[i]);
    }

    fclose(input_file);
    
    // Load reference file
    char ref_filename[30];
    sprintf(ref_filename, "./ref/monaco%d.ref", test_no);
    FILE* ref_file = fopen(ref_filename, "r");
    if (ref_file == NULL) {
        perror("Error opening ref file");
        return;
    }
    
    fscanf(ref_file, "%d", error_count_ref);
    
    *out_times_ref = (unsigned int *)malloc(*num_drivers * sizeof(unsigned int));
    for (int i = 0; i < *num_drivers; i++) {
        fscanf(ref_file, "%u", &(*out_times_ref)[i]);
    }
    
    fclose(ref_file);
}

double check_result(int test_no, int error_count, unsigned int *out_times, 
                    int num_drivers, int error_count_ref, unsigned int *out_times_ref) {
    double points = 0.0;
    int passed = 1;
    
    // Check error count
    if (error_count != error_count_ref) {
        printf("  Error count mismatch: got %d, expected %d\n", error_count, error_count_ref);
        passed = 0;
    }
    
    // Check output array
    for (int i = 0; i < num_drivers && passed; i++) {
        if (out_times[i] != out_times_ref[i]) {
            printf("  Mismatch at index %d: got %u, expected %u\n", 
                   i, out_times[i], out_times_ref[i]);
            passed = 0;
        }
    }
    
    if (passed) {
        points = (double)TASK_VALUE / (double)NUM_TESTS;
        printf("Test %d.................PASSED: %.2fp\n", test_no, points);
    } else {
        printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
    }
    
    return points;
}

void write_out(int test_no, int error_count, unsigned int *out_times, int num_drivers) {
    char out_filename[30];
    FILE* out_file;

    sprintf(out_filename, "./output/monaco%d.out", test_no);
    out_file = fopen(out_filename, "w");
    if (out_file == NULL) {
        perror("Error opening output file");
        return;
    }

    fprintf(out_file, "%d\n", error_count);
    for (int i = 0; i < num_drivers; i++) {
        fprintf(out_file, "%u\n", out_times[i]);
    }

    fclose(out_file);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <test_no>\n", argv[0]);
        return 1;
    }

    int test_no = atoi(argv[1]);
    
    if (test_no < 1 || test_no > NUM_TESTS) {
        fprintf(stderr, "Test number must be between 1 and %d\n", NUM_TESTS);
        return 1;
    }

    unsigned int *in_times = NULL;
    char *errors = NULL;
    unsigned int *out_times_ref = NULL;
    int error_count_ref = 0;
    int num_drivers = 0;
    
    // Load test data
    load_test(test_no, &num_drivers, &in_times, &errors, &out_times_ref, &error_count_ref);
    
    // Allocate output array
    unsigned int *out_times = (unsigned int *)malloc(num_drivers * sizeof(unsigned int));
    int error_count = 0;
    
    // Call Subtask 1 - Count errors
    error_count = count_errors(errors, num_drivers);
    
    // Call Subtask 2 - Fix lap times
    fix_lap_times(in_times, errors, num_drivers, out_times, &error_count);
    
    // Write output
    write_out(test_no, error_count, out_times, num_drivers);
    
    // Check result
    double passed = check_result(test_no, error_count, out_times, num_drivers, 
                                  error_count_ref, out_times_ref);
    
    // Free memory
    free(in_times);
    free(errors);
    free(out_times);
    free(out_times_ref);
    
    if (passed > 0) {
        return 0;
    } else {
        return 1;
    }
}