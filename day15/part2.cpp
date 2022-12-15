#include <cstdio>
#include <iostream>
#include <string>
#include <vector>

struct Sensor
{
    long x, y, power;

    Sensor(long xx, long yy, long pp):
        x(xx), y(yy), power(pp) {}
};

int main()
{
    std::vector<Sensor> sensors;
    long px, py, bx, by;

    do {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        auto a = sscanf(line.c_str(),
            "Sensor at x=%ld, y=%ld: closest beacon is at x=%ld, y=%ld",
            &px, &py, &bx, &by);

        long power = std::abs(px - bx) + std::abs(py - by);
        sensors.emplace_back(px, py, power);
    } while (1);

    std::cout << "# of sensors: " << sensors.size() << std::endl;

    for (long y = 0; y <= 4000000; ++y) {
        std::cout << "\r        \r" << y;
        fflush(stdout);
        for (long x = 0; x <= 4000000; ++x) {
            bool h = false;

            for (auto& s : sensors) {
                auto dist = std::abs(x - s.x) + std::abs(y - s.y);
                if (dist <= s.power) {
                    long spr = (dist - std::abs(s.y - y));
                    x += spr - std::abs(s.x - x);
                    h = true;
                    break;
                }
            }

            if (!h) {
                std::cout << std::endl << x << ", " << y << std::endl;
                return 0;
            }
        }
    }

    return 0;
}

