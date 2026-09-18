import pandas as pd
from faker import Faker
import random

fake = Faker(["en_NG"])

country_base_currency = {
    "Nigeria": "NGN",
    "Kenya": "KES",
    "Ghana": "GHS",
    "South Africa": "ZAR",
    "United States": "USD",
}

countries = list(country_base_currency.keys())
currencies = list(country_base_currency.values())

transaction_rows = []

for _ in range(1001):
    country = random.choice(countries)
    base_curr = country_base_currency[country]
    
    
    if random.random() < 0.75:
        curr = base_curr
    else:
        foreign_currencies = [c for c in currencies if c != base_curr]
        curr = random.choice(foreign_currencies)
        
    transaction_rows.append({
        "transaction_id": f"TXN_{fake.unique.random_number(digits=7, fix_len=True)}",
        "sender": fake.name(),
        "receiver": fake.name(),
        "amount": float(
            fake.pydecimal(min_value=100, max_value=20000000, right_digits=2)
        ),
        "currency": curr,
        "country": country,
        "channel": fake.random_element(
            elements=["card", "mobile money", "bank transfer"]
        ),
        "status": fake.random_element(elements=["success", "failed", "pending"]),
        "timestamp": fake.date_between(start_date="-2y", end_date="today"),
    })

df = pd.DataFrame(transaction_rows)
df.to_csv(
    "/home/shiva/afripay-intelligence-platform/data/transactions.csv", index=False
)