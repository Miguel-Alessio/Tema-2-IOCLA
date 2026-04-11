#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

#define NUM_TESTS  5
#define TASK_VALUE 25.0
#define SUBTASK1_TESTS_START	1
#define SUBTASK2_TESTS_START	2
#define SUBTASK3_TESTS_START	3

struct date{
	__uint8_t day;
	__uint8_t hour;
	__uint8_t minutes;
};  // 24 bits -> 3 bytes

struct ticket{
	char destination[32];       // 32 bytes
	struct date departingTime;  // 3 bytes
	struct date arrivingTime;   // 3 bytes
	__uint16_t bag_weight;      // 2 bytes
	__uint8_t delayMinutes;     // 1 byte
	__uint8_t delayHours;       // 1 byte
}; // 42 bytes size, no padding

extern void apply_delay(struct ticket* tickets, int nr_tickets);
extern void filter_flights(struct ticket* origTickets, struct ticket* destTickets,
							int* nr_tickets, int min_bag_weight);
extern int sort_and_return(struct ticket* tickets, int nr_tickets, 
							struct ticket* bestTicket, char* destination);

void load_test(unsigned int test_no, int *nr_tickets,  struct ticket **tickets, int *min_bag_weight, char destination[32]) {
	FILE* input_file;
	char file_name[30];

	sprintf(file_name, "./input/tickets%d.in", test_no);

	input_file = fopen(file_name, "r");
	if (input_file == NULL) {
		perror("Error opening input file");
		return;
	}

	fscanf(input_file, "%d", nr_tickets);
	(*tickets) = calloc(1, (*nr_tickets) * sizeof(struct ticket));

	for (int i = 0; i < *nr_tickets; i++) {
		fscanf(input_file, "%s", (*tickets)[i].destination);
		fscanf(input_file, "%hhu:%hhu:%hhu", &(*tickets)[i].departingTime.day, &(*tickets)[i].departingTime.hour, &(*tickets)[i].departingTime.minutes);
		fscanf(input_file, "%hhu:%hhu:%hhu", &(*tickets)[i].arrivingTime.day, &(*tickets)[i].arrivingTime.hour, &(*tickets)[i].arrivingTime.minutes);
		fscanf(input_file, "%hu", &(*tickets)[i].bag_weight);
		fscanf(input_file, "%hhu:%hhu", &(*tickets)[i].delayHours, &(*tickets)[i].delayMinutes);
	}

	// flag set, read min_bag_weight
	if (*min_bag_weight == 1) {
		fscanf(input_file, "%d", min_bag_weight);
	}

	if (strcmp(destination, "READ") == 0) {
		fscanf(input_file, "%s", destination);
	}

	fclose(input_file);
}

void load_ref(unsigned int test_no, int *nr_tickets_ref,  struct ticket **tickets) {
	FILE* ref_file;
	char file_name[30];

	sprintf(file_name, "./ref/tickets%d.ref", test_no);

	ref_file = fopen(file_name, "r");
	if (ref_file == NULL) {
		perror("Error opening ref file");
		return;
	}

	fscanf(ref_file, "%d", nr_tickets_ref);
	(*tickets) = calloc(1, (*nr_tickets_ref) * sizeof(struct ticket));

	for (int i = 0; i < *nr_tickets_ref; i++) {
		fscanf(ref_file, "%s", (*tickets)[i].destination);
		fscanf(ref_file, "%hhu:%hhu:%hhu", &(*tickets)[i].departingTime.day, &(*tickets)[i].departingTime.hour, &(*tickets)[i].departingTime.minutes);
		fscanf(ref_file, "%hhu:%hhu:%hhu", &(*tickets)[i].arrivingTime.day, &(*tickets)[i].arrivingTime.hour, &(*tickets)[i].arrivingTime.minutes);
		fscanf(ref_file, "%hu", &(*tickets)[i].bag_weight);
	}

	fclose(ref_file);
}

int compare_structs(int nr_tickets, struct ticket *tickets, struct ticket *ref_tickets) {
	for (int i = 0; i < nr_tickets; i++) {
		if (memcmp(&tickets[i], &ref_tickets[i], sizeof(struct ticket) -  2) != 0) {
			return 0; 
		}
	}
	
	return 1;
}

double handle_task1(unsigned int test_no, int nr_tickets,  struct ticket *tickets, struct ticket *ref_tickets) {
	apply_delay(tickets, nr_tickets);

	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/tickets%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return 0.0;
	}

	fprintf(out_file, "%d\n", nr_tickets);
	for (int i = 0; i < nr_tickets; i++)
		fprintf(out_file, "%s %hhu:%hhu:%hhu %hhu:%hhu:%hhu %hu\n", tickets[i].destination, tickets[i].departingTime.day,
			tickets[i].departingTime.hour, tickets[i].departingTime.minutes, tickets[i].arrivingTime.day, tickets[i].arrivingTime.hour,
			tickets[i].arrivingTime.minutes, tickets[i].bag_weight);

	fclose(out_file);

	if (compare_structs(nr_tickets, tickets, ref_tickets))
		return (double) TASK_VALUE / (double) NUM_TESTS;
	return 0.0;
}

double handle_task2(unsigned int test_no, int nr_tickets,  struct ticket *tickets, struct ticket *ref_tickets, int min_bag_weight) {
	struct ticket* tickets_redone = malloc(nr_tickets * sizeof(struct ticket));
	
	filter_flights(tickets, tickets_redone, &nr_tickets, min_bag_weight);

	memcpy((void*)tickets, (void*)tickets_redone, nr_tickets * sizeof(struct ticket));
	free(tickets_redone);

	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/tickets%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return 0.0;
	}

	fprintf(out_file, "%d\n", nr_tickets);
	for (int i = 0; i < nr_tickets; i++)
		fprintf(out_file, "%s %hhu:%hhu:%hhu %hhu:%hhu:%hhu %hu\n", tickets[i].destination, tickets[i].departingTime.day,
			tickets[i].departingTime.hour, tickets[i].departingTime.minutes, tickets[i].arrivingTime.day, tickets[i].arrivingTime.hour,
			tickets[i].arrivingTime.minutes, tickets[i].bag_weight);

	fclose(out_file);

	if (compare_structs(nr_tickets, tickets, ref_tickets))
		return (double) TASK_VALUE / (double) NUM_TESTS;
	return 0.0;
}

double handle_task3(unsigned int test_no, int nr_tickets,  struct ticket *tickets, int nr_tickets_ref, 
			struct ticket *ref_tickets, char destination[32]) {
	struct ticket* best_ticket = malloc(sizeof(struct ticket));
	
	int result = sort_and_return(tickets, nr_tickets, best_ticket, destination);

	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/tickets%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return 0.0;
	}

	fprintf(out_file, "%d\n", result);
	if (result == 0) 
		goto done;

	int i = 0;
	fprintf(out_file, "%s %hhu:%hhu:%hhu %hhu:%hhu:%hhu %hu\n", best_ticket[i].destination, best_ticket[i].departingTime.day,
		best_ticket[i].departingTime.hour, best_ticket[i].departingTime.minutes, best_ticket[i].arrivingTime.day, best_ticket[i].arrivingTime.hour,
		best_ticket[i].arrivingTime.minutes, best_ticket[i].bag_weight);

done:
	fclose(out_file);

	if (result != nr_tickets_ref) {
		free(best_ticket);
		return 0.0;
	}

	if (result == 0 || compare_structs(1, best_ticket, ref_tickets)) {
		free(best_ticket);
		return (double) TASK_VALUE / (double) NUM_TESTS;
	}

	return 0.0;
}

double handle_all_tasks(unsigned int test_no, int nr_tickets, struct ticket *tickets, int nr_tickets_ref,
						struct ticket *ref_tickets, int min_bag_weight, char destination[32]) {
	apply_delay(tickets, nr_tickets);

	struct ticket* tickets_redone = malloc(nr_tickets * sizeof(struct ticket));
	
	filter_flights(tickets, tickets_redone, &nr_tickets, min_bag_weight);

	memcpy((void*)tickets, (void*)tickets_redone, nr_tickets * sizeof(struct ticket));
	free(tickets_redone);

	struct ticket* best_ticket = malloc(sizeof(struct ticket));
	
	int result = sort_and_return(tickets, nr_tickets, best_ticket, destination);

	char out_filename[30];
	FILE* out_file;

	sprintf(out_filename, "./output/tickets%d.out", test_no);
	out_file = fopen(out_filename, "w");
	if (out_file == NULL) {
		perror("Error opening output file");
		return 0.0;
	}

	fprintf(out_file, "%d\n", result);
	if (result == 0) 
		goto done;

	int i = 0;
	fprintf(out_file, "%s %hhu:%hhu:%hhu %hhu:%hhu:%hhu %hu\n", best_ticket[i].destination, best_ticket[i].departingTime.day,
		best_ticket[i].departingTime.hour, best_ticket[i].departingTime.minutes, best_ticket[i].arrivingTime.day, best_ticket[i].arrivingTime.hour,
		best_ticket[i].arrivingTime.minutes, best_ticket[i].bag_weight);

done:
	fclose(out_file);

	if (result != nr_tickets_ref) {
		free(best_ticket);
		return 0.0;
	}

	if (result == 0 || compare_structs(1, best_ticket, ref_tickets)) {
		free(best_ticket);
		return (double) TASK_VALUE / (double) NUM_TESTS;
	}

	return 0.0;						
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <test_no>\n", argv[0]);
		return 1;
	}

	// get test number from bash
	int test_no = atoi(argv[1]);

	double task_result = 0.0;
	int nr_tickets, nr_tickets_ref;
	struct ticket *tickets = NULL;
	struct ticket *ref_tickets = NULL;

	// load ref data
	load_ref(test_no, &nr_tickets_ref, &ref_tickets);

	// init flags for reading data
	int min_bag_weight = 0;
    char destination[32] = "\0";

	// i don't particularly like this way of calling fuctions. but it works ig
	if (test_no <= SUBTASK1_TESTS_START) {
        load_test(test_no, &nr_tickets, &tickets, &min_bag_weight, destination);
        task_result = handle_task1(test_no, nr_tickets, tickets, ref_tickets);
    }
    else if (test_no <= SUBTASK2_TESTS_START) {
        min_bag_weight = 1;
        load_test(test_no, &nr_tickets, &tickets, &min_bag_weight, destination);
        task_result = handle_task2(test_no, nr_tickets, tickets, ref_tickets, min_bag_weight);
    }
    else if (test_no <= SUBTASK3_TESTS_START) {
        memcpy(destination, "READ\0", 5);
        load_test(test_no, &nr_tickets, &tickets, &min_bag_weight, destination);
        task_result = handle_task3(test_no, nr_tickets, tickets, nr_tickets_ref, ref_tickets, destination);
    }
    else {
        min_bag_weight = 1;
        memcpy(destination, "READ\0", 5);
        load_test(test_no, &nr_tickets, &tickets, &min_bag_weight, destination);
        task_result = handle_all_tasks(test_no, nr_tickets, tickets, nr_tickets_ref, ref_tickets, min_bag_weight, destination);
    }

	// free structs
	free(ref_tickets);
	free(tickets);

	if (task_result > 0.0) {
		printf("Test %d.................PASSED: %.2fp\n", test_no, task_result);
		return 0;
	}
	
	printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
	return 1;
}
