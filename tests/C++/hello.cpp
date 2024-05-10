/*
Test binary.
*/
#include <iostream>
#include <pthread.h>
#include <atomic>

void printCompilerInfo()
{
// Compiler info
#ifdef __clang__
    std::cout << "Compiler: Clang " << __clang_major__ << "." << __clang_minor__ << "." << __clang_patchlevel__ <<  "\n";
#elif __GNUC__
    std::cout << "Compiler: gcc " << __GNUC__ << '.' << __GNUC_MINOR__ << '.' << __GNUC_PATCHLEVEL__ << "\n";
#else
    std::cout << "Compiler: Unknown\n";
#endif

// OS info
#ifdef __linux__
    std::cout << "OS: Linux\n";
#elif __APPLE__
    std::cout << "OS: macOS\n";
#else
    std::cout << "OS: Unknown\n";
#endif

// Sys arch info
#ifdef __x86_64__
    std::cout << "Arch: x86_64\n";
#elif __aarch64__
    std::cout << "Arch: aarch64\n";
#else
    std::cout << "Arch: Unknown\n";
#endif

    std::cout << "C++ standard: " << __cplusplus << "\n";
}

void *threadFunction(void *arg) {
    // Perform thread tasks here...
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

    {   // System library pthread works
        pthread_t thread_id;
        pthread_create(&thread_id, NULL, threadFunction, NULL);
        pthread_join(thread_id, NULL);
    }

    {   // libunwind works
        try
        {
            // iWantThrow();
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
        }
         
    }

    std::atomic_int a(0);
    std::cout << a.load() << std::endl;

    return 0;
}
