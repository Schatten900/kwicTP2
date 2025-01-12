# Avaliação 01: Exercises in Programming Style - KWIC

![](https://img.shields.io/badge/version-v1.0-blue)

Este repositório corresponde à Avaliação 01 da disciplina Técnicas de Programação 2 da Universidade de Brasília. O projeto implementa o algoritmo Keyword in Context (KWIC) utilizando o estilo de programação Actors, conforme descrito no livro *Exercises in Programming Style*, da Profa. Crista Lopes. O objetivo é explorar a aplicação de estilos de programação ao resolver um problema clássico de manipulação e ordenação de strings.

## Estilo e Linguagem de Programação Escolhidos

- Estilo de Programação: Actors
- Linguagem de Programação: Erlang

O estilo Actors, baseado em processos independentes e comunicação assíncrona, foi utilizado para implementar o algoritmo KWIC. Detalhes sobre o estilo e sua aplicação no KWIC são discutidos na vídeo aula disponível neste repositório.

## Arquivos do Projeto

O projeto está organizado nos seguintes arquivos principais:

- stopword.erl: Arquivo principal com a implementação do algoritmo KWIC.
- stopword_test_unit.erl: Arquivo com os testes unitários do KWIC.
- stopword_test_int.erl: Arquivo com os testes de integração do KWIC.
- README.md: Este arquivo, com as instruções do projeto e links relevantes.

## Como Usar

1. Inicie o shell do Erlang:
   ```bash
   erl
2. Compile o código Erlang:
   ```erlang
   c(stopword).
3. Execute o programa com um arquivo de entrada (por exemplo, "word.txt") e parâmetros de configuração, como ordem de classificação e lista de palavras de parada (stop words):
   ```erlang
   stopword:main("word.txt", "insensivel", ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"]).

## Videoaula

A videoaula sobre o estilo de programação Actors e sua aplicação no KWIC está disponível [aqui](link-do-video).

