cat input | tr '\n' '+' | sed 's/++/\n/' | bc | sort -n | tail -n 3
# sum the top three with a calculator :)
