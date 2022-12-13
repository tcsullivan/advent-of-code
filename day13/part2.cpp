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

int compare(std::string left, std::string right)
{
    int lt = 0, rt = 0;

    while (left.size() != 0 && right.size() != 0) {
        if (left[0] == ']') {
            if (right[0] != ']') {
                return 1;
            }
            if (rt) --rt;
            else right = right.substr(1);
            left = left.substr(1);
        } else if (right[0] == ']') {
            if (left[0] != ']') {
                return 0;
            }
            if (lt) --lt;
            else left = left.substr(1);
            right = right.substr(1);
        } else if (left[0] == '[') {
            if (right[0] != '[')
                ++rt;
            else
                right = right.substr(1);
            left = left.substr(1);
        } else if (right[0] == '[') {
            if (left[0] != '[')
                ++lt;
            else
                left = left.substr(1);
            right = right.substr(1);
        } else {
            int ln = consumeInt(left);
            int rn = consumeInt(right);

            if (ln < rn) {
                return 1;
            } else if (ln > rn) {
                return 0;
            }

            while (rt) {
                if (left[0] != ']') {
                    return 0;
                }

                left = left.substr(1);
                --rt;
            }
            while (lt) {
                if (right[0] != ']') {
                    return 1;
                }

                right = right.substr(1);
                --lt;
            }
        }

        bool lcomma = left[0] == ',';
        if (lcomma) {
            left = left.substr(1);
            if (right[0] != ',') {
                return 0;
            }
        }
        if (right[0] == ',') {
            right = right.substr(1);
            if (!lcomma) {
                return 1;
            }
        }
    }

    if (left.size() == 0 && right.size() == 0)
        return 1;
    else
        return 0;
}

int main()
{
    std::string line;
    int lt2 = 0;
    int lt6 = 0;

    while (1) {
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;
        if (line.empty())
            continue;

        if (compare(line, "[[2]]"))
            lt2++;
        if (compare(line, "[[6]]"))
            lt6++;
    }

    std::cout << "lt2: " << lt2 + 1 << " lt6: " << lt6 + 2 << std::endl;
    std::cout << "product: " << (lt2 + 1) * (lt6 + 2) << std::endl;
}

