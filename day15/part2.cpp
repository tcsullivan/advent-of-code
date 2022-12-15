#include <cstdio>
#include <iostream>
#include <string>
#include <vector>

struct Sensor
{
    long x, y, power;

    Sensor(long xx, long yy, long pp = 0):
        x(xx), y(yy), power(pp) {}
};

std::vector<Sensor> sensors;

bool isDistressBeacon(const Sensor& c)
{
    if (c.x < 0 || c.x > 4000000 || c.y < 0 || c.y > 4000000)
        return false;

    bool found = true;
    uint64_t freq = 0;

    for (auto& s : sensors) {
        auto dist = std::abs(c.x - s.x) + std::abs(c.y - s.y);
        if (dist <= s.power) {
            found = false;
            break;
        }
    }

    return found;
}

int main()
{
    std::string line;
    std::getline(std::cin, line);
    for (; !std::cin.eof(); std::getline(std::cin, line)) {
        long px, py, bx, by;
        sscanf(line.c_str(),
               "Sensor at x=%ld, y=%ld: closest beacon is at x=%ld, y=%ld",
               &px, &py, &bx, &by);

        long power = std::abs(px - bx) + std::abs(py - by);
        sensors.emplace_back(px, py, power);
    }

    for (auto& s : sensors) {
        for (long q = 0; q <= (s.power + 1) * 2; ++q) {
            auto x = s.x + q - s.power - 1;
            auto y = s.y + q;
            if (isDistressBeacon(Sensor(x, y))) {
                std::cout << x * 4000000 + y << std::endl;
                return 0;
            }

            y -= q * 2;
            if (isDistressBeacon(Sensor(x, y))) {
                std::cout << x * 4000000 + y << std::endl;
                return 0;
            }
        }
    }

    return 0;
}

