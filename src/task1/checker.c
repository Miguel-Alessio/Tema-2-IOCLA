#include <stdio.h>

#define NO_TASKS 5

extern int count_errors(char *errors, int num_drivers);
extern void fix_lap_times(unsigned int *in_times, char *errors, 
                          int num_drivers, unsigned int *out_times, 
                          int *error_count);

void readInput(char *filename, unsigned int *in_times, char *errors, int *ptr_n)
{
	FILE *input = fopen(filename, "r");

	fscanf(input, "%d", ptr_n);
	for (int i = 0; i < (*ptr_n); ++i) {
		fscanf(input, "%u", &in_times[i]);
	}
	for (int i = 0; i < (*ptr_n); ++i) {
		int val;
		fscanf(input, "%d", &val);
		errors[i] = (char)val;
	}

	fclose(input);
}

void readRef(char *filename, unsigned int *ref_times, int *ptr_ref_n, int *ptr_ref_error_count)
{
	FILE *ref = fopen(filename, "r");

	fscanf(ref, "%d", ptr_ref_n);
	fscanf(ref, "%d", ptr_ref_error_count);
	for (int i = 0; i < (*ptr_ref_n); ++i) {
		fscanf(ref, "%u", &ref_times[i]);
	}
	
	fclose(ref);
}

void printOutput(char *filename, unsigned int *out_times, int out_n, int error_count)
{
	FILE *output = fopen(filename, "w");

	if (output == NULL) {
		perror("Error opening output file");
		return;
	}

	fprintf(output, "%d\n", error_count);
	for (int i = 0; i < out_n; ++i) {
		fprintf(output, "%u ", out_times[i]);
	}
	fprintf(output, "\n");

	fclose(output);
}

int check(unsigned int *out_times, int out_n, unsigned int *ref_times, 
          int ref_n, int error_count, int ref_error_count)
{
	if (out_n != ref_n || error_count != ref_error_count) {
		return 0;
	}

	for (int i = 0; i < out_n; ++i) {
		if (out_times[i] != ref_times[i]) {
			return 0;
		}
	}

	return 1;
}

int main(int argc, char **argv)
{
	float score = 0;
	char input_file[50], output_file[50], ref_file[50];

	printf("-------------- MONACO TASK --------------\n");

	unsigned int in_times[256], out_times[256], ref_times[256];
	char errors[256];
	int num_drivers;
	int error_count = 0;
	int ref_n, ref_error_count;

	for (int i = 0; i < NO_TASKS; i++) {
		/* read input */
		sprintf(input_file, "./input/monaco%d.in", i + 1);
		sprintf(ref_file, "./ref/monaco%d.ref", i + 1);

		readInput(input_file, in_times, errors, &num_drivers);
		readRef(ref_file, ref_times, &ref_n, &ref_error_count);

		fix_lap_times(in_times, errors, num_drivers, out_times, &error_count);

		sprintf(output_file, "./output/monaco%d.out", i + 1);
		printOutput(output_file, out_times, num_drivers, error_count);

		if (check(out_times, num_drivers, ref_times, ref_n, error_count, ref_error_count)) {
			printf("Test %02d.................PASSED: %.1fp\n", i + 1, 2.0);
			score += 2.0;
		}
		else {
			printf("Test %02d.................FAILED: %.1fp\n", i + 1, 0.0);
		}
	}

	printf("\nTOTAL SCORE: %.2f / 10.00\n\n", score);

	return 0;
}
