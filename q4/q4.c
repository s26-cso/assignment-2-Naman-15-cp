    #include<dlfcn.h>
    #include<string.h>
    #include<stdio.h>

    int main(){
        char str[10];
        int a,b;
        while(scanf("%s %d %d",str,&a,&b)==3){//scanf returns the no of arguments it was able to scan
            char filepath[20];
            strcpy(filepath,"./lib");
            strcat(filepath,str);
            strcat(filepath,".so");

            void* ialsodontknow = dlopen(filepath,RTLD_LAZY);

            int (*calculate)(int,int);
            calculate=dlsym(ialsodontknow,str);

            int answer = calculate(a, b);
            printf("%d\n", answer);

            dlclose(ialsodontknow);//have to hand them the specific ticket they gave you when you arrived so they know which coat to give back
        }

        return 0;
    }