{{ config(materialized='table') }}

SELECT 
    data AS data,
    'Soja' AS commodity,
    regiao,
    preco_saca_soja AS preco_saca,
    margem_bruta_percentual,

    -- CRIANDO A COLUNA: Nível de Rentabilidade
    CASE 
        WHEN margem_bruta_percentual > 30 THEN 'Alta Rentabilidade'
        WHEN margem_bruta_percentual BETWEEN 10 AND 30 THEN 'Rentabilidade Média'
        WHEN margem_bruta_percentual BETWEEN 0 AND 10 THEN 'Margem Apertada'
        ELSE 'PREJUÍZO'
    END AS nivel_rentabilidade,

    -- CRIANDO A COLUNA: Recomendação
    CASE 
        WHEN margem_bruta_percentual > 40 THEN 'Vender agora (Margem excepcional)'
        WHEN margem_bruta_percentual BETWEEN 25 AND 40 THEN 'Aguardar pico de preço'
        WHEN margem_bruta_percentual BETWEEN 10 AND 25 THEN 'Hedging (Proteger preço)'
        ELSE 'NÃO VENDER (Abaixo do custo)'
    END AS recomendacao_venda

FROM {{ ref('stg_precos_soja') }}