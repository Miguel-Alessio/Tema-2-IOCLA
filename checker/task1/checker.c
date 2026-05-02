#include <stdio.h>
#include <stdlib.h>

#define NUM_TESTS 5
#define TASK_VALUE 20.0
#define MAX_DRIVERS 256

extern void fix_lap_times(unsigned int *in_times, char *errors, 
						  int num_drivers, unsigned int *out_times, 
						  int *error_count);

void load_test(unsigned int test_no, unsigned int *in_times, char *errors, int *num_drivers) {
	FILE* input_file;
	char file_name[30];

	sprintf(file_name, "./input/monaco%d.in", test_no);

	input_file = fopen(file_name, "r");
	if (input_file == NULL) {
		perror("Error opening input file");
		return;
	}

	fscanf(input_file, "%d", num_drivers);
	for (int i = 0; i < *num_drivers; ++i) {
		fscanf(input_file, "%u", &in_times[i]);
	}
	for (int i = 0; i < *num_drivers; ++i) {
		int val;
		fscanf(input_file, "%d", &val);
		errors[i] = (char)val;
	}

	fclose(input_file);
}

double check_result(int test_no, int num_drivers, unsigned int *out_times, int out_error_count) {
	int ref_error_count;
	unsigned int ref_times[num_drivers];
	char ref_filename[30];
	FILE* ref_file;

	sprintf(ref_filename, "./ref/monaco%d.ref", test_no);
	ref_file = fopen(ref_filename, "r");
	if (ref_file == NULL) {
		perror("Error opening ref file");
		return 0.0;
	}
	
	fscanf(ref_file, "%d", &ref_error_count);
	for (int i = 0; i < num_drivers; ++i) {
		fscanf(ref_file, "%u", &ref_times[i]);
	}

	int is_correct = 1;
	if (out_error_count != ref_error_count) {
		is_correct = 0;
	} else {
		for (int i = 0; i < num_drivers; ++i) {
			if (out_times[i] != ref_times[i]) {
				is_correct = 0;
				break;
			}
		}
	}

	double points = 0.0;
	if (is_correct)
		points = (double)TASK_VALUE / (double)NUM_TESTS;

	if (points != 0) {
		printf("Test %d.................PASSED: %.2fp\n", test_no, points);
	} else {
		printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
	}

	fclose(ref_file);
	return points;
}

void write_out(int test_no, unsigned int *out_times, int num_drivers, int error_count) {
	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/monaco%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return;
	}

	fprintf(out_file, "%d\n", error_count);
	for (int i = 0; i < num_drivers; ++i) {
		fprintf(out_file, "%u ", out_times[i]);
	}
	fprintf(out_file, "\n");

	fclose(out_file);
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <test_no>\n", argv[0]);
		return 1;
	}

	// get test number from bash
	int test_no = atoi(argv[1]);

	unsigned int in_times[MAX_DRIVERS], out_times[MAX_DRIVERS];
	char errors[MAX_DRIVERS];
	int num_drivers;
	int error_count = 0;

	// load test data
	load_test(test_no, in_times, errors, &num_drivers);

	// run the main logic
	fix_lap_times(in_times, errors, num_drivers, out_times, &error_count);

	// write the output to file
	write_out(test_no, out_times, num_drivers, error_count);
	
	// check against reference and get points
	double passed = check_result(test_no, num_drivers, out_times, error_count);

	if (passed != 0.0) {
		return 0; 
	} else {
		return 1;
	}
}
