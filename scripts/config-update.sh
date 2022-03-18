#!/bin/sh

REPO_SCRIPT_DIR=$(dirname $0)
REPO_CONFIG_DIR=${REPO_SCRIPT_DIR}/../configs

HOME_DIR=$(echo ~)

case ${1} in

  zsh)
    CONFIG_NAME=.zshrc
    LOCAL_CONFIG_PATH=${HOME_DIR}/${CONFIG_NAME}
    if [[ -e ${LOCAL_CONFIG_PATH} ]];
    then
      echo Copy: $(cp -v ${LOCAL_CONFIG_PATH} ${REPO_CONFIG_DIR}/${CONFIG_NAME});
    fi

    PROFILE_NAME=.zprofile
    LOCAL_PROFILE_PATH=${HOME_DIR}/${PROFILE_NAME}
    if [[ -e ${LOCAL_PROFILE_PATH} ]];
    then
      echo Copy: $(cp -v ${LOCAL_PROFILE_PATH} ${REPO_CONFIG_DIR}/${PROFILE_NAME});
    fi

    THEME_NAME=qhan.zsh-theme
    LOCAL_THEME_PATH=${HOME_DIR}/.oh-my-zsh/custom/themes/${THEME_NAME}
    if [[ -e ${LOCAL_THEME_PATH} ]];
    then
      echo Copy: $(cp -v ${LOCAL_THEME_PATH} ${REPO_CONFIG_DIR}/${THEME_NAME});
    fi
    ;;

  bash)
    CONFIG_NAME=.basharc
    LOCAL_CONFIG_PATH=${HOME_DIR}/${CONFIG_NAME}
    if [[ -e ${LOCAL_CONFIG_PATH} ]];
    then
      echo Copy: $(cp -v ${LOCAL_CONFIG_PATH} ${REPO_CONFIG_DIR}/${CONFIG_NAME});
    fi
    ;;

  vim)
    LOCAL_CONFIG_PATH=${HOME_DIR}/.vimrc
    if [[ -e ${LOCAL_CONFIG_PATH} ]];
    then
      echo Copy: $(cp -v ${LOCAL_CONFIG_PATH} ${REPO_CONFIG_DIR}/${CONFIG_NAME});
    fi
    ;;

  jupyter)
    LOCAL_CONFIG_DIR=${HOME_DIR}/.jupyter
    if [[ -d ${LOCAL_CONFIG_DIR} ]];
    then
      echo Copy:
      cp -rv ${LOCAL_CONFIG_DIR} ${REPO_CONFIG_DIR}/
    fi
    ;;

  *)
    echo "$(tput setaf 3)Usage: ${0} zsh|bash|jupyter$(tput sgr0)"
    exit 1
    ;;

esac

echo "$(tput setaf 2)Done.$(tput sgr0)"
