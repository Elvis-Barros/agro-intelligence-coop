import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import plotly.express as px

st.set_page_config(page_title="Agro Intelligence Coop", layout="wide", page_icon="🌱")

st.title("🌱 Commercial Intelligence & Risk Platform")
st.markdown("### Plataforma de Inteligência Comercial para Cooperativas e Distribuidoras de Insumos")

# Conexão
engine = create_engine("postgresql://agro_user:agro_password@13.222.170.228:5432/agro_db")

# Carrega os dados
df = pd.read_sql("""
    SELECT * FROM dev.mart_rentabilidade_soja 
    ORDER BY data DESC, commodity
""", engine)

# Sidebar - Filtros
st.sidebar.header("Filtros")
commodities = st.sidebar.multiselect("Commodity", options=df['commodity'].unique(), default=df['commodity'].unique())
regioes = st.sidebar.multiselect("Região", options=df['regiao'].unique(), default=df['regiao'].unique())
niveis = st.sidebar.multiselect("Nível de Rentabilidade", options=df['nivel_rentabilidade'].unique(), default=df['nivel_rentabilidade'].unique())

df_filtrado = df[
    (df['commodity'].isin(commodities)) &
    (df['regiao'].isin(regioes)) &
    (df['nivel_rentabilidade'].isin(niveis))
]

# Métricas
col1, col2, col3, col4 = st.columns(4)
col1.metric("Preço Médio", f"R$ {df_filtrado['preco_saca'].mean():.2f}")
col2.metric("Margem Bruta Média", f"{df_filtrado['margem_bruta_percentual'].mean():.1f}%")
col3.metric("Recomendações 'Vender Agora'", len(df_filtrado[df_filtrado['recomendacao_venda'].str.contains("Vender agora", na=False)]))
col4.metric("Registros Analisados", len(df_filtrado))

# Tabs
tab1, tab2, tab3 = st.tabs(["📊 Visão Geral", "🔍 Análise por Commodity", "💡 Recomendações"])

with tab1:
    st.dataframe(df_filtrado, use_container_width=True, hide_index=True)
    
    col_a, col_b = st.columns(2)
    with col_a:
        st.plotly_chart(px.bar(df_filtrado, x='data', y='margem_bruta_percentual', color='commodity',
                              title="Evolução da Margem Bruta"), use_container_width=True)
    with col_b:
        st.plotly_chart(px.pie(df_filtrado, names='nivel_rentabilidade', title="Distribuição de Rentabilidade"), use_container_width=True)

with tab2:
    st.plotly_chart(px.bar(df_filtrado.groupby(['commodity', 'regiao'])['margem_bruta_percentual'].mean().reset_index(),
                          x='regiao', y='margem_bruta_percentual', color='commodity',
                          title="Margem Bruta Média por Região e Commodity"), use_container_width=True)

with tab3:
    st.subheader("💡 Recomendações Inteligentes")
    recomendacoes = df_filtrado[df_filtrado['recomendacao_venda'].str.contains("Vender agora", na=False)]
    
    if not recomendacoes.empty:
        st.success(f"✅ **{len(recomendacoes)} oportunidades de venda identificadas**")
        st.dataframe(recomendacoes[['commodity', 'data', 'regiao', 'preco_saca', 'margem_bruta_percentual', 'recomendacao_venda']], 
                    use_container_width=True)
    else:
        st.info("Nenhuma recomendação de venda imediata no momento.")

st.caption("Projeto Portfólio • Commercial Intelligence & Risk | Elvis Barros | Engenharia de Dados no Agronegócio")