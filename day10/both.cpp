#include <algorithm>
#include <iostream>
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

        int n = line.size() < 6 ? 0 : stoi(line.substr(5));
        steps.emplace_back(line.front(), n);
    }

    int cx = 0;

    int cycle = 1;
    int adding = 0;
    int X = 1;
    int strength = 0;
    for (int i = 0; i < steps.size();) {
        const auto& [ins, n] = steps[i];

        if (abs(X - cx) < 2)
            std::cout << '#';
        else
            std::cout << '.';

        if (++cx == 40) {
            std::cout << std::endl;
            cx = 0;
        }

        ++cycle;

        if (adding != 0) {
            X += adding;
            adding = 0;
            ++i;
        } else if (ins == 'a') {
            adding = n;
        } else if (ins == 'n') {
            ++i;
        }

        if ((cycle - 20) % 40 == 0)
            strength += cycle * X;
    }

    std::cout << "strength: " << strength << std::endl;

    return 0;
}

