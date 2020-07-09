for i in $(ls -d  */)
do cd $i 
for file in iPad*.png
do
  cp "$file" "${file/4th/2nd}"
done
cd ..
done
