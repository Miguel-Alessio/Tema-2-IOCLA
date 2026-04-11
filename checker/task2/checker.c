#include <stdio.h>
#include <stdlib.h>

#define NUM_TESTS 5
#define TASK_VALUE 25.0

typedef struct position {
	unsigned int line;
	unsigned int col;
} Position;

extern void solve_labyrinth(unsigned int *out_line, unsigned int *out_col,
							unsigned int m, unsigned int n, char **maze);

void load_test(unsigned int test_no, char ***a, unsigned int *m, unsigned int *n) {
	unsigned int line, col;
	FILE *file;
	char file_name[30];

	sprintf(file_name, "./input/labyrinth_%d.in", test_no);

	file = fopen(file_name, "r");
	if (file == NULL) {
		perror("Error opening input file");
		return;
	}

	fscanf(file, "%d %d", m, n);
	fgetc(file);
	*a = (char **) malloc(*m * sizeof(char *));

	for (line = 0; line < *m; line++) {
		(*a)[line] = (char *) malloc(*n * sizeof(char));
		for (col = 0; col < *n; col++) {
			fscanf(file, "%c", &((*a)[line][col]));
			fgetc(file);
		}
	}

	fclose(file);
}

double check_result(int test_no, Position *sol) {
	char ref_filename[30];
	FILE *ref_file;
	Position correct_solution;

	sprintf(ref_filename, "./ref/labyrinth_%d.ref", test_no);
	ref_file = fopen(ref_filename, "r");
	if (ref_file == NULL) {
		perror("Error opening ref file");
		return 0.0;
	}

	fscanf(ref_file, "%u %u", &correct_solution.line, &correct_solution.col);
	
	double points = 0.0;
	if (correct_solution.line == sol->line && correct_solution.col == sol->col) {
		points = (double)TASK_VALUE / (double)NUM_TESTS;
	}

	if (points != 0) {
		printf("Test %d.................PASSED: %.2fp\n", test_no, points);
	} else {
		printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
	}

	fclose(ref_file);
	return points;
}

void write_out(int test_no, Position *sol) {
	char output_filename[30];
	FILE *output_file;

	sprintf(output_filename, "./output/labyrinth_%d.out", test_no);
	output_file = fopen(output_filename, "w");
	if (output_file == NULL) {
		perror("Error opening output file");
		return;
	}

	fprintf(output_file, "%u %u\n", sol->line, sol->col);
	
	fclose(output_file);
}

void free_test(unsigned int m, char **a) {
	unsigned int line;

	for (line = 0; line < m; line++) {
		free(a[line]);
	}
	free(a);
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <test_no>\n", argv[0]);
		return 1;
	}

	// get test number from bash
	int test_no = atoi(argv[1]);

	Position sol = {0, 0};
	unsigned int m, n;
	char **a = NULL;

	// load test data
	load_test(test_no, &a, &m, &n);

	// run the main logic
	if (a != NULL) {
		solve_labyrinth(&sol.line, &sol.col, m, n, a);
	}

	// write the output to file
	write_out(test_no, &sol);

	// check against reference and get points
	double passed = check_result(test_no, &sol);

	// free mem
	if (a != NULL) {
		free_test(m, a);
	}

	if (passed != 0.0) {
		return 0; 
	} else {
		return 1;
	}
}