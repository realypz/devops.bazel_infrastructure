#ifndef _CPP_MY_HELLO_LIB_FOO_H_
#define _CPP_MY_HELLO_LIB_FOO_H_

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

#endif // _CPP_MY_HELLO_LIB_FOO_H_
