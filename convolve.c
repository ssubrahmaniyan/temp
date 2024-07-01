//Program to return the convolution of two signals
//There is an inbuilt assumption that the signals are zero for all t < 0 and zero after the points input
//The program has been written for integer signal values, but can easily be generalized to float or double
//Input arguments : None
//Input : Signal lengths and values as and when asked for
//Output : Convolution(discrete time) of the signal
//Last edited by Sanjeev Subrahmaniyan on July 1
//----------------------------------------------------------------------------------------------------------

#include<stdio.h>
#include<stdlib.h>

void conv(int* x, int* y, int* z, int lenx, int leny);
int min(int x, int y);
int max(int x, int y);

int main(){
	int lenx, leny;
	printf("Enter the lengths of the signals x and y ");
	scanf("%d %d", &lenx, &leny);
	printf("Entered lengths %d, %d \n", lenx, leny);
	int* x = (int*)malloc(lenx*sizeof(int));
	int* y = (int*)malloc(leny*sizeof(int));
	int* z = (int*)malloc((lenx+leny-1)*sizeof(int));

	printf("All signals are assumed to be zero for all t < 0 and zero for all values beyond the length input for this code \n");
	printf("Enter the signal x ");
	for(int i = 0; i < lenx; i++){
		scanf("%d", &x[i]);
	}
	printf("Entered x signal is: ");
        for(int i = 0; i < lenx; i++){
                printf("%d ", x[i]);
        }
	printf("\n");

        printf("Enter the signal y ");
        for(int i = 0; i < leny; i++){
                scanf("%d", &y[i]);
        }
        printf("Entered y signal is: ");
        for(int i = 0; i < leny; i++){
                printf("%d ", y[i]);
        }  
	printf("\n");
	
	conv(x, y, z, lenx, leny);

	printf("The convolved signal is ");
	for(int i = 0; i < lenx + leny - 1; i++){
		printf("%d ", z[i]);
	}
	printf("\n");

	free(x);
	free(y);
	free(z);
}

void conv(int* x, int* y, int* z, int lenx, int leny){
	int lenz = lenx + leny - 1;
	
	for(int i = 0; i < lenz; i++){
		z[i] = 0;
	}
	printf("%d \n", lenx);

	for(int i = 0; i < lenx + leny -1; i++){
		for(int j = max(i - leny + 1, 0); j <= min(i, lenx - 1); j++){
			z[i] += x[j] * y[i-j];
		}
	}
}

int min(int x, int y){
	if(x > y){
		return y;
	}
	else{
		return x;
	}
}

int max(int x, int y){
	if(x > y){
		return x;
	}
	else{
		return y;
	}
}
