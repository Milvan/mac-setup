
#!/bin/bash

start=`date +%s`
bold=$(tput bold)
normal=$(tput sgr0)
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo -n "Do you wish to install General Tools (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read General

echo -n "Do you wish to install Developer Utilities (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read DeveloperUtilities

echo -n "Do you wish to install Database Tools (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read Database

echo -n "Do you wish to install IDEs (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read IDEs

echo -n "Do you wish to install DevOps Tools (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read DevOps

echo -n "Do you wish to install Productivity Tools (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read Productivity

echo -n "Do you wish to install Mac Application (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read MacApplication

echo -n "Do you wish to install Custom Keyboard Layouts (${bold}${green}y${reset}/${bold}${red}n${reset})? "
read KeyboardLayout

if ! xcode-select -p &> /dev/null; then
  echo "Installing command line developer tools..."
  xcode-select --install
else
  echo "Command line developer tools already installed."
fi

if ! command -v brew &> /dev/null; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is available in the current shell session
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew tap aws/tap

echo "Updating homebrew..."
brew update
brew upgrade


beginDeploy() {
    echo
    echo "${bold}$1${normal}"
}

############# General Tools #############
beginDeploy "############# General Tools #############"

CaskGeneralToolList=(
    google-chrome
    firefox
    spotify
    1password
)
if [ "$General" != "${General#[Yy]}" ] ;then
    brew install --cask --appdir="/Applications" ${CaskGeneralToolList[@]}
else
    echo No general tools
fi


############# Developer Utilities #############
beginDeploy "############# Developer Utilities #############"

DeveloperUtilitiesList=(
    tree
    ctop
    jq
    yarn
    yarn-completion
    netcat
    nmap
    wget
    go
    bash-completion
    zsh
    zsh-completions
    vim
    python3
    node
    pnpm
    reattach-to-user-namespace
)
CaskDeveloperUtilitiesList=(
    rectangle
    postman
    1password-cli
    flycut
    google-cloud-sdk
    # dotnet-sdk
    # wireshark
    # google-chrome-canary
    # firefox-developer-edition
)
if [ "$DeveloperUtilities" != "${DeveloperUtilities#[Yy]}" ] ;then
    
    brew install ${DeveloperUtilitiesList[@]}
    brew install --cask ${CaskDeveloperUtilitiesList[@]}

    brew link vim

    if ! command -v gemini &> /dev/null; then
        npm install -g @google/gemini-cli
    else
        echo "gemini-cli already installed."
    fi

    if [ ! -d "$HOME/.nvm" ]; then
        echo "Installing latest nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    else
        echo "nvm already installed."
    fi

    echo "Installing latest stable Node.js and setting .nvmrc..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    node -v > ~/.nvmrc

    if ! command -v bun &> /dev/null && [ ! -d "$HOME/.bun" ]; then
        echo "Installing latest bun..."
        curl -fsSL https://bun.sh/install | bash
    else
        echo "bun already installed."
    fi

    echo '
    # BASH-COMPLETION CONFIG
    [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile
    
else
    echo No developer utils tools
fi

############# ZSH mods #######################
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

############# Database Tools #############
beginDeploy "############# Database Tools #############"


DatabaseToolList=(
    pgcli
    postgresql
)
CaskDatabaseToolList=(
    pgadmin4
    postico
)
if [ "$Database" != "${Database#[Yy]}" ] ;then
    brew install ${DatabaseToolList[@]}
    brew install --cask ${CaskDatabaseToolList[@]}

else
    echo No DB tools
fi


############# IDEs #############
beginDeploy "############# IDEs #############"

CaskIDEsList=(
    visual-studio-code
    # visual-studio
    # android-studio
)
if [ "$IDEs" != "${IDEs#[Yy]}" ] ;then
    brew install --cask --appdir="/Applications" ${CaskIDEsList[@]}
    if command -v code &> /dev/null; then
        INSTALLED_EXTS=$(code --list-extensions | tr '[:upper:]' '[:lower:]')
        while read -r ext; do
            ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
            if ! echo "$INSTALLED_EXTS" | grep -q "^$ext_lower$"; then
                code --install-extension "$ext"
            else
                echo "VSCode extension $ext already installed."
            fi
        done < vscode-extensions.txt
    fi

else
    echo No IDEs
fi


############# DevOps #############
beginDeploy "############# DevOps #############"

DevOpsToolList=(
    terraform
    vault
    consul
    # nomad
    # packer
    # terragrunt
    # awscli
    # aws-sam-cli
    # kompose
)
CaskDevOpsToolList=(
    # vmware-fusion
    docker
)
if [ "$DevOps" != "${DevOps#[Yy]}" ] ;then
    brew install ${DevOpsToolList[@]}
    brew install --cask ${CaskDevOpsToolList[@]}

    ## DOCKER APP
    if [ ! -f "/usr/local/bin/docker-app" ]; then
        wget -P ~/Downloads/ https://github.com/docker/app/releases/download/v0.8.0/docker-app-darwin.tar.gz
        tar -xvf ~/Downloads/docker-app-darwin.tar.gz -C ~/Downloads/
        mv ~/Downloads/docker-app-darwin /usr/local/bin/docker-app
        rm ~/Downloads/docker-app-darwin.tar.gz
    else
        echo "docker-app already installed."
    fi


    ## Install AWS CLI
    #pip3 --version
    #curl -O https://bootstrap.pypa.io/get-pip.py
    #python3 get-pip.py --user
    #pip3 install awscli --upgrade --user
    # aws --version
    #rm get-pip.py


    # curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
    # unzip awscliv2.zip
    # sudo ./aws/install
    # aws2 --version
else
    echo No Devops
fi


############# Productivity Tools #############
beginDeploy "############# Productivity Tools #############"

CaskProductivityToolList=(
    slack
    # evernote
    # the-unarchiver
    # dash
    # gpg-suite
    # microsoft-teams
    # microsoft-office
    # zoomus
)
if [ "$Productivity" != "${Productivity#[Yy]}" ] ;then
    brew install --cask --appdir="/Applications" ${CaskProductivityToolList[@]}
else
    echo No Productivity
fi


############# Mac Application #############
beginDeploy "############# Mac Application #############"


MacApplicationToolList=(
    # 409183694 # Keynote
    # 409203825 # Numbers
    # 409201541 # Pages
    497799835 # Xcode
    # 1450874784 # Transporter
    # 1274495053 # Microsoft To Do
    # 985367838 # Microsoft Outlook
)
if [ "$MacApplication" != "${MacApplication#[Yy]}" ] ;then
    if ! command -v mas &> /dev/null; then
        brew install mas
    fi
    mas install ${MacApplicationToolList[@]}

    echo "######### Save screenshots to ${HOME}/Pictures/Screenshots"
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

    echo "######### Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF"
    defaults write com.apple.screencapture type -string "png"

else
    echo No
fi

beginDeploy "############# CLEANING HOMEBREW #############"
brew cleanup

# beginDeploy "############# ALIASES #############"

# beginDeploy "############# DOCKER ALIASES #############"
# sh -c 'curl -s https://raw.githubusercontent.com/maxyermayank/developer-mac-setup/master/.docker_aliases >> ~/.docker_aliases'
# source ~/.docker_aliases
# 

beginDeploy "############# SETUP BASH PROFILE #############"
source ~/.bash_profile

beginDeploy "############# Copy config files  #############"
currentdir=`pwd`

for file in vim vimrc zshrc gitconfig; do
    target="$HOME/.$file"
    source="$currentdir/$file"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo ".$file already exists, skipping symlink."
    else
        ln -s "$source" "$target"
    fi
done
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo "Vundle already installed, skipping Vim plugin installation."
fi

beginDeploy "############ Custom Dvorak Keyboard layout####"
if [ "$KeyboardLayout" != "${KeyboardLayout#[Yy]}" ] ;then
    mkdir -p ~/Library/Keyboard\ Layouts
    for layout in "$currentdir"/keyboard_layout/*; do
        filename=$(basename "$layout")
        if [ ! -f "$HOME/Library/Keyboard Layouts/$filename" ]; then
            cp "$layout" "$HOME/Library/Keyboard Layouts/"
            echo "Installed keyboard layout: $filename"
        else
            echo "Keyboard layout $filename already exists, skipping."
        fi
    done
else
    echo "Skipping Keyboard layouts"
fi

runtime=$((($(date +%s)-$start)/60))
beginDeploy "############# Total Setup Time ############# $runtime Minutes"
