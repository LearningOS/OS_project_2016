//Client.cpp
#include <iostream>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>

using namespace std;

#define  PORT 4000
#define  IP_ADDRESS "127.0.0.1"


int main(int argc, char* argv[])
{
    int CientSocket;
    struct sockaddr_in ServerAddr;
    int Ret = 0;
    int AddrLen = 0;
    char SendBuffer[PATH_MAX];

    //Create Socket
    CientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if ( CientSocket == -1 )
    {
        // cout<<"Create Socket Failed::"<<GetLastError()<<endl;
        return -1;
    }

    ServerAddr.sin_family = AF_INET;
    ServerAddr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    ServerAddr.sin_port = htons(PORT);
    memset(ServerAddr.sin_zero, 0x00, 8);
    Ret = connect(CientSocket,(struct sockaddr*)&ServerAddr, sizeof(ServerAddr));
    if ( Ret == -1 )
    {
        // cout<<"Connect Error::"<<GetLastError()<<endl;
        return -1;
    }
    else
    {
        cout<<"Connection succeeds!"<<endl;
    }

    while ( true )
    {
        cin.getline(SendBuffer, sizeof(SendBuffer));
        Ret = send(CientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
        if ( Ret == -1 )
        {
            // cout<<"Send Info Error::"<<GetLastError()<<endl;
            break;
        }
    }

    close(CientSocket);

    return 0;
}
