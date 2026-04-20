{{ config(materialized='view') }}

SELECT 
    data,
    preco_saca_milho,
    preco_futuro_cbot,
    regiao,
    (preco_saca_milho - preco_futuro_cbot) as premio_regiao,
    
    ROUND((preco_saca_milho * 0.55)::numeric, 2) as custo_estimado_producao,
    ROUND((preco_saca_milho - preco_saca_milho * 0.55)::numeric, 2) as margem_bruta_estimada,
    ROUND(((preco_saca_milho - preco_saca_milho * 0.55) / preco_saca_milho * 100)::numeric, 2) as margem_bruta_percentual
FROM {{ ref('precos_milho') }}