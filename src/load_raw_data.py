import pandas as pd
import psycopg2
from io import StringIO


# Database connection configuration
DB_NAME = "order_analytics"
DB_USER = "analytics_user"
DB_PASSWORD = "analytics_pwd"
DB_HOST = "localhost"
DB_PORT = "5433"

FILE_PATH = "data/raw/E-Commerce DataSet.xlsx"

print("Reading Excel file...")
df = pd.read_excel(FILE_PATH)

# Connect to PostgreSQL
print("Connecting to PostgreSQL...")
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cur = conn.cursor()

# Load data using COPY
print("⬆️  Loading data into raw.orders_line_items...")

buffer = StringIO()
df.to_csv(buffer, index=False, header=False)
buffer.seek(0)

cur.copy_expert(
    """
    COPY raw.orders_line_items (
        rec_id,
        order_id,
        order_date,
        shipped_at,
        prod_sku,
        prod_qty
    )
    FROM STDIN WITH CSV
    """,
    buffer
)

conn.commit()
cur.close()
conn.close()

print("Raw data loaded successfully into raw.orders_line_items")