#include <algorithm>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>

int main()
{
    std::vector<std::pair<char, int>> steps;
    std::vector<int> hashes (10000, 0);

    while (1) {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        steps.emplace_back(line.front(), stoi(line.substr(2)));
    }

    int hx = 0, hy = 0, tx = 0, ty = 0;

    for (const auto& [dir, count] : steps) {
        for (int i = 0; i < count; ++i) {
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

                int hash = tx * 1000 + ty;
                for (int i = 0; i < hashes.size(); ++i) {
                    if (hashes[i] == 0) {
                        hashes[i] = hash;
                        break;
                    } else if (hashes[i] == hash) {
                        break;
                    }
                }
            }
        }
    }

    int count = 0;
    for (int i = 0; i < hashes.size(); ++i) {
        ++count;
        if (hashes[i] == 0)
            break;
    }
    std::cout << count << std::endl;

    return 0;
}

