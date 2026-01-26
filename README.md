<!-- MikeCat made this :3 --->
<!-- Thanks so much to the https://www.makeareadme.com/ proyect for helping me in how to make a README for my proyect <3 --->

# Android to Quest - scrcpy
A free and open-source project to view and interact with your Android phone on your Quest VR Headset (or any other device running Android).

"Android to Quest - scrcpy" (atq-scrcpy) creates a direct connection between your Android phone and your Quest without relying on any third-party services, by running [scrcpy](https://github.com/Genymobile/scrcpy) on [Termux](https://github.com/termux/termux-app/) in your Quest, and then displaying your phone screen on [Termux:X11](https://github.com/termux/termux-x11/). 

> DISCLAIMER  
> This project is not affiliated with Meta, Oculus, Xiaomi, Genymobile or any other brand.  
> Use it at your own risk.

## Requirements

### Quest - Free Storage
Around 1GB of free storage is recommended to install all the APKs and Termux Packages needed:
- APK `Termux:X11`: 14.2MB (Universal ver.)
- APK `Termux`: 112MB (Universal .ver)
- Termux PKG `git` (optional): 45MB
- Termux PKG `android-tools`: 22.6MB
- Termux PKG `x11-repo`: 53.2kB
- Termux PKG `termux-x11-nightly`: 4293kB
- Termux PKG `openbox`: 262MB
- Termux PKG `scrcpy`: 101MB

### Quest - Developer Mode
Developer Mode is needed on your Quest in order to be able to sideload all the needed APKs.

To enable this requirement, follow these steps or watch this [simple tutorial from SideQuest](https://www.youtube.com/watch?v=3n1T59v4HTY) to do so.
1. Go to [developers.meta.com](https://developers.meta.com/horizon/manage) (you can also go to the old URL [dashboard.oculus.com](https://dashboard.oculus.com), but nowadays it is only a redirect to the newer URL) and sign in with your Meta Account.
2. Create a "New Organization" with whatever name you want, as long as it isn't already picked (personally, I used my own username). Then accept the "Developer Non-Disclosure Agreement".
3. Verify your account by either setting up a Two-Factor Authentication or by adding your credit card.
4. Open your Meta Horizon App where you have synced your Quest. Make sure to have turned on your headset and connected it to the same network as your phone. Go to `Devices > <Your Quest Headset> > Headset Settings > Developer Settings` and enable `Developer Mode`.

### Android Phone - Developer Mode and USB Debugging
Developer Mode is needed on your Android phone to enable USB Debugging, required by scrcpy to send the scrcpy server from the Quest to the phone, and then being able to copy the screen of your phone to the Quest.

To enable this requirement, follow this steps:
1. Go to `Settings > About this phone`.
2. Look for `Build Number`.
3. Tap on it 7 times, then a message will apear saying "Now you are a developer!".
4. Go back and look for the new menu `Developer Options`, usually found on `System > Developer Options` or `Additional Settings > Developer Options`.
5. Inside this menu, enable `USB Debugging`.

If you have a Xiaomi phone (MIUI/HyperOS), you also need to enable `USB Debugging (Security Options)` in order to be able to control your phone from the Quest. A Xiaomi account is needed to enable this setting. It isn't compulsory to enable this option if you only want to stream your phone's screen into the Quest.

### WiFi Connection
A WiFi Connection is needed between both Android phone and Quest, in order to connect both devices through ADB over TCP/IP. The higher the bandwidth the better quality and smoothness can achieve, so is recommended to use 5G WiFi.

The WiFi network can be the phone's hotspot, meaning you really only need both devices in order funcion!

### Computer with ADB
A computer with ADB (Android Debugger Bridge) installed is needed in order to install all the needed APKs and to restart ADB Daemon (adbd) to listen the debugging conections through TCP/IP on port 5555 of your phone, in order to be able to use scrcpy wirelessly.

## Installation

### APKs
Install on your Quest the following APKs:
- [Termux](https://github.com/termux/termux-app/releases)
- [Termux:X11](https://github.com/termux/termux-x11/releases/tag/nightly)

Use ADB or Sidequest to install the previous APKs:
```
adb -s <QUEST-SERIAL> install <termux.apk>
adb -s <QUEST-SERIAL> install <termux-x11.apk>
```

### Termux
Once installed Termux on your Quest, update packages.
```bash
pkg update && pkg upgrade -y
```
And get the code on your Quest.

Either by using git.
```bash
pkg install git -y
git clone https://github.com/MikeCat2008/android-to-quest-scrcpy.git
```
<!-- Git URL isn't final. idk how is gonna be xD --->

Or by manually installing the `atq-scrcpy.sh` script from this repository to your Quest.

In order to do so, connect your Quest to the computer where you have the script using a USB cable. Allow the computer to explore your files by clicking on the notification that will appear on your Quest. And copy the script from your computer to the folder you want.

Be aware that Termux cannot interact directly with the folder Shared Storage (`/storage/emulated/0`). And in order to be able to run the script, you need to either:
- Allow Termux to interact with your Shared Storage by running the following command and giving permission
```bash
termux-setup-storage
```
- Move the script from the Shared Storage to Termux's Private Storage (`/data/data/com.termux/files/`) by using a file browser that can access those places, like [Material Files](https://github.com/zhanghai/MaterialFiles/). 
<!-- Material Files best Android file browser ever <3 --->

## Usage
Make sure both your Android phone and Quest are connected on the same WiFi network. (Refer to Requirements/WiFi Connection)

Connect your Android to a computer with ADB installed. Then restart ADB Daemon (adbd) to listen the debugging conections through TCP/IP on port 5555 of your phone by running this ADB command.
```
adb -s <PHONE-SERIAL> tcpip 5555
```

Get your phone's IP Address by one of these methods:
- Run this ADB command.
```
adb -s <PHONE-SERIAL> shell
```
- Go to `Settings > WiFi > Connected Network > IP Address`

Unplug your phone from the computer and connect your phone to your Quest by running this ADB command. Replace `X.X.X.X` with your actual IP Address on the network you are connected. If it does not work at first time and you have done all previous steps, try again.
```bash
adb connect X.X.X.X:5555
```

Run the `atq-scrcpy.sh` script in order to launch the scrcpy programm. Termux:X11 should be launching automaticaly with the scrcpy instance displaying your phones's screen.
```bash
chmod +x atq-scrcpy.sh #If first time executing the script
./atq-scrcpy.sh
```

To stop the program, go back to the Termux tab and press `Ctrl+C` in order to send a SIGINT to scrcpy and start the closing sequence. If scrcpy does not stop running by pressing `Ctrl+C` once, do it again.

## Tested on
- Quest VR Headset: Meta Quest 3S 128GB
- Android Phone: [M2103K19PG](https://www.mi.com/es/product/poco-m3-pro-5g/specs/) - Android 13 TP1A.220624.014
- Termux [v0.118.3](https://github.com/termux/termux-app/releases/tag/v0.118.3)
- Termux:X11 [Nightly Release 20251130](https://github.com/termux/termux-x11/releases/tag/nightly)
- scrcpy [v3.3.4](https://github.com/Genymobile/scrcpy/releases/tag/v3.3.4)

## License
This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

License guidance by [choosealicense.com](https://choosealicense.com).

---
> First public GitHub project! :D Learned a lot building this - hope it helps someone else! :3