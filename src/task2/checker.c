#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_TESTS 5
#define TASK1_VALUE 10.0
#define TASK2_VALUE 10.0
#define MAX_DRIVERS 1024

// Driver structure
typedef struct __attribute__((packed)) {
    unsigned int access_level;      // offset 0
    unsigned short nationality;     // offset 4
    unsigned char is_phantom;       // offset 6
    unsigned char flags;            // offset 7
} driver_t;

// Assembly functions from subtask1.asm
extern driver_t* filter_drivers(driver_t *input_array, int num_drivers);
// Returns: RAX = output_buffer, RBX = filtered_count, RCX = stealth_flag
// Note: Since C cannot directly access RBX and RCX, we need a wrapper

// Assembly functions from subtask2.asm
extern int sort_and_search(driver_t *array, int length, int threshold_x);
// Returns: RAX = found_index, RBX = steps_taken, RCX = reversed_flag
// Note: Since C cannot directly access RBX and RCX, we need a wrapper

// Wrapper structures to capture all return values
typedef struct {
    driver_t *output_array;
    int filtered_count;
    int stealth_activated;
} filter_result_t;

typedef struct {
    int found_index;
    int steps_taken;
    int reversed;
} search_result_t;

// Assembly wrappers to capture multiple return values
filter_result_t filter_drivers_wrapper(driver_t *input_array, int num_drivers) {
    filter_result_t result;
    
    __asm__ volatile (
        "call filter_drivers\n\t"
        : "=a"(result.output_array), "=b"(result.filtered_count), "=c"(result.stealth_activated)
        : "D"(input_array), "S"(num_drivers)
        : "rdx", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15", "memory"
    );
    
    return result;
}

search_result_t sort_and_search_wrapper(driver_t *array, int length, int threshold_x) {
    search_result_t result;
    
    __asm__ volatile (
        "call sort_and_search\n\t"
        : "=a"(result.found_index), "=b"(result.steps_taken), "=c"(result.reversed)
        : "D"(array), "S"(length), "d"(threshold_x)
        : "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15", "memory"
    );
    
    return result;
}

void load_test(int test_no, int *num_drivers, driver_t **input_array, int *threshold_x,
               int *filtered_count_ref, driver_t **filtered_array_ref, int *stealth_ref,
               int *found_index_ref, int *steps_ref, int *reversed_ref) {
    FILE* input_file;
    char file_name[50];

    sprintf(file_name, "./input/frankfurt%d.in", test_no);

    input_file = fopen(file_name, "r");
    if (input_file == NULL) {
        perror("Error opening input file");
        return;
    }

    fscanf(input_file, "%d", num_drivers);
    
    *input_array = (driver_t *)malloc(*num_drivers * sizeof(driver_t));
    
    for (int i = 0; i < *num_drivers; i++) {
        unsigned int access;
        unsigned short nat;
        unsigned char phantom, flags;
        fscanf(input_file, "%u 0x%hx %hhu %hhu", &access, &nat, &phantom, &flags);
        (*input_array)[i].access_level = access;
        (*input_array)[i].nationality = nat;
        (*input_array)[i].is_phantom = phantom;
        (*input_array)[i].flags = flags;
    }
    
    fscanf(input_file, "%d", threshold_x);
    fclose(input_file);
    
    // Load reference file
    char ref_filename[50];
    sprintf(ref_filename, "./ref/frankfurt%d.ref", test_no);
    FILE* ref_file = fopen(ref_filename, "r");
    if (ref_file == NULL) {
        perror("Error opening ref file");
        return;
    }
    
    fscanf(ref_file, "%d", filtered_count_ref);
    fscanf(ref_file, "%d", stealth_ref);
    
    *filtered_array_ref = (driver_t *)malloc(*filtered_count_ref * sizeof(driver_t));
    for (int i = 0; i < *filtered_count_ref; i++) {
        unsigned long long raw;
        fscanf(ref_file, "%llx", &raw);
        memcpy(&(*filtered_array_ref)[i], &raw, sizeof(driver_t));
    }
    
    fscanf(ref_file, "%d", found_index_ref);
    fscanf(ref_file, "%d", steps_ref);
    fscanf(ref_file, "%d", reversed_ref);
    
    fclose(ref_file);
}

double check_subtask1(int test_no, driver_t *filtered_array, int filtered_count, 
                      int stealth_activated, driver_t *filtered_array_ref, 
                      int filtered_count_ref, int stealth_ref) {
    int passed = 1;
    
    if (filtered_count != filtered_count_ref) {
        printf("  Subtask 1: Filtered count mismatch - got %d, expected %d\n", 
               filtered_count, filtered_count_ref);
        passed = 0;
    }
    
    if (stealth_activated != stealth_ref) {
        printf("  Subtask 1: Stealth flag mismatch - got %d, expected %d\n", 
               stealth_activated, stealth_ref);
        passed = 0;
    }
    
    if (passed) {
        for (int i = 0; i < filtered_count; i++) {
            if (memcmp(&filtered_array[i], &filtered_array_ref[i], sizeof(driver_t)) != 0) {
                printf("  Subtask 1: Mismatch at index %d\n", i);
                passed = 0;
                break;
            }
        }
    }
    
    double points = 0.0;
    if (passed) {
        points = TASK1_VALUE / NUM_TESTS;
        printf("  Subtask 1: PASSED (%.2fp)\n", points);
    } else {
        printf("  Subtask 1: FAILED (0.00p)\n");
    }
    
    return points;
}

double check_subtask2(int test_no, int found_index, int steps_taken, int reversed,
                      int found_index_ref, int steps_ref, int reversed_ref) {
    int passed = 1;
    
    if (found_index != found_index_ref) {
        printf("  Subtask 2: Found index mismatch - got %d, expected %d\n", 
               found_index, found_index_ref);
        passed = 0;
    }
    
    // Steps may vary slightly depending on implementation, so we allow ±2
    if (abs(steps_taken - steps_ref) > 2) {
        printf("  Subtask 2: Steps mismatch - got %d, expected %d\n", 
               steps_taken, steps_ref);
        passed = 0;
    }
    
    if (reversed != reversed_ref) {
        printf("  Subtask 2: Reversed flag mismatch - got %d, expected %d\n", 
               reversed, reversed_ref);
        passed = 0;
    }
    
    double points = 0.0;
    if (passed) {
        points = TASK2_VALUE / NUM_TESTS;
        printf("  Subtask 2: PASSED (%.2fp)\n", points);
    } else {
        printf("  Subtask 2: FAILED (0.00p)\n");
    }
    
    return points;
}

void write_out(int test_no, filter_result_t filter_res, search_result_t search_res) {
    char out_filename[50];
    FILE* out_file;

    sprintf(out_filename, "./output/frankfurt%d.out", test_no);
    out_file = fopen(out_filename, "w");
    if (out_file == NULL) {
        perror("Error opening output file");
        return;
    }

    fprintf(out_file, "%d\n", filter_res.filtered_count);
    fprintf(out_file, "%d\n", filter_res.stealth_activated);
    
    for (int i = 0; i < filter_res.filtered_count; i++) {
        unsigned long long raw;
        memcpy(&raw, &filter_res.output_array[i], sizeof(driver_t));
        fprintf(out_file, "%016llx\n", raw);
    }
    
    fprintf(out_file, "%d\n", search_res.found_index);
    fprintf(out_file, "%d\n", search_res.steps_taken);
    fprintf(out_file, "%d\n", search_res.reversed);

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

    driver_t *input_array = NULL;
    driver_t *filtered_array_ref = NULL;
    int num_drivers = 0;
    int threshold_x = 0;
    int filtered_count_ref = 0;
    int stealth_ref = 0;
    int found_index_ref = 0;
    int steps_ref = 0;
    int reversed_ref = 0;
    
    // Load test data
    load_test(test_no, &num_drivers, &input_array, &threshold_x,
              &filtered_count_ref, &filtered_array_ref, &stealth_ref,
              &found_index_ref, &steps_ref, &reversed_ref);
    
    printf("\n========== Test %d ==========\n", test_no);
    
    // Run Subtask 1
    filter_result_t filter_res = filter_drivers_wrapper(input_array, num_drivers);
    
    // Run Subtask 2
    search_result_t search_res = sort_and_search_wrapper(filter_res.output_array, 
                                                          filter_res.filtered_count, 
                                                          threshold_x);
    
    // Write output
    write_out(test_no, filter_res, search_res);
    
    // Check results
    double points1 = check_subtask1(test_no, filter_res.output_array, 
                                     filter_res.filtered_count, filter_res.stealth_activated,
                                     filtered_array_ref, filtered_count_ref, stealth_ref);
    
    double points2 = check_subtask2(test_no, search_res.found_index, 
                                     search_res.steps_taken, search_res.reversed,
                                     found_index_ref, steps_ref, reversed_ref);
    
    printf("Total: %.2fp / %.2fp\n", points1 + points2, TASK1_VALUE + TASK2_VALUE);
    
    // Free memory
    free(input_array);
    free(filtered_array_ref);
    
    if (points1 + points2 == TASK1_VALUE + TASK2_VALUE) {
        return 0;
    } else {
        return 1;
    }
}