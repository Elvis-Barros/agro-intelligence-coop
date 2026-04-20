# 🌱 Commercial Intelligence & Risk Platform

Pipeline end-to-end de Inteligência Comercial e Gestão de Risco para Cooperativas do Agronegócio Brasileiro.

Projeto desenvolvido como portfólio de Engenharia de Dados, simulando uma solução real focada em analisar a viabilidade de venda de commodities com base em custos fixos de produção e flutuação de preços de mercado.

---

### 🎯 Objetivo do Projeto

Criar uma plataforma que ajude cooperativas a:
- Tomar decisões comerciais assertivas (identificar o momento exato de vender a soja).
- Avaliar a rentabilidade dinâmica por região (GO, MT, MS), contrastando preço de mercado com custo fixo.
- Gerar recomendações inteligentes de venda ("Vender agora", "Hedging" ou "Não Vender abaixo do custo").

---

### 🛠️ Stack de Tecnologias

- **Docker + Docker Compose** (Ambiente containerizado e reprodutível)
- **PostgreSQL** (Armazenamento relacional - Camada RAW)
- **Python + SQLAlchemy** (Ingestão automatizada de dados simulados de mercado)
- **dbt Core** (Transformação e modelagem em camadas: Staging -> Mart)
- **Streamlit + Plotly** (Dashboard interativo com KPIs de negócio)
- **Git + Conventional Commits** (Versionamento profissional)

---

### 🏗️ Arquitetura do Pipeline

1. Ingestão (Python): Script extrai dados simulados de 6 meses de mercado (3 regiões) e carrega na camada RAW do Postgres.
2. Transformação (dbt): O dbt lê a camada RAW, aplica regras de negócio (ex: custo fixo de R$ 62 em GO vs mercado oscilante) e entrega na camada MART.
3. Visualização (Streamlit): Dashboard consome a camada MART e exibe gráficos de margem bruta, distribuição de rentabilidade e recomendações de venda.

---

### 🚀 Como Rodar o Projeto

1. Clone o repositório:
git clone https://github.com/Elvis-Barros/agro-intelligence-coop.git

2. Suba a infraestrutura de banco de dados:
docker-compose up -d

3. Execute a ingestão de dados (Requer Python 3.10+ com venv ativado):
pip install pandas sqlalchemy psycopg2-binary
python ingestion/ingestao_agro.py

4. Rode a transformação com o dbt:
docker-compose run --rm dbt dbt run --profiles-dir .

5. Acesse as interfaces:
Dashboard: http://localhost:8501
pgAdmin: http://localhost:8080

---

### 👨‍💻 Autor
Elvis Barros
Administrador de Empresas | Pós-graduado em Engenharia e Arquitetura de Dados
Focado em unir a visão estratégica de negócios à infraestrutura moderna de dados.