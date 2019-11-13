#!/data/data/com.termux/files/usr/bin/bash
pkg install wget curl pv proot tar pulseaudio dos2unix -y
#Variables we need. Script is modular, change below variables to install different distro's
name="Debian XFCE Modded OS"
distro=debian
folder=$distro-fs
url="https://andronix.online:8000/download?token=$token"
maxsize=1401185636
tarball=debian_mod.tar.xz
echo " "
echo " "
echo "-----------------------------------------------------------"
echo "|  NOTE THAT ALL THE PREVIOUS DEBIAN DATA WILL BE ERASED  |"
echo "-----------------------------------------------------------"
echo "If you want to keep your old $distro press Ctrl - C now!! "
echo -n "5. "
sleep 1
echo -n "4. "
sleep 1
echo -n "3. "
sleep 1
echo -n "2. "
sleep 1 
echo -n "1. "
sleep 1 
echo "Proceeding with installation"
echo  "Allow the Storage permission to termux"
echo " "
sleep 2
termux-setup-storage
clear
echo "Downloading and extracting $name"
echo " "

#Creating folders we need
mkdir -p $distro-binds $folder

#Performing a check for online or offline install
check=${token:-1}
if [ "$check" -eq "1" ] > /dev/null 2>&1; then
  pv $tarball | proot --link2symlink tar -Jxf - -C $folder || :
else
  wget -qO- --tries=100 -c $url | pv -s $maxsize | proot --link2symlink tar -Jxf - -C $folder || :
fi

echo "Checking for file integrity"

FILE=start-$distro.sh
if test -f "$FILE"; then
    echo "Boot script present"
    echo " "
fi

FD=$folder
if [ -d "$FD" ]; then
  echo "Boot container present...Files unchecked"
  echo " "
fi

UFD=$distro-binds
if [ -d "$UFD" ]; then
  echo "Sub-Boot container present"
fi

bin=start-$distro.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
pulseaudio -k >>/dev/null 2>&1
pulseaudio --start >>/dev/null 2>&1
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A $distro-binds)" ]; then
    for f in $distro-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b $folder/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to /
#command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=en_US.UTF-8"
command+=" LC_ALL=C"
command+=" LANGUAGE=en_US"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "making $bin executable"
chmod +x $bin
echo "Patching the boot script"
rm -rf ~/andronix-fs/usr/share/andronix/firstrun
wget https://andronixos.sfo2.digitaloceanspaces.com/ModdedV2/firstrun -P ~/andronix-fs/usr/share/andronix/


echo "-----------------------------------------------------------"
echo "|   Enabling Audio support in Termux and configuring it   |"
echo "-----------------------------------------------------------"

if grep -q "anonymous" ~/../usr/etc/pulse/default.pa
then
    sed -i '/anonymous/d' ~/../usr/etc/pulse/default.pa
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1>" >> ~/../usr/etc/pulse/default.pa
else
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1>" >> ~/../usr/etc/pulse/default.pa
fi

if grep -q "exit-idle" ~/../usr/etc/pulse/daemon.conf
then
    sed -i '/exit-idle/d' ~/../usr/etc/pulse/daemon.conf
    echo "exit-idle-time = 180" >> ~/../usr/etc/pulse/daemon.conf
    echo "modified timeout to 180 seconds"
else
    echo "exit-idle-time = 180" >> ~/../usr/etc/pulse/daemon.conf
    echo "modified timeout to 180 seconds"
fi

clear
echo "Insrallation Finished "
echo "Start $name with command ./start-$distro.sh"
