#include <stdio.h>

#define LEN 6

extern void leap_year(int *in, char *out, int l);

int main(void)
{
    int vet_in[LEN] = {1945, 2008, 1800, 2006, 1748, 1600};
    char vet_out[LEN];

    leap_year(vet_in, vet_out, LEN);

    for (int i = 0; i < LEN; i++)
        printf("%d --> %c\n", vet_in[i], vet_out[i] + 48);

    return 0;
}