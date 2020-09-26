#!/bin/bash

# 1:
cd $HOME
if [[ ! -e test ]]; then
	mkdir test
fi

# 2, 3
numberOfDirectories=0
numberOfHiddenFiles=0

for str in $(ls -a /etc)
do
	if [[ -d /etc/$str ]]; then
		echo "$str/"
	elif [[ -f /etc/$str ]]; then
		echo "$str"
	else
		echo "Nothing"
	fi
done > $HOME/test/list

# 3
ls -d /etc/*/ | wc -w >> $HOME/test/list
ls -A /etc/ | grep -E "^\..*" | wc -w >> $HOME/test/list

# 4
if [[ ! -e $HOME/test/links ]]; then
	mkdir $HOME/test/links
fi

# 5
if [[ ! -e $HOME/test/links/list_hlink ]]; then
	ln $HOME/test/list $HOME/test/links/list_hlink
fi

# 6
if [[ ! -e $HOME/test/links/list_slink ]]; then
	ln -s $HOME/test/list $HOME/test/links/list_slink
fi

# 7
echo "#7"
echo "Number of hard links to list_hlink"
ls -l $HOME/test/links/list_hlink | awk '{ print $2 }'
echo "Number of hard links to list"
ls -l $HOME/test/list | awk '{ print $2 }'
echo "Number of hard links to list_slink"
ls -l $HOME/test/links/list_slink | awk '{ print $2 }'

# 8
wc $HOME/test/list | awk '{ print $1 }' >> $HOME/test/links/list_hlink

# 9
echo "#9"
cmp -s $HOME/test/links/list_hlink $HOME/test/links/list_slink && echo YES

# 10
echo "#10"
mv $HOME/test/list $HOME/test/list1

# 11
echo "#11"
cmp -s $HOME/test/links/list_hlink $HOME/test/links/list_slink && echo YES

# 12
echo "#12"
if [[ ! -e $HOME/list1 ]]; then
	ln $HOME/test/links/list_hlink $HOME/list1
fi

#13
find /etc -type f -name *.conf > $HOME/list_conf

#14
find /etc -type d -name *.d > $HOME/list_d

#15
cat $HOME/list_conf > $HOME/list_conf_d
cat $HOME/list_d >> $HOME/list_conf_d

#16
cd $HOME/test
if [[ ! -e .sub ]]; then
	mkdir .sub
fi

#17
cp $HOME/list_conf_d $HOME/test/.sub

#18
cp -b $HOME/list_conf_d $HOME/test/.sub

#19
echo "#19"
ls -aR $HOME/test

#20
man man > $HOME/man.txt

#21
cd $HOME
if [[ ! -e man_parts ]]; then
	mkdir man_parts
fi
cd man_parts
split -b 1k ../man.txt

#22
if [[ ! -e $HOME/man.dir ]]; then
	mkdir $HOME/man.dir
fi

#23
mv $HOME/man_parts/x* $HOME/man.dir

#24
cat $HOME/man.dir/x?? > $HOME/man.dir/man.txt

#25
echo "#25"
cmp -s $HOME/man.txt $HOME/man.dir/man.txt && echo YES

#26
sed -i '1s/^/Hello World! /' $HOME/man.txt
echo "Goodbye!" >> $HOME/man.txt

#27
diff -u $HOME/man.txt $HOME/man.dir/man.txt > $HOME/man_difference

#28
mv $HOME/man_difference $HOME/man.dir

#29
echo "#29"
patch $HOME/man.dir/man.txt < $HOME/man.dir/man_difference

#30
echo "#30"
cmp -s $HOME/man.txt $HOME/man.dir/man.txt && echo YES
