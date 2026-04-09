#include <stdio.h>
#include <stdlib.h>

#define NUM_TESTS 5
#define TASK_VALUE 20.0
#define MAX_BOARD_SIZE 16

int check_row(int **array, int size, int rowNr);
int check_column(int **array, int size, int columnNr);
int check_box(int **array, int size, int boxNr);

void load_test(unsigned int test_no, int *board_size, int **sudoku) {
	FILE* input_file;
	char file_name[30];

	sprintf(file_name, "./input/sudoku%d.in", test_no);

	input_file = fopen(file_name, "r");
	if (input_file == NULL) {
		perror("Error opening input file");
		return;
	}


	fscanf(input_file, "%d", board_size);
	for (int i = 0; i < *board_size; i++)
		for (int j = 0; j < *board_size; j++)
			fscanf(input_file, "%d", &sudoku[i][j]);

	fclose(input_file);
}

double check_result(int test_no, int sudoku_result) {
	int correct_result;
	char ref_filename[30];
	FILE* ref_file;

	sprintf(ref_filename, "./ref/sudoku%d.ref", test_no);
	ref_file = fopen(ref_filename, "r");
	if (ref_file == NULL) {
		perror("Error opening ref file");
		return 0.0;
	}
	

	fscanf(ref_file, "%d", &correct_result);

	double points = 0.0;
	if (sudoku_result == correct_result)
		points = (double)TASK_VALUE / (double)NUM_TESTS;

	if (points != 0) {
		printf("Test %d.................PASSED: %.2fp\n", test_no, points);
	} else {
		printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
	}

	fclose(ref_file);
	return points;
}

void write_out(int test_no, int sudoku_result) {
	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/sudoku%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return;
	}

	fprintf(out_file, "%d", sudoku_result);

	fclose(out_file);
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <test_no>\n", argv[0]);
		return 1;
	}

	// get test number from bash
	int test_no = atoi(argv[1]);

	int **sudoku;
	
	// malloc matrix. make sure it's big enough to handly any input
	sudoku = (int **)malloc(MAX_BOARD_SIZE * sizeof(int *));
	if (sudoku == NULL) {
		perror("Error allocating memory");
		return EXIT_FAILURE;
	}

	for (int i = 0; i < MAX_BOARD_SIZE; i++) {
		sudoku[i] = (int *)malloc(MAX_BOARD_SIZE * sizeof(int));
	}

	// load test data
	int board_size;
	load_test(test_no, &board_size, sudoku);

	int sudoku_result = 0;
	for (int i = 0; i < board_size; i++) {
		sudoku_result = check_row(sudoku, board_size, i) & 
						check_column(sudoku, board_size, i) &
						check_box(sudoku, board_size, i);
		
		// break in case of failure
		if (sudoku_result == 0) {
			break;
		}
	}

	write_out(test_no, sudoku_result);
	
	int passed = check_result(test_no, sudoku_result);

	for (int i = 0; i < MAX_BOARD_SIZE; i++) {
		free(sudoku[i]);
	}
	free(sudoku);

	if (passed) {
		return 0; 
	} else {
		return 1;
	}
}
