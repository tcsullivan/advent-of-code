#include <algorithm>
#include <cstdint>
#include <iostream>
#include <list>
#include <map>
#include <string>
#include <string_view>
#include <tuple>

static const std::map<char, const char *> hexToBin = {
    {'0', "0000"}, {'1', "0001"}, {'2', "0010"}, {'3', "0011"},
    {'4', "0100"}, {'5', "0101"}, {'6', "0110"}, {'7', "0111"},
    {'8', "1000"}, {'9', "1001"}, {'A', "1010"}, {'B', "1011"},
    {'C', "1100"}, {'D', "1101"}, {'E', "1110"}, {'F', "1111"}
};

static std::pair<uint64_t, std::string_view> solve(std::string_view packet);

int main(int argc, const char *argv[])
{
    if (argc != 2)
        return -1;

    std::string packetBin;
    std::string packetHex (argv[1]);
    for (char c : packetHex)
        packetBin += hexToBin.at(c);

    std::cout << solve(packetBin).first << std::endl;

    return 0;
}

uint64_t binStrToInt(std::string_view bin)
{
    uint64_t n = 0;

    for (char c : bin) {
        n = n * 2ull;
        if (c == '1')
            ++n;
    }

    return n;
}

bool isEmptyPacket(std::string_view packet)
{
    return packet.empty() ||
           std::all_of(packet.cbegin(), packet.cend(),
                       [](char c) { return c == '0'; });
}

std::pair<uint64_t, std::string_view> solve(std::string_view packet)
{
    // Remove version
    packet = packet.substr(3);
    // Pull type ID
    const auto typeId = packet.substr(0, 3);
    packet = packet.substr(3);
    
    if (typeId == "100") {
        std::string numberStr;
        while (1) {
            const auto chunk = packet.substr(0, 5);
            packet = packet.substr(5);
            numberStr += chunk.substr(1);
            if (chunk.front() == '0')
                break;
        }

        return {binStrToInt(numberStr), isEmptyPacket(packet) ? "" : packet};
    } else {
        const bool isLengthBits = packet.front() == '0';
        packet = packet.substr(1);
        const auto lengthStr = packet.substr(0, isLengthBits ? 15 : 11);
        const auto length = binStrToInt(lengthStr);
        packet = packet.substr(isLengthBits ? 15 : 11);

        std::list<uint64_t> args;
        if (isLengthBits) {
            auto rem = packet.substr(0, length);
            while (1) {
                const auto ret = solve(rem);
                args.emplace_front(ret.first);
                if (ret.second.empty() || isEmptyPacket(ret.second))
                    break;
                rem = ret.second;
            }
            packet = packet.substr(length);
        } else {
            for (uint64_t i = 0; i < length; ++i) {
                const auto ret = solve(packet);
                args.emplace_front(ret.first);
                packet = ret.second;
                if (isEmptyPacket(packet))
                    break;
            }
        }

        uint64_t result;
        if (typeId == "000") {
            result = 0;
            for (auto a : args)
                result += a;
        } else if (typeId == "001") {
            result = 1;
            for (auto a : args)
                result *= a;
        } else if (typeId == "010") {
            result = *std::min_element(args.cbegin(), args.cend());
        } else if (typeId == "011") {
            result = *std::max_element(args.cbegin(), args.cend());
        } else if (typeId == "101") {
            const auto a1 = args.back();
            args.pop_back();
            result = args.back() < a1;
        } else if (typeId == "110") {
            const auto a1 = args.back();
            args.pop_back();
            result = args.back() > a1;
        } else if (typeId == "111") {
            const auto a1 = args.back();
            args.pop_back();
            result = args.back() == a1;
        }

        return {result, isEmptyPacket(packet) ? "" : packet};
    }
}

