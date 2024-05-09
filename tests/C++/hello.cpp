/*
Test binary.
*/
#include <iostream>
#include <pthread.h>

void printCompilerInfo()
{
#ifdef __clang__
    std::cout << "Clang version: " << __clang_major__ << "." << __clang_minor__ << "." << __clang_patchlevel__ <<  "\n";
#elif __GNUC__
    std::cout << "gcc version: " << __GNUC__ << '.' << __GNUC_MINOR__ << '.' << __GNUC_PATCHLEVEL__ << "\n";
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

    return 0;
}
