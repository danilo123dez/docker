<h3 align="center">Docker para projetos PHP 7.2 + Nginx</h3>

---

## 📝 Sumário

- [Sobre](#sobre)
- [Começando](#comecando)
- [Instale o docker](#installdocker)
- [Rodar o bash no servidor](#bashserver)

## 🧐 Sobre <a name = "sobre"></a>

<p> Esse projeto irá auxiliar na criação de containers para rodar projetos em servidor local</p>

## 🏁 Começando <a name = "comecando"></a>

Antes de começar é bom verificar se você já tem o docker instalado, caso não tenha [Instale aqui](#installdocker)

### Instalando

Para começar, clone o projeto e entre na pasta raiz dele

Primeiro vamos criar a imagem do nosso container. Rode o seguinte comando:

```
docker build . -t nome_da_imagem
```

Este processo Este processo pode levar algum tempo, vai depender da velocidade da sua internet.

Em seguida vamos criar o container do nosso projeto. Acesse a pasta do seu projeto que queria rodar e na raiz dele é sempre bom ter uma pasta "www/" que irá conter os arquivos do projeto. Rode o seguinte comando:

```
docker run -it -p 80:80 -v $(pwd)/www:/var/www/html --name nome_container nome_da_imagem /bin/bash
```

Note que a parte "$(pwd)/www" irá pegar o seu diretório atual e fazer com que ela linke com a pasta que roda os projetos dentro do container (pasta escolhida nas configurações de nginx). Caso não queria usar a pasta www, basta tira-la do código.

Ao rodar esse comando você "entrará" no container automaticamente.

### Acessando o container

Quando você for acessar o container novamente, basta dar o comando:

```
docker ps -a
```

Ele irá lista todos os container criados, listando os ativos e os inativos (para listar apenas os ativas, rode o mesmo comando sem "-a").

Com a lista de containers, copie o nome do seu container e rode o comando:

```
docker attach nome_container
```

### Configurações iniciais dentro do container

Ao acessar o container rode os seguintes comandos:

```
service nginx start
```

```
service php7.2-fpm start
```

Caso queira listar todos os serviços dentro do container rode o comando:

```
service --status-all
```

Esses serviços são para que o projeto fique rodando na sua maquina acessando pelo browser a url "localhost"

### Projeto em laravel ? Como rodar ?

Caso o projeto seja em laravel, dentro do container, acesse a pasta 

```
/etc/nginx/sites-available/
```

Lá terá um arquivo chamado app, você terá que edita-lo. Na linha que está escrito:

```
root /var/www/html;
```

**substitua por:**

```
root /var/www/html/public/;
```

### Como criar o container de mysql ?

Para criar o container de mysql, rode o comando abaixo e defina o nome e senha do usuário do seu mysql.

```
docker run -p 3306:3306 --env MYSQL_ROOT_PASSWORD=123456 --env MYSQL_USER=docker --env MYSQL_PASSWORD="docker123" --name=mysql -d mysql/mysql-server:5.7
```

a tag "--name" será o nome do container. O último parâmetro será difinida a versão do sql, caso queria alguma especifica veja no <a href="https://hub.docker.com/_/mysql"> docker hub </a>, basta escolher uma tag que está no começo do site.

Para **conectar** no mysql deste docker você terá que rodar o comando:

```
docker inspect nome_container_mysql
```

Esse comando irá trazer diversas informações, mas o que interessa é a linha no final **"IPAddress"**. Este é o IP local do seu container de mysql, com ele você poderá conectar pelo mysql workbench, dbeaver, etc...

## 👌 Como usar os arquivos bash para rodar no servidor <a name = "bashserver"></a>

Clone o projeto no servidor e na raiz do projeto rode o seguinte comando:

```
sudo ./configurations.sh prod
```

Além de instalar as configurações normais de docker local, irá instalar git, docker e criará um container de mysql.

## 🔧 Instalação do Docker <a name = "installdocker"></a>

<a href="https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository"> Instale o docker aqui! </a>
