#include <cstdio>
#include <iostream>
#include <set>
#include <string>

constexpr long Y = 2000000;

int main()
{
    std::set<int> xs;
    std::set<int> bs;
    long px, py, bx, by;

    do {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        auto a = sscanf(line.c_str(),
            "Sensor at x=%ld, y=%ld: closest beacon is at x=%ld, y=%ld",
            &px, &py, &bx, &by);

        std::cout << px << ' ' << py << ' ' << bx << ' ' << by;

        if (by == Y)
            bs.insert(bx);

        long ic = std::abs(px - bx) + std::abs(py - by);

        if (Y < py - ic || Y > py + ic)
            continue;

        long spr = (ic - std::abs(py - Y));
        for (long j = 0; j <= spr; ++j) {
            xs.insert(px + j);
            xs.insert(px - j);
        }

        std::cout << " -> " << xs.size() << std::endl;
    } while (1);

    for (auto& b : bs)
        xs.erase(b);

    std::cout << "Part 1: " << xs.size() << std::endl;

    return 0;
}

