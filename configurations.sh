#!/usr/bin/env bash

# including functions.sh file
source "$(dirname "$0")"/functions.sh

Separador 'Bash do DanDan' ${BLUE};

function AddRepositories() {
    AptUpdate

    Separador "Ativando repositórios extras para o Ubuntu 16.04 64 Bits";

    Separador "ativando os repositórios Universe e Multiverse" ${LIGHT_GREEN};

    add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ xenial universe multiverse" && \
    echo -ne "\n" | add-apt-repository ppa:ondrej/php  && \
    echo -ne "\n" | add-apt-repository ppa:ondrej/nginx  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C;

    AptUpdate 'upgrade';

    apt-get -y auto-remove;
}

function InstallPHP() {

    Separador "Instalando PHP 7.2 e as principais extensões utilizadas";

    apt-get -y install php7.2-fpm;

    service nginx restart;

    # extensions

    apt-get -y install php7.2-mbstring;
    apt-get -y install php7.2-bcmath;
    apt-get -y install php7.2-xml;
    apt-get -y install php7.2-curl;
    apt-get -y install php7.2-mysql;

    # @bugfix failed restart because it wans't running
    service php7.2-fpm stop && service php7.2-fpm start;
    service nginx restart;

}

function InstallSoftwareDependencies() {
    Separador "Instalando dependências de software comuns durante o desenvolvimento";

    apt-get -y install composer;

    export COMPOSER_HOME="$HOME/.config/composer"
}

function AdjustVirtualHostFolders() {
    Separador "Ajustando diretórios do VirtualHost do projeto:";

    # site
    mkdir -p /var/www/html && \
    chmod 755 /var/www && \
    chmod 2755 /var/www/html && \
    chown -R www-data:www-data /var/www;

    # app
    mkdir -p /var/www/app && \
    chmod 755 /var/www && \
    chmod 2755 /var/www/app && \
    chown -R www-data:www-data /var/www;
}

function InstallNginx() {
    Separador "Instalando e Configurando o Servidor Nginx";

    wget http://nginx.org/keys/nginx_signing.key && \
    echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> /etc/apt/sources.list && apt-key add ./nginx_signing.key;

    AptUpdate;

    apt-get install -y nginx && systemctl enable nginx;

    mkdir /etc/nginx/sites-available;
    mkdir /etc/nginx/sites-enabled;

    service nginx stop;

    sudo ufw allow 80 && sudo ufw allow 443 && sudo ufw allow 22;
    ufw enable;

    Separador "Protegendo os diretórios de configuração do Nginx" ${LIGHT_GREEN};
    chmod 0750 -R /etc/nginx/;
}

function CompileNginxModules() {

    Separador "Compilando módulos extras para o NGINX" ${LIGHT_GREEN};

    printf "\nhttps://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus\n";

    wget https://github.com/AirisX/nginx_cookie_flag_module/archive/master.zip;

    wget http://nginx.org/download/nginx-1.15.5.tar.gz;

    tar zxvf nginx-1.15.5.tar.gz;

    Separador "Compilando e copiando o módulo dinâmico para o diretório padrão de módulos do NGINX" ${CYAN};

    cd nginx-1.15.5 && \
    ./configure --with-compat --add-dynamic-module=../nginx_cookie_flag_module-master;

    make modules && \
    cp objs/ngx_http_cookie_flag_filter_module.so /etc/nginx/modules;

    Separador "Carregando o Conector Compilado" ${CYAN}

    mkdir /etc/nginx/modules-enabled;
    touch /etc/nginx/modules-enabled/50-ngx_http_cookie_flag_filter_module.conf;
    echo 'load_module modules/ngx_http_cookie_flag_filter_module.so;' > /etc/nginx/modules-enabled/50-ngx_http_cookie_flag_filter_module.conf;
    sed -i '21iset_cookie_flag HttpOnly secure;' /etc/nginx/snippets/security-locations.conf;

}

function AddVirtualHostFiles() {
    Separador "Ajustando arquivo do VirtualHost do projeto:";

    cp ./vhost/vhost-app.conf /etc/nginx/sites-available/app;
    rm /etc/nginx/sites-available/default;
    rm /etc/nginx/sites-enabled/default;
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp;
    cp ./vhost/nginx.conf /etc/nginx/nginx.conf;

    cp -r ./vhost/snippets /etc/nginx;

    ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/;
}

function AddExtraPackages() {
    Separador "Preparando pré-requisitos";

    Separador "Instalando pacote de Idiomas Inglês:" ${LIGHT_GREEN};
    apt-get -y install language-pack-en;

    locale-gen "en_US.UTF-8" && localedef -v -c -i en_US -f UTF-8 en_US.UTF-8;
    export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && export LANGUAGE=en_US.UTF-8;

    printf '\n[ Status dos locales do sistema ]\n';
    locale;

    Separador "Instalando o pacote wget para capturar o conteúdo de uma URL, o editor nano e o pacote unzip para manipular arquivos .zip e outros pacotes auxiliares" ${LIGHT_GREEN};
    apt-get -y install wget nano unzip curl tree;

    Separador "Instalando pacotes adicionais para a configuração do NGINX e PHP" ${LIGHT_GREEN};
    apt-get -y install tar bzip2 gcc;

    Separador "Instalando pacotes que auxiliam no gerenciamento e debug de conflitos de infraestrutura" ${LIGHT_GREEN};
    apt-get install -y net-tools;
}

function InstallUFW(){
    Separador "Instalando UFW Firewall e configurando para não usar IPv6";
    apt-get install -y ufw;

    # desativando IPV6, o docker não utiliza neste contexto
    sed  -i "s/\(IPV6 *= *\).*/\1no/" /etc/default/ufw;
}

function installDocker(){
    AptUpdate;
    Separador "Instalando Docker";
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
    sudo apt-key fingerprint 0EBFCD88;
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable";
    AptUpdate;
    sudo apt-get install docker-ce docker-ce-cli containerd.io;
    sudo apt-get install docker-ce=5:18.09.1~3-0~ubuntu-xenial docker-ce-cli=5:18.09.1~3-0~ubuntu-xenial containerd.io
    sudo docker run hello-world
    Separador "Docker instalado"
}

function createDockerMysql(){
    Separador "Criando o docker de mysql0"
    docker run --env MYSQL_ROOT_PASSWORD=123456 --env MYSQL_USER=docker --env MYSQL_PASSWORD="docker123" --name=mysql -d mysql/mysql-server:latest
}

AptUpdate;
AddExtraPackages 1;
InstallUFW 1;

InstallNginx
AddVirtualHostFiles
AdjustVirtualHostFolders

AddRepositories
InstallPHP
InstallSoftwareDependencies

if [ 'prod' = ${1} ]; then
    installDocker;
    createDockerMysql
fi

Separador "Todas configurações feita com sucesso!";