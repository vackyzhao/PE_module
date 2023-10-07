#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <math.h>
#include <string.h>

#define M 16
#define Ni 8            // Ifmap_shift_in
#define Nj 12           // Filter_in
#define Nw 14           // Psum_in
#define N (Ni*Nj*Nw)
#define eps (1e-7)

int main(int argc, char **argv)
{
  unsigned int A, B, C, Ai, Bi, Ci, Ri;
  unsigned int R, R_pipe0, R_pipe1, R_pipe2, R_pipe3;
  int i,t;
  

  srand48(time(NULL));
  assert (Ni<(sizeof(int)*8));
  assert (Nj<(sizeof(int)*12));
  assert (Nw<(sizeof(int)*14));

  R       = 0;
  R_pipe0 = 0;
  R_pipe1 = 0;
  R_pipe2 = 0;
  R_pipe3 = 0;

  for(t=0; t<M; t++) {
    /* generate uniformly random integers in correct range */
    A = rand() % 256;
    B = rand() % 4096; 
    C = rand() % 16384; 

    unsigned int B3 = (B >> 8) & 0xF;
    unsigned int B2 = (B >> 4) & 0xF;
    unsigned int B1 = B & 0xF;
    

    R_pipe3 = R_pipe2; 
    R_pipe2 = R_pipe1; 
    R_pipe1 = R_pipe0; 
    R_pipe0 = A; 
    R = C + R_pipe3*B3 + R_pipe2*B2 + R_pipe1*B1;

    printf("Ifmap_shift_in = ");
    for(i=Ni-1; i>=0; i--) {
      Ai = ((A&(1<<i))!=0)?1:0;
      printf("%i",Ai);
    }

    printf("     Filter_in = ");
    for(i=Nj-1; i>=0; i--) {
      Bi = ((B&(1<<i))!=0)?1:0;
      printf("%i",Bi);
    }

    printf("     Psum_in = ");
    for(i=Nw-1; i>=0; i--) {
      Ci = ((C&(1<<i))!=0)?1:0;
      printf("%i",Ci);
    }
    
    printf("     Psum_out = ");
    for(i=Nw-1; i>=0; i--) {
      Ri = ((R&(1<<i))!=0)?1:0;
      printf("%i",Ri);
    }

    printf("\n");
  }
  return 0;
}