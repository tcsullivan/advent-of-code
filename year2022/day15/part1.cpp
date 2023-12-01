#include <bitset>
#include <cstdio>
#include <iostream>
#include <set>
#include <string>

constexpr long Y = 2000000;

int main()
{
    std::bitset<8000000> xs;
    long px, py, bx, by;

    do {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        sscanf(line.c_str(),
               "Sensor at x=%ld, y=%ld: closest beacon is at x=%ld, y=%ld",
               &px, &py, &bx, &by);

        long dist = std::abs(px - bx) + std::abs(py - by);

        if (Y < py - dist || Y > py + dist)
            continue;

        px += 1000000;
        long spr = dist - std::abs(py - Y);
        for (long j = 0; j <= spr; ++j) {
            xs.set(px + j);
            xs.set(px - j);
        }
    } while (1);

    std::cout << "Part 1: " << xs.count() - 1 << std::endl;

    return 0;
}

