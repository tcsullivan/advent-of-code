#include <cctype>
#include <iostream>
#include <map>
#include <string>
#include <vector>

struct Node
{
    std::string left;
    std::string right;
    char op = 0;
    long long n = 0;

    bool solved() const { return left.empty(); }

    bool solve(const auto& tree) {
        const auto& ln = tree.at(left);
        const auto& rn = tree.at(right);

        if (ln.solved() && rn.solved()) {
            switch (op) {
            case '+':
                n = ln.n + rn.n;
                break;
            case '-':
                n = ln.n - rn.n;
                break;
            case '*':
                n = ln.n * rn.n;
                break;
            case '/':
                n = ln.n / rn.n;
                break;
            }

            left.clear();
        }

        return solved();
    }
};

int main()
{
    std::map<std::string, Node> tree;

    while (!std::cin.eof()) {
        std::string line;
        std::getline(std::cin, line);
        if (std::cin.eof())
            break;

        auto split = line.find(':');
        const auto key = line.substr(0, split);
        line = line.substr(split + 2);

        Node node;
        if (isdigit(line.front())) {
            node.n = std::stoll(line);
        } else {
            split = line.find(' ');
            node.left = line.substr(0, split);
            node.op = line.at(split + 1);
            node.right = line.substr(split + 3, 4);
        }

        tree.emplace(key, node);
    }

    bool more = true;
    while (more) {
        more = false;
        for (auto& [k, v] : tree) {
            if (!v.solved())
                more |= !v.solve(tree);
        }
    }

    std::cout << "root: " << tree["root"].n << std::endl;

    return 0;
}

