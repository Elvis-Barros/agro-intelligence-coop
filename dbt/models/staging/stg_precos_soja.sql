{{ config(materialized='view') }}

-- Mapeamento da tabela crua (Raw) para o Staging de Negócio
SELECT 
    data_registro as data,
    preco_saca_rs as preco_saca_soja,
    
    -- CAMPOS SIMULADOS: Como a nossa API real ainda não foi conectada, 
    -- usamos NULL para o preço futuro e simulamos a região 'GO'. 
    -- TODO: Substituir por dados reais da API da B3/CBOT no futuro.
    NULL::numeric as preco_futuro_cbot, 
    'GO' as regiao,
    
    (preco_saca_rs - COALESCE(NULL, 0)) as premio_regiao,
    
    -- Custo variável por região
    CASE 
        WHEN 'GO' IN ('MT', 'MS') THEN ROUND( (preco_saca_rs * 0.58)::numeric , 2)
        WHEN 'GO' = 'GO' THEN ROUND( (preco_saca_rs * 0.62)::numeric , 2)
        ELSE ROUND( (preco_saca_rs * 0.65)::numeric , 2)
    END as custo_estimado_producao,

    -- Margem bruta
    ROUND( (preco_saca_rs - 
        CASE 
            WHEN 'GO' IN ('MT', 'MS') THEN preco_saca_rs * 0.58
            WHEN 'GO' = 'GO' THEN preco_saca_rs * 0.62
            ELSE preco_saca_rs * 0.65 
        END)::numeric , 2) as margem_bruta_estimada,

    -- Margem percentual
    ROUND( 
        ((preco_saca_rs - 
            CASE 
                WHEN 'GO' IN ('MT', 'MS') THEN preco_saca_rs * 0.58
                WHEN 'GO' = 'GO' THEN preco_saca_rs * 0.62
                ELSE preco_saca_rs * 0.65 
            END) / preco_saca_rs * 100)::numeric , 2
    ) as margem_bruta_percentual

FROM {{ source('raw', 'raw_precos') }}
WHERE produto = 'Soja' -- Filtra apenas os registros de soja da tabela crua