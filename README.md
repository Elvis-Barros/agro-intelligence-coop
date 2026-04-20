# 🌱 Commercial Intelligence & Risk Platform

**Pipeline end-to-end de Inteligência Comercial e Gestão de Risco para Cooperativas e Distribuidoras de Insumos do Agronegócio Brasileiro**

Projeto desenvolvido como portfólio de **Engenharia de Dados**, simulando uma solução real utilizada por cooperativas e empresas do setor agro (estilo Aliare, Coamo, Cocamar, etc.).

---

### 🎯 Objetivo do Projeto

Criar uma plataforma que ajude cooperativas e distribuidoras a:
- Tomar decisões comerciais mais assertivas (quando vender soja/milho)
- Avaliar **rentabilidade por região** e commodity
- Identificar **riscos** (preço, climático e margem)
- Priorizar clientes e regiões com maior potencial de margem

---

### 🛠️ Tecnologias Utilizadas

- **Docker + Docker Compose** (ambiente reprodutível)
- **PostgreSQL** (banco de dados)
- **dbt (data build tool)** – Modelagem em camadas (Staging → Marts)
- **Python** + **Streamlit** (Dashboard interativo)
- **Plotly** (visualizações)
- **Git** + boas práticas de versionamento

---

### 📊 Funcionalidades Atuais

- Ingestão de dados de **Soja** e **Milho** (preços históricos)
- Cálculo automático de **margem bruta**, prêmio regional e custo estimado
- Classificação de **nível de rentabilidade** (Excelente / Boa / Média / Alto Risco)
- Geração de **recomendações inteligentes** de venda
- Integração com dados climáticos (precipitação e risco de seca)
- Dashboard interativo com filtros (commodity, região, rentabilidade)

---

### 🚀 Como Rodar o Projeto

```bash
# 1. Clone o repositório
git clone https://github.com/Elvis-Barros/agro-intelligence-coop.git
cd agro-intelligence-coop

# 2. Suba os containers
docker-compose up -d --build

# 3. Execute os modelos dbt
docker-compose run --rm dbt dbt seed
docker-compose run --rm dbt dbt run

# 4. Acesse as interfaces:
#    → Dashboard: http://localhost:8501
#    → pgAdmin:   http://localhost:8080