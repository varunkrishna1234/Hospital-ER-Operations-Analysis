import pandas as pd
import numpy as np
from sqlalchemy import create_engine
import urllib.parse

# CONFIGURATION
db_user = 'root'
db_password = 'Rangachary@2' # <--- UPDATE THIS
db_host = 'localhost'
db_name = 'hospital_analytics_db'

#  GENERATE HOSPITAL DATA
print("Generating 10,000 Patient Records...")
np.random.seed(42)
rows = 10000

dates = pd.date_range(start='2024-01-01', end='2024-12-31', freq='h')
visit_times = np.random.choice(dates, rows)

data = {
    'visit_id': range(1, rows + 1),
    'visit_timestamp': visit_times,
    'triage_level': np.random.choice([1, 2, 3, 4, 5], rows, p=[0.05, 0.15, 0.35, 0.30, 0.15]),
    'patient_age': np.random.randint(1, 95, rows),
    'patient_gender': np.random.choice(['Male', 'Female'], rows),
    'insurance_type': np.random.choice(['Private', 'Medicare', 'Uninsured'], rows, p=[0.5, 0.3, 0.2]),
    'admission_source': np.random.choice(['Ambulance', 'Walk-In', 'Referral'], rows, p=[0.2, 0.7, 0.1]),
    'staff_on_duty': np.random.randint(3, 15, rows)
}

df = pd.DataFrame(data)

# Logic: Wait time depends on Triage Level + Staffing
df['wait_time_minutes'] = (
    (df['triage_level'] * 15) + 
    (100 / df['staff_on_duty']) + 
    np.random.normal(0, 5, rows)
).astype(int)

df['wait_time_minutes'] = df['wait_time_minutes'].clip(lower=0)

# Extract Analysis Columns
df['hour_of_day'] = df['visit_timestamp'].dt.hour
df['day_of_week'] = df['visit_timestamp'].dt.day_name()

#  UPLOAD TO MYSQL
encoded_password = urllib.parse.quote_plus(db_password)
connection_str = f"mysql+pymysql://{db_user}:{encoded_password}@{db_host}/{db_name}"
engine = create_engine(connection_str)

print("Uploading 10,000 rows to MySQL...")
try:
    df.to_sql('er_visits', con=engine, if_exists='replace', index=False)
    print("SUCCESS: Data Loaded! You can now run your SQL queries.")
except Exception as e:
    print(f"Error: {e}")