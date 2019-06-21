t=$(find ~/Desktop/Images/Wrinkles -name '*.jpeg' -o -name '*.jpg')
for x in $t
do
./build/wrinkle $x
done