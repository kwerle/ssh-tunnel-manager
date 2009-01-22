#!/bin/sh
TARGET='SSH Tunnel Manager'
TYPE=app


args=`getopt bsud $*`
set -- $args
for i
do
	case "$i"
	in
		-b)
			build=1;
			shift;;
		-s)
			stuff=1;
			shift;;
		-u)
			up=1;
			shift;;
		-d)
			dmg=1;
			shift;;
	esac
done

if [ -n "$build" ]
then
	/Developer/tools/agvtool bump -all
	VERSION=`/Developer/tools/agvtool vers -terse`
	TOTAL=`wc -l Info.plist | xargs | cut -d" " -f 1`
	LINE=`grep -n CFBundleVersion Info.plist |cut -d':' -f1`
	head -${LINE} Info.plist > Info.plist.tmp
	echo "	<string>$VERSION</string>" >> Info.plist.tmp	
	TAIL=$(( $TOTAL - $LINE - 1 ))
	tail -${TAIL} Info.plist >> Info.plist.tmp
	mv Info.plist.tmp Info.plist
	xcodebuild -target "$TARGET" -buildstyle Deployment
fi

VERSION=`/Developer/tools/agvtool vers -terse`
HEX=`echo "obase=16; $VERSION"|bc`
FILENAME="build/$TARGET.$TYPE-$HEX"
DMGNAME="DMG/$TARGET.dmg"

if [ -n "$dmg" ]
then
	if [ -f "DMG/$TARGET.dmg" ]; then rm -f "DMG/$TARGET.dmg"; fi
	hdiutil convert -format UDZO -o "DMG/$TARGET.dmg" "DMG/$TARGET-rw.dmg"
fi

if [ -n "$stuff" ]
then
	if [ -n "$dmg" ]
	then
		FN=$DMGNAME
		RES="DMG/$TARGET.dmg"
	else
		FN=$FILENAME
		RES="build/BuiltProducts/$TARGET.$TYPE"
	fi
	if [ -e $FN ]
	then
		rm -f $FN
	fi

	stuff -n $FN "$RES"
fi

if [ -n "$up" ]
then
	
	scp $FILENAME tynsoe@www.tynsoe.org:
	echo http://www.tynsoe.org/`basename $FILENAME`
fi
