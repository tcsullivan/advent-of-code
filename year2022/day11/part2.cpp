#include <array>
#include <cstdint>
#include <iostream>
#include <string>

int main()
{
    uint64_t monkeys[10][100];
    int ms[10];
    int ic[10] = {};
    int idx = -1;
    std::string im;

    do {
        std::string line;
        std::getline(std::cin, line);

        if (!std::cin.eof()) {
            if (line.starts_with("Monkey")) {
                ++idx;
                std::cout << "Monkey " << idx << "..." << std::endl;
            } else if (line.starts_with("  St")) {
                auto f = line.find_first_of("0123456789");
                line = line.substr(f);

                im += (char)stoi(line);
                
                auto g = line.find(',');
                while (g != std::string::npos) {
                    line = line.substr(g);
                    auto f = line.find_first_of("0123456789");
                    line = line.substr(f);

                    im += (char)stoi(line);
                    g = line.find(',');
                }
            } else if (line.starts_with("  Op")) {
                auto f = line.find('=');
                char o = line[f + 6];
                char v = line[f + 8] == 'o' ? 0 : stoi(line.substr(f + 8));
                im = std::string() + v + o + im;
            } else if (!line.empty()) {
                auto f = line.find_first_of("0123456789");
                line = line.substr(f);

                im = std::string() + (char)stoi(line) + im; 
            } else {
                int i = 0;
                for (auto c : im)
                    monkeys[idx][i++] = c;
                ms[idx] = im.size();
                im.clear();
            }
        }
    } while (!std::cin.eof());

    uint64_t supermod = 1;
    for (int i = 0; i <= idx; ++i)
        supermod *= monkeys[i][2];

    for (int R = 0; R < 10000; ++R) {

    for (int i = 0; i <= idx; ++i) {
        auto s = monkeys[i];
        for (int j = 5; j < ms[i]; ++j) {
            auto worry = s[j] % supermod;

            auto o = s[3] != 0 ? s[3] : worry;
            if (s[4] == '*')
                worry = worry * o;
            if (s[4] == '+')
                worry += o;

            //worry /= 3;

            auto d = worry / s[2];
            auto k = worry == d * s[2] ? s[1] : s[0];
            monkeys[k][ms[k]++] = worry;
        }
        ic[i] += ms[i] - 5;
        ms[i] = 5;
    }

    }

    for (int q = 0; q <= idx; ++q) {
        std::cout << ic[q] << std::endl;
    }

    return 0;
}

