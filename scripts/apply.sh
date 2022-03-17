#!/bin/sh

REPO_SCRIPT_DIR=$(dirname $0)
REPO_CONFIG_DIR=${REPO_SCRIPT_DIR}/../configs

HOME_DIR=$(echo ~)

case ${1} in

  zsh)
    if ! [[ -d ${ZSH} ]];
    then
      # install oh-my-zsh
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

      # install zsh-autosuggestions
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    CONFIG_NAME=.zshrc
    echo Copy: $(cp -v ${REPO_CONFIG_DIR}/${CONFIG_NAME} ${HOME_DIR}/${CONFIG_NAME});

    THEME_NAME=qhan.zsh-theme
    LOCAL_THEME_PATH=${HOME_DIR}/.oh-my-zsh/custom/themes/${THEME_NAME}
    echo Copy: $(cp -v ${REPO_CONFIG_DIR}/${THEME_NAME} ${LOCAL_THEME_PATH});
    ;;

  bash)
    CONFIG_NAME=".bashrc"

    echo Copy: $(cp -v ${REPO_CONFIG_DIR}/${CONFIG_NAME} ${HOME_DIR}/${CONFIG_NAME});
    ;;

  vim)
    CONFIG_NAME=".vimrc"

    echo Copy: $(cp -v ${REPO_CONFIG_DIR}/${CONFIG_NAME} ${HOME_DIR}/${CONFIG_NAME});
    ;;

  jupyter)
    CONFIG_NAME=".jupyter"

    echo Copy:
    cp -rv ${REPO_CONFIG_DIR}/${CONFIG_NAME} ${HOME_DIR}/
    ;;

  *)
    echo "$(tput setaf 3)Usage: ${0} zsh|bash|jupyter$(tput sgr0)"
    exit 1
    ;;

esac

echo "$(tput setaf 2)Done$(tput sgr0)"
