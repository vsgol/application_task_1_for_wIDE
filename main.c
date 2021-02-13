#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void find_max_zero_column(uint32_t n, uint32_t m, char data[n][m]);


int main() {

    char A[3][4];

    A[0][0] = '0'; A[0][1] = '1'; A[0][2] = '2'; A[0][3] = '3';
    A[1][0] = '1'; A[1][1] = '1'; A[1][2] = '0'; A[1][3] = '3';
    A[2][0] = '2'; A[2][1] = '2'; A[2][2] = '0'; A[2][3] = '3';

    find_max_zero_column(3, 4, A);

    return 0;
}