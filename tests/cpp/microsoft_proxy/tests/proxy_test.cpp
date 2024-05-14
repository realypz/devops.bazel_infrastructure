/*
 bazelisk run --cxxopt="-std=c++20" --cxxopt="--verbose" //tests/cpp/microsoft_proxy:tests
*/
#include "../proxy.h"

#include <gtest/gtest.h>
#include <string_view>

// Specifications of abstraction
namespace spec
{

PRO_DEF_MEMBER_DISPATCH(draw, void(std::ostream& out));
PRO_DEF_MEMBER_DISPATCH(area, double() noexcept);
PRO_DEF_FACADE(Drawable, PRO_MAKE_DISPATCH_PACK(draw, area));

} // namespace spec

// Implementation
class Rectangle
{
  public:
    void draw(std::ostream& out) const
    {
        out << "{Rectangle: width = " << width_ << ", height = " << height_ << "}";
    }

    void SetWidth(double width)
    {
        width_ = width;
    }

    void SetHeight(double height)
    {
        height_ = height;
    }

    double area() const noexcept
    {
        return width_ * height_;
    }

  private:
    double width_;
    double height_;
};

// Client - Consumer
std::string printDrawableToString(pro::proxy<spec::Drawable> p)
{
    std::stringstream result;
    result << "shape = ";
    p.draw(result); // Polymorphic call
    result << ", area = " << p.area(); // Polymorphic call
    return std::move(result).str();
}

// Client - Producer
pro::proxy<spec::Drawable> createRectangleAsDrawable(int width, int height)
{
    Rectangle rect;
    rect.SetWidth(width);
    rect.SetHeight(height);
    return pro::make_proxy<spec::Drawable>(rect);
}

TEST(ProxyTest, test1)
{
    auto p = createRectangleAsDrawable(3, 4);
    constexpr std::string_view expected{"shape = {Rectangle: width = 3, height = 4}, area = 12"};
    const auto actual = printDrawableToString(std::move(p));
    EXPECT_EQ(expected, actual);
}
