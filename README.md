<h1> Como criar a imagem </h1>

<p> Basta rodar o comando abaixo na raiz deste projeto, no mesmo nivel que o arquivo Dockerfile </p>
<p> docker build . -t <strong> nome da imagem </strong> </p>

<h1> Como criar o container </h1>

<p> docker run -it -p 80:80 -v $(pwd)/www:/var/www/html --name <strong> Nome-container </strong> <strong> Nome-imagem </strong> /bin/bash </p>

