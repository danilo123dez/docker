#!/usr/bin/env bash

author="Danilo Franceschi";
version="1.0.0";


RED="\033[0;31m";
CYAN="\033[0;36m";
YELLOW="\033[1;33m";
LIGHT_GREEN="\033[1;32m";
WHITE="\033[0m";
BLUE="\033[0;34m"

function Separador(){
    echo '';
    echo '';

    # if ${2} is empty
    if [ -z "${2}" ]; then
        echo -e ${YELLOW};
    else
        echo -e ${2};
    fi

    echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
    echo $1;
    echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
    echo '';
    echo '';

    echo -e ${WHITE};
}

function AptUpdate() {
    Separador "Atualizando repositórios..." ${LIGHT_GREEN};
    apt-get -y update;
}