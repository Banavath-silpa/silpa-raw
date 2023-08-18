{{ config(
    materialized='incremental',
    partition_by={
          "field": "processed_ts",
          "data_type": "timestamp",
          "granularity": "day"
        }
) }}
	
select
	testing_srgt_key
	name,
	branch,
	id,
	date_year,
	processed_file_name,
    processed_ts
from {{ ref('silpa_raw_stg.sql') }} temp
where temp.failure_reason is null

{% if is_incremental() %}
    and temp.processed_ts > ( select COALESCE(max(processed_ts), TIMESTAMP('2000-01-01 00:00:00.0000')) from {{ this }} )
{% endif %}
