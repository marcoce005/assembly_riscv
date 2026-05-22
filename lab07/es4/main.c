#include <stdio.h>

#define ROW 5

extern int mat_type(int **m, int r);
void print_mat(int r, int m[r][r]);

int main(void)
{
    int m[][ROW] = {
        {1, 0, 0, 1, 0},
        {0, 2, 0, 0, 0},
        {0, 0, 3, 0, 0},
        {0, 0, 0, 4, 0},
        {0, 0, 0, 0, 5}};

    char *res[] = {"not symmetric", "symmetric", "diagonal"};

    print_mat(ROW, m);

    printf("\nThe matrix is %s", res[mat_type(m, ROW)]);

    return 0;
}

void print_mat(int r, int m[r][r])
{
    int i, j;
    for (i = 0; i < r; i++)
    {
        for (j = 0; j < r; j++)
            printf("%d ", m[i][j]);
        printf("\n");
    }
}