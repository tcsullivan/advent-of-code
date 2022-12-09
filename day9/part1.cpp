#include <algorithm>
#include <iostream>
#include <list>
#include <string>
#include <tuple>
#include <vector>

int main()
{
    std::vector<std::pair<char, int>> steps;

    while (1) {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        steps.emplace_back(line.front(), stoi(line.substr(2)));
    }

    int hx = 0, hy = 0, tx = 0, ty = 0;
    std::list<std::pair<int, int>> locs;
    locs.emplace_back(0, 0);

    for (const auto& [dir, count] : steps) {
        for (int i = 0; i < count; ++i) {
            //std::cout << hx << ", " << hy << "    " << tx << ", " << ty << std::endl;

            if (dir == 'U')
                ++hy;
            else if (dir == 'D')
                --hy;
            else if (dir == 'R')
                ++hx;
            else if (dir == 'L')
                --hx;

            if (std::abs(hx - tx) > 1 || std::abs(hy - ty) > 1) {
                if (hx != tx)
                    tx += hx > tx ? 1 : -1;
                if (hy != ty)
                    ty += hy > ty ? 1 : -1;

                if (std::find(locs.cbegin(), locs.cend(), std::pair{tx, ty}) == locs.cend()) {
                    locs.emplace_back(tx, ty);
                }
            }
        }
    }

    std::cout << locs.size() << std::endl;

    return 0;
}

