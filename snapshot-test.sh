swiftc knight.playground/Sources/knight.swift main.swift -o knight

./knight 3 4 > test.txt

if diff test.txt snapshot34.txt 
then echo "ok"
else echo "fail"
fi

rm test.txt
