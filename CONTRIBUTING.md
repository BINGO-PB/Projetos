
# Guia para Contribuição

Obrigado por seu interesse em contribuir\! Este guia descreve como você pode participar e garantir que suas contribuições estejam alinhadas com os padrões de qualidade do nosso projeto.

Escolha o seu projeto e realize um **PR**

## Realizando um Pull Request

Siga estes passos para submeter seu código:

1. **Faça um Fork e Clone:** Comece fazendo um fork do repositório e, em seguida, clone-o para sua máquina local.

    ```bash
    git clone https://github.com/seu-usuario/nome-do-repositorio.git
    ```

2. **Crie uma Branch:** Crie uma branch separada para suas alterações. Use um nome descritivo. Crie uma branch a partir do ramo **dev**.

    ```bash
    git checkout dev
    git pull origin dev
    git checkout -b nome-da-sua-feature
    ```

3. **Implemente suas Alterações:** Faça suas modificações e implementações. Certifique-se de testar seu código.

4. **Commit suas Alterações:** Adicione e faça o commit de suas mudanças com uma mensagem clara e concisa.

    ```bash
    git add .
    git commit -m "feat: Adiciona nova funcionalidade X"
    ```

    *Dica: Use [convenções de commit](https://www.conventionalcommits.org/en/v1.0.0/) para manter o histórico organizado.*

5. **Envie para o Repositório Remoto:** Envie sua branch para o seu repositório remoto.

    ```bash
    git push origin nome-da-sua-feature
    ```

6. **Abra o Pull Request (PR):** Vá para a página do repositório original no GitHub e abra um novo Pull Request. Descreva o propósito da sua alteração, a solução implementada e, se aplicável, as referências ao issue que ela resolve.

## Boas Práticas de Código Python

Para garantir a consistência e a legibilidade do código, seguimos os padrões da comunidade Python. Por favor, familiarize-se com as seguintes diretrizes:

### 1\. PEP 8: Guia de Estilo para Código Python

A **PEP 8** é o guia de estilo oficial para código Python. Aderir a ela garante que nosso código seja consistente e fácil de ler.

* **Formatação:** Use 4 espaços para indentação, não tabs. Limite as linhas a 79 caracteres.
* **Espaços em Branco:** Use espaços em branco adequadamente, como após vírgulas e em torno de operadores.
* **Quebras de Linha:** Quebre linhas longas para melhorar a legibilidade.

Você pode encontrar a documentação completa da PEP 8 [aqui](https://www.python.org/dev/peps/pep-0008/).

### 2\. Nomenclatura (PEP 8)

Escolher nomes claros e consistentes é crucial.

* **Módulos:** Use nomes curtos, em minúsculas e com sublinhados (`snake_case`). Ex: `meu_modulo.py`.
* **Pacotes:** Similar aos módulos, use minúsculas e sublinhados. Ex: `meu_pacote`.
* **Classes:** Use **CamelCase** com a primeira letra maiúscula. Ex: `MinhaClasse`.
* **Funções e Variáveis:** Use **snake\_case** (minúsculas com sublinhados). Ex: `minha_funcao`, `minha_variavel`.
* **Constantes:** Use **SNAKE\_CASE** (maiúsculas com sublinhados). Ex: `MINHA_CONSTANTE`.

### 3\. Anotações de Tipo (Type Hinting)

Use anotações de tipo (conforme a **PEP 484**) para indicar os tipos de variáveis, parâmetros de funções e retornos. Isso melhora a clareza do código e permite que ferramentas de análise estática (como o `mypy`) identifiquem erros.

Exemplo:

```python
def saudacao(nome: str) -> str:
    """Retorna uma saudação."""
    return f"Olá, {nome}!"

idade: int = 30
```

Para mais detalhes, consulte a **PEP 484**: [aqui](https://www.python.org/dev/peps/pep-0484/).

### 4\. Linting e Formatação Automática

Use ferramentas de linting para verificar a qualidade do seu código antes de submeter um PR.

* **`black`:** Um formatador de código "opinioso" que formata automaticamente seu código para aderir à PEP 8.
* **`flake8`:** Uma ferramenta que verifica a conformidade com a PEP 8 e outros erros de estilo.
* **`isort`:** Uma ferramenta para organizar automaticamente seus imports.

Recomendamos usar `black` para formatação e `flake8` para verificação.

```bash
# Instale as ferramentas
pip install black flake8

# Execute os comandos na raiz do seu projeto
black .
flake8 .
```

Essas ferramentas ajudam a evitar revisões de PRs focadas apenas em estilo de código.

Agradecemos sua colaboração e esperamos ver suas contribuições em breve\!
