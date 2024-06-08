#include <fstream>
#include <Windows.h>
#include <cstdio>
#include <tchar.h>
#include <strsafe.h>
#include <iostream>
#include <mutex>
#include <queue>

#define MAX 1024

void sendData();

// Pixel data
struct Data {

    char buffer[MAX];
};

class Server {
public:
    Server();

    static DWORD WINAPI ThreadFunc(void *);

    ~Server();

    bool SendData();

    void PushData(const Data &);

private:
    HANDLE thread;

    HANDLE hPipe;
    char buffer[1024];
    DWORD dwRead, cbRet;

    std::queue<Data> queue;
    std::mutex mutex;
};

// extern Server server;