FLAGS = -g -no-pie

main: main.o task-01.o
	gcc $(FLAGS) $^ -o $@

task-01.o: task-01.s
	gcc $(FLAGS) -c $< -o $@

main.o: main.c
	gcc $(FLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf *.o main
