# Unity Catalog do zero

Materiais do vídeo **"Unity Catalog do zero"**, do canal Jornada de Dados.

- `slides_unity_catalog.html`: slides da apresentação. É um arquivo HTML sem dependências: abra no navegador.
- `demo_unity_catalog.sql`: script da demonstração, em 4 blocos (estrutura, permissões, lineage e limpeza). Execute um bloco por vez, na ordem, no editor SQL do Databricks.

## Antes de rodar a demo

- Você precisa de um workspace Databricks com Unity Catalog e permissão para criar catálogos.
- O script concede permissões ao grupo `data_analysts`. Se o grupo não existir no seu workspace, troque o nome nos blocos 2 e crie o grupo antes.
- Os dados são fictícios. O bloco 4 apaga o catálogo `jornada_demo`, então você pode repetir a demo do zero.
