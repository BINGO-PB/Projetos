# Sofware Architecture

## TLDR

- Vamos implementar uma *arquitetura hexagonal* de software.
- O código é dividido modularmente da seguinte forma:
    - **domain** tem as coisas que nos interessam diretamente, com suas propriedades. Esta no centro.
    - **application** é a camada de serviços, são ações que queremos realizar com os objetos do domínio. Ela é voltada na direção do usuário.
    - **infrastruture** é uma camada semelhante a de serviços, mas voltados para o próprio programa. São as coisas que precisam ser feitas (como baixar arquivos, controlar dispositivos, banco de dados) para que a camada application realize o seu trabalho.
    - **presentation** é a camada que interage com o usuário, protegendo as especificações de domínio e garantindo que o usuário tenha o resultado que deseja.


:::{figure} ../../../00_images/domain.svg
:label: domainfig

Camada de Domínio
:::


:::{figure} ../../../00_images/services.svg
:label: servicesfig

Camada de Serviços
:::


:::{figure} ../../../00_images/infrastruture.svg
:label: infrafig

Camada de Infraestrutura
:::