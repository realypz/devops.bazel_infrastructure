/*
Test binary.
*/
#include <atomic>
#include <iostream>
#include <pthread.h>

#include "lib/sys_info.h"

void* threadFunction(void* arg)
{
    // Perform thread tasks here...
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-vararg)
    printf("Thread is running...\n");
    return NULL;
}

void iWantThrow()
{
    throw std::runtime_error("I want to throw!");
}

int main()
{
    printCompilerInfo();

    { // System library pthread works
        // NOLINTNEXTLINE(cppcoreguidelines-init-variables)
        pthread_t thread_id;
        pthread_create(&thread_id, NULL, threadFunction, NULL);
        pthread_join(thread_id, NULL);
    }

    { // libunwind works
        try
        {
            iWantThrow();
        }
        catch (const std::exception& e)
        {
            std::cerr << e.what() << '\n';
        }
    }

    std::atomic_int a(0);
    std::cout << a.load() << "\n";

    return 0;
}
