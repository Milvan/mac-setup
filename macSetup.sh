
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

echo "Installing command line developer tools..."
xcode-select --install

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install caskroom/cask/brew-cask
    brew tap homebrew/cask-versions
    brew tap homebrew/cask-cask
    brew tap 'homebrew/bundle'
    brew tap 'homebrew/cask'
    brew tap 'homebrew/cask-drivers'
    brew tap 'homebrew/cask-fonts'
    brew tap 'homebrew/core'
    brew tap 'homebrew/services'
    brew tap aws/tap

fi

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
)
if [ "$General" != "${General#[Yy]}" ] ;then
    brew cask install --appdir="/Applications" ${CaskGeneralToolList[@]}
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
    cheatsheet
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
    brew cask install ${CaskDeveloperUtilitiesList[@]}

    brew link vim

    npm install -g @google/gemini-cli

    echo "Installing latest nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    echo "Installing latest stable Node.js and setting .nvmrc..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    node -v > ~/.nvmrc

    echo "Installing latest bun..."
    curl -fsSL https://bun.sh/install | bash

    echo '
    # BASH-COMPLETION CONFIG
    [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile
    
else
    echo No developer utils tools
fi

############# ZSH mods #######################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

############# Database Tools #############
beginDeploy "############# Database Tools #############"


DatabaseToolList=(
    kafkacat
)
CaskDatabaseToolList=(
    graphiql
)
if [ "$Database" != "${Database#[Yy]}" ] ;then
    brew install ${DatabaseToolList[@]}
    brew cask install ${CaskDatabaseToolList[@]}

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
    brew cask install --appdir="/Applications" ${CaskIDEsList[@]}
    cat vscode-extensions.txt | xargs -L1 code --install-extension

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
    brew cask install ${CaskDevOpsToolList[@]}

    ## DOCKER APP
    wget -P ~/Downloads/ https://github.com/docker/app/releases/download/v0.8.0/docker-app-darwin.tar.gz
    tar -xvf ~/Downloads/docker-app-darwin.tar.gz -C ~/Downloads/
    mv ~/Downloads/docker-app-darwin /usr/local/bin/docker-app
    rm ~/Downloads/docker-app-darwin.tar.gz


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
    brew cask install --appdir="/Applications" ${CaskProductivityToolList[@]}
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
    brew install mas
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

rm -r ~/.vim ~/.vimrc ~/.zshrc ~/.gitconfig
ln -s $currentdir/vimrc ~/.vimrc
ln -s $currentdir/zshrc ~/.zshrc
ln -s $currentdir/gitconfig ~/.gitconfig
ln -s $currentdir/vim ~/.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

beginDeploy "############ Custom Dvorak Keyboard layout####"
cp $currentdir/keyboard_layout/* /Library/Keyboard\ Layouts/.

runtime=$((($(date +%s)-$start)/60))
beginDeploy "############# Total Setup Time ############# $runtime Minutes"
