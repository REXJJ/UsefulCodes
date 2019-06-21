t=$(find ~/Desktop/Images/Threshold -name '*.jpeg' -o -name '*.jpg')
for x in $t
do
./build/myOtsu $x
done