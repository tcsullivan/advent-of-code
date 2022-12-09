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

    std::vector<std::pair<int, int>> knots (10, {0, 0});
    std::list<std::pair<int, int>> locs;
    locs.emplace_back(0, 0);

    for (const auto& [dir, count] : steps) {
        for (int i = 0; i < count; ++i) {
            auto& [x0, y0] = knots[0];

            if (dir == 'U')
                ++y0;
            else if (dir == 'D')
                --y0;
            else if (dir == 'R')
                ++x0;
            else if (dir == 'L')
                --x0;

            for (int j = 1; j < knots.size(); ++j) {
                auto& [hx, hy] = knots[j - 1];
                auto& [tx, ty] = knots[j];

                if (std::abs(hx - tx) > 1 || std::abs(hy - ty) > 1) {
                    if (hx != tx)
                        tx += hx > tx ? 1 : -1;
                    if (hy != ty)
                        ty += hy > ty ? 1 : -1;
                }

                if (std::find(locs.cbegin(), locs.cend(), knots.back()) == locs.cend())
                    locs.emplace_back(knots.back());
            }
        }
    }

    std::cout << locs.size() << std::endl;

    return 0;
}

