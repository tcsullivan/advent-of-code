#include <array>
#include <iostream>
#include <string>

int consumeInt(std::string& s)
{
    int n = 0;
    int i;

    for (i = 0; s[i] >= '0' && s[i] <= '9'; ++i)
        n = n * 10 + s[i] - '0';

    s = s.substr(i);
    return n;
}

int main()
{
    std::array<std::array<char, 480>, 165> map;
    std::string line;

    for (auto& m : map)
        m.fill('.');

    while (1) {
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        auto px = consumeInt(line);
        line = line.substr(1);
        auto py = consumeInt(line);

        while (!line.empty()) {
            line = line.substr(4);
            auto x = consumeInt(line);
            line = line.substr(1);
            auto y = consumeInt(line);

            if (x != px) {
                for (auto i = std::min(x, px); i <= std::max(x, px); ++i)
                    map[y][500 - i + map[y].size() / 2] = '#';
            } else {
                for (auto i = std::min(y, py); i <= std::max(y, py); ++i)
                    map[i][500 - x + map[y].size() / 2] = '#';
            }

            px = x;
            py = y;
        }
    }

    int sands = 0;
    while (map[0][map[0].size() / 2] != '*') {
        ++sands;
        int x = map[0].size() / 2, y = 0;
        while (1) {
            if (y > map.size() - 2) {
                map[y][x] = '*';
                break;
            } else if (map[y + 1][x] == '.') {
                ++y;
            } else if (map[y + 1][x + 1] == '.') {
                ++y, ++x;
            } else if (map[y + 1][x - 1] == '.') {
                ++y, --x;
            } else {
                map[y][x] = '*';
                break;
            }
        }
    }

    for (auto& m : map) {
        for (auto& n : m)
            std::cout << n;
        std::cout << std::endl;
    }

    std::cout << sands << std::endl;

    return 0;
}

