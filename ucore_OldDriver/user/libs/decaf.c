#include <stdio.h>
#include <file.h>

#define BUFSIZE 1024
static char buf[BUFSIZE];

char *
_readline(const char *prompt) {
    if(prompt!=NULL){
        cprintf("%s",prompt);
    }
    int i = 0, ret;
    char c;
    while (1) {
        if ((ret = read(0, &c, sizeof(char))) < 0) {
            cprintf("\n");
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
            cprintf("\n");
            buf[i] = '\0';
            return buf;
        }
    }
}





int atoi(const char*s);

void printInt(int x){
	printbase10(x);
}


void printStr(const char * str){
	cprintf(str);
}


void printBool(int x){
	if (x){
		cprintf("true");
	}else{
		cprintf("false");
	}
}


int _ReadInteger(){
	return atoi(_readline("> "));
}


char * _ReadLine(){
	return _readline("> ");
}


int atoi(const char* s){
	int i = 0;
	int neg = 0;
	if (s[0] == '-'){
		i = 1;
		neg = 1;
	}
	int res = 0;
	while (1){
		if (s[i] <= '9' && s[i] >= '0'){
			res *= 10;
			res += (s[i] - '0');
		}else if(s[i] == '\0' || s[i] == '\n' || s[i] == '\r'){
			if (neg){
				res = - res;
			}
			return res;
		}else{
            cprintf("atoi error\n");
            return 0;
		}
        i++;
	}
	return -1;
}

#define MAX_HEAP_SIZE 16000
static char heap_space[MAX_HEAP_SIZE];

char* alloc(int x){
    
	static int anchor = 0;
	anchor += x;
    if (anchor < MAX_HEAP_SIZE){
		return heap_space + anchor - x;
	}else{
		cprintf("not enough heap space, return null ptr\n");
		return NULL;
	}
}