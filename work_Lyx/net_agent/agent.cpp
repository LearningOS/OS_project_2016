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

#define  QEMUPORT 1234
#define  AGENTPORT 1235
#define  IP_ADDRESS "127.0.0.1"

int QemuSocket,GdbSocket;
pthread_mutex_t _mut,*mut=&_mut;

void *server_for_gdb(void* lpParameter){
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
        return NULL;
    }

    LocalAddr.sin_family = AF_INET;
    LocalAddr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    LocalAddr.sin_port = htons(AGENTPORT);
    memset(LocalAddr.sin_zero, 0x00, 8);

    //Bind Socket
    Ret = bind(ServerSocket, (struct sockaddr*)&LocalAddr, sizeof(LocalAddr));
    if ( Ret != 0 )
    {
        cout<<"Bind Socket Failed::"<<strerror(errno)<<endl;
        return NULL;
    }

    Ret = listen(ServerSocket, 10);
    if ( Ret != 0 )
    {
        cout<<"listen Socket Failed::"<<strerror(errno)<<endl;
        return NULL;
    }

    pthread_mutex_lock(mut);
    cout<<"Server for GDB starts."<<endl;
    pthread_mutex_unlock(mut);

    // while ( true )
    // {
        AddrLen = sizeof(ClientAddr);
        CientSocket = accept(ServerSocket, (struct sockaddr*)&ClientAddr, &AddrLen);
        GdbSocket = CientSocket;
        if ( CientSocket == -1 )
        {
            cout<<"Accept Failed::"<<strerror(errno)<<endl;
            // break;
        }

        pthread_mutex_lock(mut);
        cout<<"Client is connected::"<<inet_ntoa(ClientAddr.sin_addr)<<":"<<ClientAddr.sin_port<<endl;
        pthread_mutex_unlock(mut);

    char RecvBuffer[PATH_MAX];
    char SendBuffer[PATH_MAX];

    // cout<<"Thread started"<<endl;
    while ( true )
    {
        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
        Ret = recv(CientSocket, RecvBuffer, PATH_MAX, 0);
        if ( Ret == 0 || Ret == -1 )
        {
            pthread_mutex_lock(mut);
            cout<<"gdb break!"<<endl;
            pthread_mutex_unlock(mut);
            break;
        }
        memset(SendBuffer, 0x00, sizeof(SendBuffer));
        strncpy(SendBuffer,RecvBuffer,Ret);
        Ret = send(QemuSocket, SendBuffer, (int)strlen(SendBuffer), 0);
        if ( Ret == 0 || Ret == -1 )
        {
            pthread_mutex_lock(mut);
            cout<<"gdb break!"<<endl;
            pthread_mutex_unlock(mut);
            break;
        }
        pthread_mutex_lock(mut);
        cout<<"Message from gdb :"<<RecvBuffer<<endl;
        pthread_mutex_unlock(mut);
    }
        // pthread_create(&ntid, NULL, ClientThread, (void*)(long)CientSocket);

    // }
    // pthread_join(ntid,NULL);
    return NULL;
}

void *client_for_qemu(void* lpParameter){
    int CientSocket;
    struct sockaddr_in ServerAddr;
    int Ret = 0;
    int AddrLen = 0;
    char RecvBuffer[PATH_MAX];
    char SendBuffer[PATH_MAX];

    //Create Socket
    CientSocket = socket(AF_INET, SOCK_STREAM, 0);
    QemuSocket = CientSocket;
    if ( CientSocket == -1 )
    {
        // cout<<"Create Socket Failed::"<<GetLastError()<<endl;
        return NULL;
    }

    ServerAddr.sin_family = AF_INET;
    ServerAddr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    ServerAddr.sin_port = htons(QEMUPORT);
    memset(ServerAddr.sin_zero, 0x00, 8);
    Ret = connect(CientSocket,(struct sockaddr*)&ServerAddr, sizeof(ServerAddr));
    if ( Ret == -1 )
    {
        // cout<<"Connect Error::"<<GetLastError()<<endl;
        return NULL;
    }
    else
    {
        pthread_mutex_lock(mut);
        cout<<"Connection qemu succeeds!"<<endl;
        pthread_mutex_unlock(mut);
    }

    while ( true )
    {
        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
        Ret = recv(CientSocket, RecvBuffer, PATH_MAX, 0);
        if ( Ret == 0 || Ret == -1 )
        {
            pthread_mutex_lock(mut);
            cout<<"qemu break!"<<endl;
            pthread_mutex_unlock(mut);
            break;
        }
        memset(SendBuffer, 0x00, sizeof(SendBuffer));
        strncpy(SendBuffer,RecvBuffer,Ret);
        Ret = send(GdbSocket, SendBuffer, (int)strlen(SendBuffer), 0);
        if ( Ret == 0 || Ret == -1 )
        {
            pthread_mutex_lock(mut);
            cout<<"qemu break!"<<endl;
            pthread_mutex_unlock(mut);
            break;
        }
        pthread_mutex_lock(mut);
        cout<<"Message from qemu:"<<RecvBuffer<<endl;
        pthread_mutex_unlock(mut);
    }

    close(CientSocket);
    return NULL;
}

int main(int argc, char* argv[])
{ 
    pthread_t id0,id1;
    pthread_mutex_init(mut,NULL);
    pthread_create(&id0, NULL, server_for_gdb, (void*)(long)0);
    pthread_create(&id1, NULL, client_for_qemu, (void*)(long)0);
    pthread_join(id0,NULL);
    pthread_join(id1,NULL);
    return 0;
}
