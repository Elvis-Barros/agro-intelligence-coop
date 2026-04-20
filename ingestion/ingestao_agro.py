import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime, timedelta
import random

# 1. Configurações do Banco (Extraídas do seu docker-compose)
DB_USER = "agro_user"
DB_PASS = "agro_password"
DB_HOST = "localhost"
DB_PORT = "5433" # Atenção aqui: é a porta externa que você mapeou!
DB_NAME = "agro_db"

# String de conexão
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)

print("Conectado ao banco PostgreSQL com sucesso!")

# 2. Simulação da Extração de Dados (Ingestão)
# No mundo real, aqui você usaria 'requests.get(url)' para puxar de uma API
print("Simulando extração de dados de preços de commodities...")

datas = [datetime.now() - timedelta(days=i) for i in range(30)]
dados = {
    "data_registro": datas,
    "produto": [random.choice(["Soja", "Milho"]) for _ in range(30)],
    "preco_saca_rs": [round(random.uniform(80.0, 150.0), 2) for _ in range(30)]
}

df_precos = pd.DataFrame(dados)

# 3. Carga (Load) no Banco de Dados
# Vamos jogar na tabela 'raw_precos' (camada bruta)
tabela_destino = 'raw_precos'

print(f"Carregando {len(df_precos)} linhas na tabela '{tabela_destino}'...")

# O parametro if_exists='replace' recria a tabela toda vez que rodar (bom para desenvolvimento)
df_precos.to_sql(
    name=tabela_destino, 
    con=engine, 
    if_exists='replace', 
    index=False
)

print("✅ Ingestão concluída com sucesso! Dados prontos para o dbt.")