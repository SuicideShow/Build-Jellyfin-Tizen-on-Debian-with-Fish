# Build Jellyfin Tizen on Debian with Fish <><
Step by Step Guide for first time setup and fish function for update easy build process.

Main Repo here: https://github.com/jellyfin/jellyfin-tizen

-------------------------------------------------

# How to Build Jellyfin for Samsung SmartTV (Tizen)

# Prerequsities:
* Download Tizen Studio <https://developer.tizen.org/development/tizen-studio/download>
* install __git__
* install __NVM__ to get __Node.js 20 LTS (Iron)__ and __npm (9.6.4)__
  
  (bash: use nvm <https://github.com/nvm-sh/nvm>)
  
  (fish: use nvm.fish plugin <https://github.com/jorgebucaran/nvm.fish>)

* Enable Developer Mode at TV:
  
  Go to "Apps" and press "12345". On latest Firmware its Home > Apps > App Settings (at the bottom).
  
  Enter IP of the PC from which you want to send the Tizen App.
  
  Restart TV and check back in "Apps". It should say (Developer Mode) at top.

_______________________________________________________________________________________________________________________________________

# Install Tizen Studio
* `$ ./web-ide_Tizen_Studio_*.*_ubuntu-64.bin`
  
Open Package Manager after installation is done and install the following packages:

        Main SDK .......> Tizen SDK tool > Baseline SDK > Certificate Manager
        Main SDK .......> Tizen SDK tool > Baseline SDK > Emulator Manager
        Main SDK .......> Tizen SDK tool > Web CLI
        Main SDK .......> Tizen SDK tool > Web IDE
        Extension SDK ..> Extras > Samsung Certificate Extension

Default installation folder is: /home/user/tizen-studio. Tools are located at /home/user/tizen-studio/tools.


# Add Tizen to your $PATH:
```
Bash: $ export PATH=$PATH:$HOME/tizen-studio/tools/ide/bin
Bash: $ export PATH=$PATH:$HOME/tizen-studio/tools/device-manager/bin
Bash: $ export PATH=$PATH:$HOME/tizen-studio/tools/certificate-manager
Fish: $ fish_add_path /home/user/tizen-studio/tools/ide/bin
Fish: $ fish_add_path /home/user/tizen-studio/tools/device-manager/bin
Fish: $ fish_add_path /home/user/tizen-studio/tools/certificate-manager
```

# Start the Tizen Device Manager:
 `$ cd /home/user/tizen-studio/tools/device-manager/bin` *not needed if already in PATH*
 
 `$ ./device-manager`

Add a new device by clicking on the **Remote Device Manager** button and then the ＋ icon.

Give your TV a name and enter your TV's IP address.

Toggle the connection toggle switch in the device list and see if you're able to connect.

**Note: If not possible to connect to TV, Unplug the TV and wait 1min, then try again.**


# Obtain a Tizen distributor certificate:
With your device in the device manager, you can now generate a new distributor certificate to sign your custom app.

Start the Tizen Certificate Manager.

 `$ cd /home/user/tizen-studio/tools/certificate-manager` *not needed if already in PATH*
 
 `$ ./certificate-manager`

There are 2 ways, Samsung Certificate or Tizen Certificate.
__First time need to be the Samsung way, after that for updates its possible to use the Tizen way.__

## Samsung way:
__NOTE:__ If using an old Author+Certificate first copy it into /home/user/SamsungCertificate

Click on the ＋ icon to create a new certificate. Select __Samsung__ as the certificate type. Select __TV__ as the device type.

Give your certificate a profile name. Create a new author certificate with your name and password.

Next, in order to get your distributor certificate signed, you will be prompted to log in to your Samsung account.

Next, your Distributor certificate should list your device's DUID.

If you added your device in the device manager, this should have been automatically populated for you.

With the distributor certificate created, you may now compile Jellyfin and sign the package to work with your TV.

## Tizen way:
Click on the ＋ icon to create a new certificate. Select __Tizen__ as the certificate type.

Select a Profile name, Create or Load Author. Select Option 1 and modify depending on your TV. Finish.

_______________________________________________________________________________________________________________________________________

# Download & Build Jellyfin:
Clone Jellyfin-Web and Jellyfin-Tizen repo

 `$ git clone -b release-10.10.z https://github.com/jellyfin/jellyfin-web.git && git clone https://github.com/jellyfin/jellyfin-tizen.git`
 
 `$ nvm install lts/iron`
 
 `$ cd jellyfin-web`
 
 `$ npm ci --no-audit`
 
 `$ USE_SYSTEM_FONTS=1 npm run build:production`
 
You should get jellyfin-web/dist/ directory.

 `$ cd ../jellyfin-tizen`
 
 `$ JELLYFIN_WEB_DIR=../jellyfin-web/dist npm ci --no-audit`
 
You should get jellyfin-tizen/www/ directory.


# Build Widget:
Stay in jellyfin-tizen folder from prior step.

 `$ tizen build-web -e ".*" -e gulpfile.js -e README.md -e "node_modules/*" -e "package*.json" -e "yarn.lock"`
 
 `$ tizen package -t wgt -o . -- .buildResult`
 
You should get __Jellyfin.wgt__.


# Install on TV:
Depending on the Certificate you chose select a method below to install the Widget on your TV.

## Samsung way:
- Start TV
- Go to Device Manager, connect to your TV and right click on your TV. Click on __Permit to install applications__.

 `$ tizen install -n Jellyfin.wgt`

## Tizen way:
- Start TV
- If you closed Device Manager earlier, open again and Connect to TV.
  
 `$ tizen install -n Jellyfin.wgt`


# Note
If the installation fails with "Author certificate not match" either use the old Author again or uninstall Jellyfin from the TV
_______________________________________________________________________________________________________________________________________

# Uninstallting Tizen Studio:
 `$ cd tizen-studio/package-manager/`
 
 `$ ./package-manager-cli.bin uninstall --all`
 
or

 `$ ./package-manager-uninstaller.bin`

## Remove $PATH from list:
 `$ echo $PATH`
 
Order is counted from 1 to ? change x with number of postion.

 `$ set -e PATH[x]`

_______________________________________________________________________________________________________________________________________
