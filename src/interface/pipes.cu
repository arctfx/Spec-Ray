#include "pipes.cuh"

DWORD WINAPI Server::ThreadFunc(void *data) {
    auto that = (Server *) data;
    that->hPipe = CreateNamedPipe(TEXT("\\\\.\\pipe\\specray"),
                                  PIPE_ACCESS_DUPLEX,
                                  PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE |
                                  PIPE_WAIT,   // FILE_FLAG_FIRST_PIPE_INSTANCE is not needed but forces CreateNamedPipe(..) to fail if the pipe already exists...
                                  1,
                                  1024 * 16,
                                  1024 * 16,
                                  10000, //NMPWAIT_USE_DEFAULT_WAIT,
                                  NULL);
    while (that->hPipe != INVALID_HANDLE_VALUE) {
        if (ConnectNamedPipe(that->hPipe, NULL) != FALSE)   // wait for someone to connect to the pipe
        {
//            printf("Connected\n");
            that->SendData();

//            char mssg[1024] = {'1', '1', '\0'};
//            //std::cin >> mssg;
//            LPTSTR lpvMessage = TEXT(mssg);
//            BOOL fSuccess = WriteFile(that->hPipe,
//                                      lpvMessage,
//                                      (lstrlen(lpvMessage) + 1) * sizeof(TCHAR),
//                                      &that->cbRet,
//                                      nullptr);
//            if (!fSuccess) {
//                _tprintf(TEXT("WriteFile to pipe failed. GLE=%d\n"), GetLastError());
////                return -1;
//            } else {
//                printf("\nMessage sent to server, receiving reply as follows:\n");
//            }

//            while (ReadFile(that->hPipe, that->buffer, sizeof(buffer) - 1, &that->dwRead, NULL) != FALSE) {
//                /* add terminating zero */
//                that->buffer[that->dwRead] = '\0';
//
//                /* do something with data in buffer */
//                printf("%s", that->buffer);
//            }
        }

        DisconnectNamedPipe(that->hPipe);
    }
    printf("Pipe disconnected!\n");
    return 0;
}


Server::Server() {
    thread = CreateThread(nullptr,
                          0,
                          ThreadFunc,
                          this,
                          0,
                          nullptr);
}

Server::~Server() {
    WaitForSingleObject(thread, INFINITE);
    CloseHandle(thread);
}

bool Server::SendData() {
    std::unique_lock<std::mutex> lock(mutex);
    if (queue.empty()) {
        lock.unlock();
        return false;
    }
    LPTSTR lpvMessage = TEXT(queue.front().buffer);
    queue.pop();
    lock.unlock();

    BOOL fSuccess = WriteFile(hPipe,
                              lpvMessage,
                              (lstrlen(lpvMessage) + 1) * sizeof(TCHAR),
                              &cbRet,
                              nullptr);
    if (!fSuccess) {
        _tprintf(TEXT("WriteFile to pipe failed. GLE=%d\n"), GetLastError());
        return false;
    } else {
//        printf("\nMessage sent to server, receiving reply as follows:\n");
        std::cout << lpvMessage << '\n';
    }
    return true;
}

void Server::PushData(const Data &_data) {
    std::unique_lock<std::mutex> lock(mutex);
    queue.push(_data);
    lock.unlock();
}
