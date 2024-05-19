#ifndef TESTS_CPP_LIB_FOO_H
#define TESTS_CPP_LIB_FOO_H

class Foo
{
  public:
    Foo(const int x) : x_{x}
    {}

    ~Foo();
    void add(const int a);

  private:
    int x_{0};
};

#endif // TESTS_CPP_LIB_FOO_H
