import pandas as pd
from sqlalchemy import create_engine, text
from datetime import datetime, timedelta
import random

DATABASE_URL = "postgresql://agro_user:agro_password@13.222.170.228:5432/agro_db"
engine = create_engine(DATABASE_URL)

print("Conectado ao banco PostgreSQL com sucesso!")

# OPÇÃO NUCLEAR: Destroi a tabela velha e qualquer view que depender dela
with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS raw_precos CASCADE;"))
    conn.commit()
    print("Tabela antiga destruída. Limpando a mesa para os dados novos...")

# Simulação Realista: 6 meses, 3 regiões
datas = [datetime.now() - timedelta(days=i) for i in range(180)]
regioes = ['GO', 'MT', 'MS']
dados = []

for dia in datas:
    for regiao in regioes:
        preco_base = random.uniform(75.0, 145.0)
        if dia.month in [2, 3, 4]: 
            preco_base *= 1.15
        else: 
            preco_base *= 0.90
            
        dados.append({
            "data_registro": dia,
            "produto": "Soja",
            "regiao": regiao,
            "preco_saca_rs": round(preco_base, 2)
        })

df_precos = pd.DataFrame(dados)

tabela_destino = 'raw_precos'
print(f"Criando tabela nova e carregando {len(df_precos)} linhas reais simuladas...")

# Usamos 'append' porque a tabela não existe mais. O Python vai criá-la zerada.
df_precos.to_sql(
    name=tabela_destino, 
    con=engine, 
    if_exists='append', 
    index=False
)

print("✅ Ingestão de mercado concluída! Dados prontos para o dbt.")