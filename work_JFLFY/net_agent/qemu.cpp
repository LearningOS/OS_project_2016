//Server.cpp
#include <iostream>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

using namespace std;

#define  PORT 1234
#define  IP_ADDRESS "127.0.0.1"

void* ClientThread(void* lpParameter)
{
    int CientSocket = (int)(long)lpParameter;
    int Ret = 0;
    char SendBuffer[PATH_MAX];

    // cout<<"Thread started"<<endl;
    while ( true )
    {
        cin.getline(SendBuffer, sizeof(SendBuffer));
        Ret = send(CientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
        if ( Ret == 0 || Ret == -1 )
        {
            cout<<"Client quits"<<endl;
            break;
        }
    }

    return 0;
}

int main(int argc, char* argv[])
{
    int ServerSocket, CientSocket;
    struct sockaddr_in LocalAddr, ClientAddr;
    int Ret = 0;
    socklen_t AddrLen = 0;
	pthread_t ntid;

    //Create Socket
    ServerSocket = socket(AF_INET, SOCK_STREAM, 0);
    if ( ServerSocket == -1 )
    {
        cout<<"Create Socket Failed::"<<strerror(errno)<<endl;
        return -1;
    }

    LocalAddr.sin_family = AF_INET;
    LocalAddr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    LocalAddr.sin_port = htons(PORT);
    memset(LocalAddr.sin_zero, 0x00, 8);

    //Bind Socket
    Ret = bind(ServerSocket, (struct sockaddr*)&LocalAddr, sizeof(LocalAddr));
    if ( Ret != 0 )
    {
        cout<<"Bind Socket Failed::"<<strerror(errno)<<endl;
        return -1;
    }

    Ret = listen(ServerSocket, 10);
    if ( Ret != 0 )
    {
        cout<<"listen Socket Failed::"<<strerror(errno)<<endl;
        return -1;
    }

    // cout<<"Server starts."<<endl;
    cout<<"Qemu ready."<<endl;

    // while ( true )
    // {
        AddrLen = sizeof(ClientAddr);
        CientSocket = accept(ServerSocket, (struct sockaddr*)&ClientAddr, &AddrLen);
        if ( CientSocket == -1 )
        {
            cout<<"Accept Failed::"<<strerror(errno)<<endl;
            // break;
        }

        cout<<"Client is connected::"<<inet_ntoa(ClientAddr.sin_addr)<<":"<<ClientAddr.sin_port<<endl;

        pthread_create(&ntid, NULL, ClientThread, (void*)(long)CientSocket);

    // }
    pthread_join(ntid,NULL);

    close(ServerSocket);
    close(CientSocket);

    return 0;
}
