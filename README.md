# Avaliação 01: Exercises in Programming Style - KWIC

![](https://img.shields.io/badge/version-v1.0-blue)

Este repositório corresponde à Avaliação 01 da disciplina Técnicas de Programação 2 da Universidade de Brasília. O projeto implementa o algoritmo Keyword in Context (KWIC) utilizando o estilo de programação Actors, conforme descrito no livro *Exercises in Programming Style*, da Profa. Crista Lopes. O objetivo é explorar a aplicação de estilos de programação ao resolver um problema clássico de manipulação e ordenação de strings.

Você pode acessar o repositório principal [aqui](https://github.com/Schatten900/kwicTP2).

## Membros do Grupo
- Davi Salomão Soares Corrêa, 24/2036844.
- João Vitor Dickmann, 21/1042757.
- Carlos Cauã Rocha da Silva, 23/1034304.
- Wallysson Matheus de Queiroz Silva, 23/1038798.
   
## Estilo e Linguagem de Programação Escolhidos
- Estilo de Programação: Actors
- Linguagem de Programação: Erlang

Escolhemos o estilo de programação Actors, baseado em processos independentes e comunicação assíncrona, para implementar o algoritmo KWIC. Esse estilo foi adotado para explorar a abordagem de concorrência e escalabilidade, características essenciais não apenas para a manipulação otimizada das strings no KWIC, mas também para melhorar o desempenho geral em problemas que exigem processamento paralelo e eficiente de dados em larga escala.

## Arquivos do Projeto
O projeto está organizado nos seguintes arquivos principais:
- stopword.erl: Arquivo principal com a implementação do algoritmo KWIC.
- stopword_test_unit.erl: Arquivo com os testes unitários do KWIC.
- stopword_test_int.erl: Arquivo com os testes de integração do KWIC.
- README.md: Este arquivo, com as instruções do projeto e links relevantes.

## Como Fazer o Build e Executar os Testes
1. Clone o repositório:
   ```bash
   git clone https://github.com/Schatten900/kwicTP2
2. Inicie o shell do Erlang:
   ```bash
   erl
3. Compile o código Erlang:
   ```erlang
   c(stopword).
4. Execute o programa com um arquivo de entrada (por exemplo, "word.txt") e parâmetros de configuração, como ordem de classificação e lista de palavras de parada (stop words):
   ```erlang
   stopword:main("word.txt", "insensivel", ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"]).
5. Execute os testes:
- Testes Unitários:
   ```erlang
   c(stopword_test_unit).
   eunit:test(stopword_test_unit).
- Testes de Integração:
   ```erlang
   c(stopword_test_int).
   eunit:test(stopword_test_int).

## Videoaula
Detalhes sobre o estilo de programação Actors e sua aplicação no KWIC estão disponíveis [aqui](https://youtu.be/c6xJwIXo2Oc).



