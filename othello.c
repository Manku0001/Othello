#include <stdio.h>
#include <stdbool.h>
#define BLACK 1
#define WHITE 2
#define EMPTY 0

int board[8][8];
int x,y;
bool north,south,east,west,n_east,s_east,n_west,s_west;

void print_board(){
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			printf("%d  ",board[i][j]);
		}
		printf("\n");
	}
}

void set_bools(){
	north = false;
	south = false;
	east = false;
	west = false;
	n_east = false;
	s_east = false;
	n_west = false;
	s_west = false;
}

bool check_west(int c,int x,int y){
	if(y==0) return false;
	for(int i=y-1;i>=0;i--){
		if(board[x][i]==0) return false;
		if(board[x][i]==c){
			for(int k=i; k<=y; k++) board[x][k]=c;
			west = true;
			return true;
		}
	}
	return false;
}

bool check_east(int c,int x,int y){
	if(y==7) return false;
	for(int i=y+1;i<8;i++){
		if(board[x][i]==0) return false;
		if(board[x][i]==c){
			for(int k=y+1;k<i;k++) board[x][k]=c;
			east = true;
			return true;
		} 
	}
	return false;
}

bool check_north(int c,int x,int y){
	if(x==0) return false;
	for(int i=x-1;i>=0;i--){
		if(board[i][y]==0) return false;
		if(board[i][y]==c){
			for(int k=i+1;k<=x;k++) board[k][y]=c;
			north = true;
			return true;
		}
	}
	return false;
}

bool check_south(int c,int x,int y){
	if(x==7) return false;
	for(int i=x+1;i<8;i++){
		if(board[i][y]==0) return false;
		if(board[i][y]==c){
			for(int k=x;k<i;k++) board[k][y]=c;
			south = true;
			return true;
		}
	}
	return false;
}

bool check_north_west(int c,int x,int y){
	if(x==0 || y==0) return false;
	int d=y;
	if(x<y) d=x;
	for(int i=1;i<d;i++){
		if(board[x-i][y-i]==0) return false;
		if(board[x-i][y-i]==c){
			for(int k=0;k<i;k++) board[x-i][y-i]=c;
			n_west = true;
			return true;
		}
	}
	return false;
}

bool check_south_west(int c,int x,int y){
	if(x==7 || y==7) return false;
	int d=y;
	if(x>=y) d=x;
	d = 7-d;
	for(int i=1;i<d;i++){
		if(board[x+i][y+i]==0) return false;
		if(board[x+i][y+i]==c){
			for(int k=0;k<i;k++) board[x+i][y+i]=c;
			s_west = true;
			return true;
		}
	}
	return false;
}

bool check_north_east(int c,int x,int y){
	if(x==0 || y==7) return false;
	int d=7-y;
	if(x<d) d=x;
	for(int i=1;i<d;i++){
		if(board[x-i][y+i]==0) return false;
		if(board[x-i][y+i]==c){
			for(int k=0;k<i;k++) board[x-i][y+i]=c;
			n_east = true;
			return true;
		}
	}
	return false;
}

bool check_south_east(int c,int x,int y){
	if(x==7 || y==0) return false;
	int d=7-x;
	if(y<d) d=y;
	for(int i=1;i<d;i++){
		if(board[x+i][y-i]==0) return false;
		if(board[x+i][y-i]==c){
			for(int k=0;k<i;k++) board[x+i][y-i]=c;
			n_east = true;
			return true;
		}
	}
	return false;
}

void check_move(int c,int x,int y){
	if(board[x][y]!=0){
		printf("ILLEGAL MOVE\nTry Again!\n");
		return;
	}
	set_bools();
	check_north(c,x,y);
	check_south(c,x,y);
	check_west(c,x,y);
	check_east(c,x,y);
	check_north_east(c,x,y);
	check_north_west(c,x,y);
	check_south_east(c,x,y);
	check_south_west(c,x,y);
	if(north || south || east || west || n_east || n_west || s_west || s_east) print_board();
	else printf("ILLEGAL MOVE\nTry Again!\n");
}

void turn_black(){
	printf("Mr Black, enter the x coordinate: ");
	scanf("%d",&x);
	printf("Mr Black, enter the y coordinate: ");
	scanf("%d",&y);
	check_move(1,x,y);
}

void turn_white(){
	printf("Mr White, enter the x coordinate: ");
	scanf("%d",&x);
	printf("Mr White, enter the y coordinate: ");
	scanf("%d",&y);
	check_move(2,x,y);
}

int main(){

	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			board[i][j]=EMPTY;
		}
	}

	board[3][3] = BLACK;
	board[4][4] = BLACK;
	board[4][3] = WHITE;
	board[3][4] = WHITE;

	print_board();
	turn_black();
	turn_white();
}