# check miui
MIUI=$(getprop ro.miui.ui.version.code)
if [ "$MIUI" -gt 0 ]; then
 abort "- MIUI ROM detected! But if you are really not in MIUI ROM, remove all ro.miui...... system properties first!"
fi

# check android
if [ "$API" -lt 25 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Marshmallow SDK API 25 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# check architecture
ABI=$(getprop ro.product.cpu.abi)
ui_print "- Device platform: $ABI"
if [ "$ABI" == "armeabi" ] || [ "$ABI" == "armeabi-v7a" ]; then
  ARCHM=arm
elif [ "$ABI" == "arm64-v8a" ]; then
  ARCHM=arm64
elif [ "$ABI" == "x86" ]; then
  ARCHM=x86
elif [ "$ABI" == "x86_64" ]; then
  ARCHM=x64
elif [ "$ABI" == "mips" ]; then
  ARCHM=mips
elif [ "$ABI" == "mips64" ]; then
  ARCHM=mips64
else
  ARCHM=unknown
fi

# remove unsupported files
if [ "$ARCHM" == "arm" ]; then
  ui_print "- Deleting arm64 odex file"
  rm -rf $MODPATH/system/framework/oat/arm64
elif [ "$ARCHM" != "arm" ] && [ "$ARCHM" != "arm64" ]; then
  ui_print "- Deleting arm64 & arm odex files"
  rm -rf -R $MODPATH/system/framework/oat
fi

# extract lib
if [ "$ARCHM" != "unknown" ]; then
  ui_print "- Extracting lib"
  unzip -d $MODPATH/system/priv-app/MiMusic -o $MODPATH/system/priv-app/MiMusic/MiMusic.apk lib/$ABI/*
  mv $MODPATH/system/priv-app/MiMusic/lib/$ABI $MODPATH/system/priv-app/MiMusic/lib/$ARCHM
else
  ui_print "- Mi Music doesn't have $ABI lib and may not working properly!"
fi

