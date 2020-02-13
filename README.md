<h1> Como criar a imagem </h1>

<p> Basta rodar o comando abaixo na raiz deste projeto, no mesmo nivel que o arquivo Dockerfile </p>
<p> docker build . -t <strong> nome da imagem </strong> </p>

<h1> Como criar o container </h1>

<p> docker run -it -p 80:80 -v $(pwd)/www:/var/www/html --name <strong> Nome-container </strong> <strong> Nome-imagem </strong> /bin/bash </p>

<h1> Não tem o docker instalado ? instale para o ubuntu </h1>

<p style="color:&#x1F34E;"> Rode todos os comandos em ordem. </p>

<p> sudo apt-get update </p>
<p> sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common </p>
<p> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - </p>

<p> 
    sudo apt-key fingerprint 0EBFCD88 <br>
    <span style="color:#C8C8C8"> pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S] </span>
</p>
