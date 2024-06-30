#include "cpp/protobuf/msg.pb.h"

int main(int argc, char* argv[])
{
    msg::Thing thing{};
    thing.set_name("ded");
    thing.set_code(10);

    return 0;
}
