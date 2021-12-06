#include <algorithm>
#include <cstdint>
#include <numeric>
#include <iostream>

consteval auto countFish(unsigned int day)
{
    unsigned char input[] = {
        //3,4,3,1,2
#include "in"
    };

    uint64_t counts[9];
    std::fill(counts, counts + 9, 0);
    for (int i = 0; i < sizeof(input); ++i)
        ++counts[input[i]];

    for (int i = 0; i < day; ++i) {
        std::rotate(counts, counts + 1, counts + 9);
        counts[6] += counts[8];
    }

    return std::accumulate(counts, counts + 9, 0ull);
}

int main()
{
    std::cout << "80: " << countFish(80) << std::endl;
    std::cout << "256: " << countFish(256) << std::endl;
    return 0;
}

