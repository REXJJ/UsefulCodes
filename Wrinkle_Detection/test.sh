t=$(find /home/rex/Desktop/Images/SheetImages/Bad -name '*.jpeg' -o -name '*.jpg' -o -name '*.png')
for x in $t
do
./build/prewitt $x
done