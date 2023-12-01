#include <array>
#include <iostream>
#include <string>
#include <vector>

static const std::array<unsigned int, 5> pieces = {
    0x3C, 0x081C08, 0x10101C, 0x04040404, 0x0C0C
};
static auto next = pieces.begin();
static auto current = *next;
static unsigned int currenty;

static void add(std::vector<unsigned char>& tet);
static bool move(std::vector<unsigned char>& tet, char dir);
static void show(const std::vector<unsigned char>& tet);

int main()
{
    std::vector<unsigned char> tet;
    std::string jet;

    std::getline(std::cin, jet);

    auto j = jet.cbegin();
    for (int i = 0; i < 2022; ++i) {
        add(tet);

        while (move(tet, *j++)) {
            if (tet.back() == 0)
                tet.pop_back();

            if (j >= jet.cend())
                j = jet.cbegin();
        }
    }
    std::cout << tet.size() << std::endl;

    return 0;
}

void add(std::vector<unsigned char>& tet)
{
    tet.push_back(0);
    tet.push_back(0);
    tet.push_back(0);

    current = *next;
    currenty = tet.size();
    for (auto n = current; n; n >>= 8)
        tet.push_back(n);

    if (++next >= pieces.end())
        next = pieces.begin();
}

bool move(std::vector<unsigned char>& tet, char dir)
{
    auto tetcopy = tet;

    if (dir == '<') {
        if ((current & 0x0101) == 0) {
            int i = currenty;
            int shift = 1;
            for (auto n = current; n; n >>= 8) {
                auto t = tet[i] & ~n;
                if (t & (n >> 1)) {
                    shift = 0;
                    tet = tetcopy;
                    break;
                }
                tet[i] = t | n >> 1;
                ++i;
            }

            if (shift)
                current >>= 1;
        }
    } else if (dir == '>') {
        if ((current & 0x4040) == 0) {
            int i = currenty;
            int shift = 1;
            for (auto n = current; n; n >>= 8) {
                auto t = tet[i] & ~n;
                if (t & (n << 1)) {
                    shift = 0;
                    tet = tetcopy;
                    break;
                }
                tet[i] = t | n << 1;
                ++i;
            }

            if (shift)
                current <<= 1;
        }
    } else {
        return false;
    }

    if (currenty == 0)
        return false;

    tetcopy = tet;

    int i = currenty;
    for (auto n = current; n; n >>= 8) {
        if (tet[i - 1] & n) {
            tet = tetcopy;
            return false;
        }

        tet[i] &= ~n;
        tet[i - 1] |= n;
        ++i;
    }
    --currenty;

    return true;
}

void show(const std::vector<unsigned char>& tet)
{
    for (auto it = tet.rbegin(); it != tet.rend(); ++it) {
        for (int i = 0; i < 7; ++i)
            std::cout << ((*it & (1 << i)) ? '@' : '.');
        std::cout << std::endl;
    }

    std::cout << std::endl;
}

