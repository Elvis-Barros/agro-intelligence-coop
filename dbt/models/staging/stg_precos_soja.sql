{{ config(materialized='view') }}

SELECT 
    data_registro as data,
    regiao,
    preco_saca_rs as preco_saca_soja,
    NULL::numeric as preco_futuro_cbot, 
    
    (preco_saca_rs - COALESCE(NULL, 0)) as premio_regiao,
    
    -- Custo fixo estimado por saca (não acompanha a bolsa de valores)
    CASE 
        WHEN regiao = 'MT' THEN 55.00
        WHEN regiao = 'MS' THEN 58.00
        WHEN regiao = 'GO' THEN 62.00
        ELSE 65.00
    END as custo_estimado_producao,

    -- Margem bruta absoluta (Reais por saca)
    ROUND( (preco_saca_rs - 
        CASE 
            WHEN regiao = 'MT' THEN 55.00
            WHEN regiao = 'MS' THEN 58.00
            WHEN regiao = 'GO' THEN 62.00
            ELSE 65.00 
        END)::numeric , 2) as margem_bruta_estimada,

    -- Margem bruta percentual (Agora sim, vai flutuar feio quando o preço cair!)
    ROUND( 
        ((preco_saca_rs - 
            CASE 
                WHEN regiao = 'MT' THEN 55.00
                WHEN regiao = 'MS' THEN 58.00
                WHEN regiao = 'GO' THEN 62.00
                ELSE 65.00 
            END) / preco_saca_rs * 100)::numeric , 2
    ) as margem_bruta_percentual

FROM {{ source('raw', 'raw_precos') }}
WHERE produto = 'Soja'