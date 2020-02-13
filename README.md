<h3 align="center">Docker para projetos PHP 7.2 + Nginx</h3>

---

## 📝 Sumário

- [Sobre](#sobre)
- [Começando](#comecando)
- [Instale o docker](#installdocker)

## 🧐 Sobre <a name = "sobre"></a>

<p> Esse projeto serve para rodar projetos em PHP, integrado com o Nginx.</p>

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

End with an example of getting some data out of the system or using it for a little demo.

## 🔧 Instalação do Docker <a name = "installdocker"></a>

<a href="https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository"> Instale o docker aqui! </a>
