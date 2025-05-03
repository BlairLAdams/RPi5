# geocode_site_asset.py

from dagster import asset
import pandas as pd
from sqlalchemy import create_engine
from geopy.geocoders import Nominatim
import os

@asset
def geocode_site_coordinates():
    """
    Dagster asset that extracts unique site names from the silverWq table,
    geocodes them using OpenStreetMap (via geopy), and writes the result
    to the bronze_silver_wq.site_coordinates table in PostgreSQL.
    """
    # ✅ Step 1: Load DB connection (adjust as needed)
    db_url = os.getenv("POSTGRES_URL", "postgresql://blair@localhost:5432/grafana")
    engine = create_engine(db_url)

    # ✅ Step 2: Extract distinct site names
    query = "SELECT DISTINCT site FROM bronze_silver_wq.\"silverWq\" WHERE site IS NOT NULL;"
    sites_df = pd.read_sql(query, engine)

    # ✅ Step 3: Geocode using Nominatim
    geolocator = Nominatim(user_agent="site_geocoder")

    def lookup_coords(site):
        try:
            location = geolocator.geocode(site + ", California")
            if location:
                return pd.Series([location.latitude, location.longitude])
        except Exception as e:
            print(f"Warning: Failed to geocode '{site}': {e}")
        return pd.Series([None, None])

    sites_df[["latitude", "longitude"]] = sites_df["site"].apply(lookup_coords)

    # ✅ Step 4: Write results back to PostgreSQL
    sites_df.to_sql(
        name="site_coordinates",
        con=engine,
        schema="bronze_silver_wq",
        if_exists="replace",
        index=False
    )

    print("✅ Geocoding complete. site_coordinates table updated.")
