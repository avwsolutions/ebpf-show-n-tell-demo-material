#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])    
{
  char coin[4] = "BTC";
  int count;
  count = 0;
  printf("Start mining BTC for %s\n",argv[1]);
  while(1)
  {
    printf("%d %s\n",count, coin);
    fflush(stdout);
    count = count+1;
    sleep(3);
  }
} 
