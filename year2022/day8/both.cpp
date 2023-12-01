#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

int visible = 0;
std::vector<std::string> map;

bool checkTree(int x, int y)
{
    char c = map[y][x];
    char v;

    // Left check
    v = '0';
    for (int i = 0; i < x; ++i)
        v = std::max(v, map[y][i]);
    if (c > v)
        return true;

    // Right check
    v = '0';
    for (int i = map[y].size() - 1; i > x; --i)
        v = std::max(v, map[y][i]);
    if (c > v)
        return true;

    // North check
    v = '0';
    for (int i = 0; i < y; ++i)
        v = std::max(v, map[i][x]);
    if (c > v)
        return true;

    // South check
    v = '0';
    for (int i = map.size() - 1; i > y; --i)
        v = std::max(v, map[i][x]);

    return c > v;
}

int scenicScore(int x, int y)
{
    char c = map[y][x];
    int n = 0, s = 0, e = 0, w = 0;

    // Left check
    for (int i = x - 1; i >= 0; --i) {
        ++w;
        if (c <= map[y][i])
            break;
    }

    // Right check
    for (int i = x + 1; i < map[y].size(); ++i) {
        ++e;
        if (c <= map[y][i])
            break;
    }

    // North check
    for (int i = y - 1; i >= 0; --i) {
        ++n;
        if (c <= map[i][x])
            break;
    }

    // South check
    for (int i = y + 1; i < map.size(); ++i) {
        ++s;
        if (c <= map[i][x])
            break;
    }

    std::cout << x << ", " << y << ": " << n << ' ' << s << ' ' << e << ' ' << w << std::endl;
    return n * s * e * w;
}

int main()
{
    // Consume entire input into map
    while (!std::cin.eof()) {
        std::string line;
        std::getline(std::cin, line);
        if (!std::cin.eof())
            map.push_back(line);
    }

    visible = 2 * map[0].size() - 4 + 2 * map.size();
    int sx, sy, sc = 0;

    // For each possibly-hidden tree...
    for (int y = 1; y < map.size() - 1; ++y) {
        for (int x = 1; x < map[y].size() - 1; ++x) {
            if (checkTree(x, y))
                ++visible;
            if (int qq = scenicScore(x, y); qq > sc)
                sx = x, sy = y, sc = qq;
        }
    }

    std::cout << visible << std::endl;
    std::cout << sx << ", " << sy << ": " << sc << std::endl;

    return 0;
}
