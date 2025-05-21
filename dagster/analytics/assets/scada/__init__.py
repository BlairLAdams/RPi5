from .bronze import bronze_sf_scada
from .silver import silver_sf_scada
from .gold import gold_sf_scada
from .docs import generate_dbt_docs

all_scada_assets = [
    bronze_sf_scada,
    silver_sf_scada,
    gold_sf_scada,
    generate_dbt_docs
]
