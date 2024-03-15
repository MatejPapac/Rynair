import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql://postgres:admin@localhost/rynair'
db = create_engine(conn_string)
conn = db.connect()


df = pd.read_csv(r"C:\Users\matas\Desktop\Programi ML\Ryanair\Rynair\ryanair_dataset.csv")
df.to_sql('rynair', con=conn, if_exists='replace', index=False)