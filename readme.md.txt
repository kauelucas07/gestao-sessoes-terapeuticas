# Projeto: Gestão de Sessões Terapêuticas

**Disciplina:** Banco de Dados II  
**Banco de dados:** MySQL  
**Ferramenta utilizada:** MySQL Workbench  
**Linguagem:** SQL

---

## 1. Objetivo do Projeto

O projeto tem como objetivo desenvolver procedures armazenadas no MySQL para gerenciar sessões terapêuticas, aplicando validações e regras de negócio para garantir a integridade dos dados.

## 2. Estrutura do Banco de Dados

O banco de dados utilizado é `clinica_terapeutica`, composto pelas seguintes tabelas:

- pacientes
- terapeutas
- salas
- convenios
- sessoes

## 3. Procedures Desenvolvidas

### 3.1 aplicar_desconto_sessao

Procedure responsável por aplicar descontos no valor de uma sessão.

**Validações implementadas:**
- Verifica se a sessão existe.
- Permite desconto somente em sessões com status agendada.
- Verifica se o percentual está entre 1% e 100%.
- Impede que o valor final seja inferior a R$ 50,00.

### 3.2 cadastrar_sessao

Procedure responsável por cadastrar novas sessões terapêuticas.

**Validações implementadas:**
- Verifica se o paciente existe.
- Verifica se o terapeuta existe.
- Verifica se a sala existe.
- Impede cadastro com data e hora anteriores ao momento atual.
- Exige que o valor seja maior que zero.
- Cadastra a sessão com status agendada.

### 3.3 trocar_convenio

Procedure responsável por atualizar o convênio de um paciente.

**Validações implementadas:**
- Verifica se o paciente existe.
- Verifica se o novo convênio existe.
- Impede que o paciente seja vinculado novamente ao mesmo convênio.

## 4. Tecnologias Utilizadas

- MySQL Server 8.0
- MySQL Workbench
- SQL

## 5. Arquivo do Projeto

`gestao_sessoes_terapeuticas.sql`

Contém o código completo das três procedures desenvolvidas.

## 6. Conclusão

O desenvolvimento deste projeto permitiu aplicar conhecimentos de Banco de Dados II, utilizando procedures armazenadas, estruturas condicionais, comandos de inserção e atualização e validações para garantir a integridade das informações.

**Projeto acadêmico desenvolvido para a disciplina Banco de Dados II.**