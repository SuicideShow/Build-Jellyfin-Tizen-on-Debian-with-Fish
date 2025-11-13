#!/usr/bin/env fish
echo ""
echo "This will install the \"getnewjellytizen.fish\" function into your fish function folder: $HOME/.config/fish/functions/"
echo "Also it will add the necessary tizen folder to your PATH."
echo "After the initial setup of deploying your first version of Jellyfin tizen, were you have already made the Certificate and Author,"
echo "you can use the \"getnewjellytizen\" function to upgrade your Jellyfin Client with 1 command."
echo "The Function will download, build and deploy the new Tizen Client to your TV.Building happens in your Downloads folder, only the Jellyfin.wgt will remain."
echo "If you didnt do the initial setup yet, follow the instructions here: https://github.com/SuicideShow/Build-Jellyfin-Tizen-on-Debian-with-Fish/blob/main/README.md"
echo ""
echo "What is the IP-Adress of your TV? (e.g. 192.168.0.55)"
echo "This is needed to deploy the Jellyfin Client to your TV. IP must be static!"
read -l samsungtvip -P "Enter TV IP: "
or return 1

fish_add_path $HOME/tizen-studio/tools/ide/bin
fish_add_path $HOME/tizen-studio/tools/device-manager/bin
fish_add_path $HOME/tizen-studio/tools/certificate-manager

echo 'function sdb --description "Tizen Tools sdb shortcut"' > $HOME/.config/fish/functions/sdb.fish
echo '$HOME/tizen-studio/tools/sdb $argv' >> $HOME/.config/fish/functions/sdb.fish
echo 'end' >> $HOME/.config/fish/functions/sdb.fish


echo 'function getnewjellytizen --description "Download, build and install Jellyfin on your Samsung TV"' > $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        set w (set_color -o white)' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        set r (set_color -o red)' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        set b (set_color 73c2fb)' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        set n (set_color normal)' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        echo ""' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        echo $w"Which version of Jellyfin-Web do you want to use to build Jellyfin-Tizen?"$n' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        echo "See the latest version number here: "$b"https://github.com/jellyfin/jellyfin-web/releases"$n' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        echo $w"E.g: "$n"10.11.z"' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        echo ""' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        while read -l webversion -P $r"Enter Version: "$n #ask for version number input' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                or return 1' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                switch $webversion' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                        case \'*.*.z\'' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                sudo -v' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                or break' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd $HOME/Downloads/' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                mkdir build_new_jellyfin_tizen' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd build_new_jellyfin_tizen' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                git clone -b release-$webversion https://github.com/jellyfin/jellyfin-web.git' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                git clone https://github.com/jellyfin/jellyfin-tizen.git' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                nvm install lts/iron' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd jellyfin-web' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                npm ci --no-audit' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                USE_SYSTEM_FONTS=1 npm run build:production | tee /dev/stdout | grep jellyfin-web | read jelly #read the version and still output to terminal' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd ../jellyfin-tizen' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                JELLYFIN_WEB_DIR=../jellyfin-web/dist npm ci --no-audit' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                tizen build-web -e ".*" -e gulpfile.js -e README.md -e "node_modules/*" -e "package*.json" -e "yarn.lock"' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                tizen package -t wgt -o . -- .buildResult' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                # connect to yout TV and install the freshly build jellyfin tizen client'
echo '                                # can add more TVs if needed'
echo "                                sdb connect $samsungtvip" >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                tizen install -n Jellyfin.wgt' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo "                                sdb disconnect $samsungtvip" >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                echo $jelly | cut -f2 -d "@" | cut -f1 -d " " | read ver #cut out the version without tailing space' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                mv Jellyfin.wgt ../../Jellyfin.Tizen.$ver.wgt' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd ../../' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                sudo rm -r build_new_jellyfin_tizen' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                cd' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                break' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                        case \'*\'' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                echo ""' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                echo "$webversion is not a valid version. Try again!"' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                echo ""' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                                continue' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '                end' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo '        end' >> $HOME/.config/fish/functions/getnewjellytizen.fish
echo 'end' >> $HOME/.config/fish/functions/getnewjellytizen.fish

echo "getnewjellytizen.fish is now in your $HOME/.config/fish/functions/ folder."
