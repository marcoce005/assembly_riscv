#include <stdio.h>

extern int n_solutions(int a, int b, int c);

int main(void)
{
    int a, b, c;

    printf("\nInsert parameters:\na --> ");
    scanf("%d", &a);
    printf("b --> ");
    scanf("%d", &b);
    printf("c --> ");
    scanf("%d", &c);

    printf("\nNumber of solutions: %d\t", n_solutions(a, b, c));

    return 0;
}