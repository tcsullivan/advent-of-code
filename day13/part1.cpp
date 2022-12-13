#include <iostream>
#include <string>
#include <vector>

int consumeInt(std::string& s)
{
    int n = 0;
    int i;

    for (i = 0; s[i] >= '0' && s[i] <= '9'; ++i)
        n = n * 10 + s[i] - '0';

    s = s.substr(i);
    return n;
}

// 5762 too high
// 5659
// 5632 too low

int main()
{
    std::string left, right;
    std::vector<int> correct;
    int index = 1;

    while (1) {
        std::getline(std::cin, left);
        if (std::cin.eof())
            break;
        std::getline(std::cin, right);
        if (std::cin.eof())
            break;

        int lt = 0, rt = 0;

        std::cout << left << std::endl;
        std::cout << right << std::endl;

        while (left.size() != 0 && right.size() != 0) {
            if (left[0] == ']') {
                if (right[0] != ']') {
                    std::cout << "Left side ran out of items" << std::endl;
                    correct.push_back(index);
                    break;
                }
                if (rt) --rt;
                else right = right.substr(1);
                left = left.substr(1);
            } else if (right[0] == ']') {
                if (left[0] != ']') {
                    std::cout << "Right side ran out of items" << std::endl;
                    break; // incorrect
                }
                if (lt) --lt;
                else left = left.substr(1);
                right = right.substr(1);
            } else if (left[0] == '[') {
                std::cout << "Left side opens" << std::endl;
                if (right[0] != '[')
                    ++rt;
                else
                    right = right.substr(1);
                left = left.substr(1);
            } else if (right[0] == '[') {
                std::cout << "Right side opens" << std::endl;
                if (left[0] != '[')
                    ++lt;
                else
                    left = left.substr(1);
                right = right.substr(1);
            } else {
                int ln = consumeInt(left);
                int rn = consumeInt(right);
                std::cout << "Compare " << ln << " to " << rn << std::endl;

                if (ln < rn) {
                    correct.push_back(index);
                    break;
                } else if (ln > rn) {
                    break;
                }

                int fail = 0;
                while (rt) {
                    if (left[0] != ']') {
                        fail = 1;
                        std::cout << "Right ends early" << std::endl;
                        break;
                    }

                    left = left.substr(1);
                    --rt;
                }
                while (lt) {
                    if (right[0] != ']') {
                        fail = 1;
                        std::cout << "Left ends early" << std::endl;
                        correct.push_back(index);
                        break;
                    }

                    right = right.substr(1);
                    --lt;
                }
                if (fail) break;
            }

            bool lcomma = left[0] == ',';
            if (lcomma) {
                left = left.substr(1);
                if (right[0] != ',') {
                    std::cout << "Right ends early" << std::endl;
                    break;
                }
            }
            if (right[0] == ',') {
                right = right.substr(1);
                if (!lcomma) {
                    std::cout << "Left ends early" << std::endl;
                    correct.push_back(index);
                    break;
                }
            }
        }

        if (left.size() == 0 && right.size() == 0)
            correct.push_back(index);

        if (correct.size() > 0 && correct.back() == index)
            std::cout << "  correct" << std::endl;
        else
            std::cout << std::endl;

        index++;
        std::getline(std::cin, left);
        if (std::cin.eof())
            break;
    }

    int sum = 0;
    for (auto& w : correct)
        sum += w;

    std::cout << "Total corrects: " << sum << std::endl;
}

