{{ config(materialized='table') }}

-- Soja
SELECT 
    'Soja' as commodity,
    data,
    regiao,
    preco_saca_soja as preco_saca,
    preco_futuro_cbot,
    premio_regiao,
    custo_estimado_producao,
    margem_bruta_estimada,
    margem_bruta_percentual,

    CASE 
        WHEN margem_bruta_percentual >= 45 THEN 'Excelente'
        WHEN margem_bruta_percentual >= 35 THEN 'Boa'
        WHEN margem_bruta_percentual >= 25 THEN 'Média'
        ELSE 'Baixa / Alto Risco'
    END as nivel_rentabilidade,

    CASE 
        WHEN premio_regiao > 10 THEN 'Vender agora (ótimo prêmio)'
        WHEN preco_saca_soja > 200 THEN 'Vender agora (preço alto)'
        WHEN margem_bruta_percentual < 30 THEN 'Aguardar ou fazer hedge'
        ELSE 'Monitorar'
    END as recomendacao_venda

FROM {{ ref('stg_precos_soja') }}

UNION ALL

-- Milho
SELECT 
    'Milho' as commodity,
    data,
    regiao,
    preco_saca_milho as preco_saca,
    preco_futuro_cbot,
    premio_regiao,
    custo_estimado_producao,
    margem_bruta_estimada,
    margem_bruta_percentual,

    CASE 
        WHEN margem_bruta_percentual >= 45 THEN 'Excelente'
        WHEN margem_bruta_percentual >= 35 THEN 'Boa'
        WHEN margem_bruta_percentual >= 25 THEN 'Média'
        ELSE 'Baixa / Alto Risco'
    END as nivel_rentabilidade,

    CASE 
        WHEN premio_regiao > 8 THEN 'Vender agora (ótimo prêmio)'
        WHEN preco_saca_milho > 95 THEN 'Vender agora (preço alto)'
        WHEN margem_bruta_percentual < 30 THEN 'Aguardar ou fazer hedge'
        ELSE 'Monitorar'
    END as recomendacao_venda

FROM {{ ref('stg_precos_milho') }}
ORDER BY data DESC, commodity