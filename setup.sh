#!/bin/sh
read -p "Make sure the thumb drive is NOT currently plugged in... Do you wish to continue?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac

#check for prevous installation
if[ -f /usr/share/usbmount]
then
    read -p "This will override your previous installation of usbmount. Do you wish to continue?" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac

echo "Updating..."
sudo apt-get update

echo "Installing dependencies..."
sudo apt-get install usbmount
sudo mkdir /mnt/usbkey

sudo blkid -s UUID -o value > devicesBefore.info
read -p "Insert the thumb drive to become a key now. Press Enter to continue.."
sudo blkid -s UUID -o value > devicesAfter.info

DEVICE_UUID = "$(grep -v -f devicesBefore.info devicesAfter.info)"

sed -i "s/THUMBDRIVEUUID=/THUMBDRIVEUUID=$DEVICE_UUID/g" usbmount

sudo cp usbmount /usr/share/usbmount

##Add Check_For_Key.sh to autorun on boot
sudo chmod +x check_for_key.sh
sudo cp check_for_key.sh /etc/init.d/check_for_key.sh
sudo update-rc.d check_for_key.sh defaults

echo "You must reboot for the changes to take effect."
read -p "Do you wish to reboot now?" yn
    case $yn in
        [Yy]* ) sudo reboot; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
