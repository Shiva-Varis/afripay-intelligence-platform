from faker import Faker
import pandas as pd

fake = Faker(["en_NG"])
country_currency = {'Nigeria': 'NGN', 'Kenya': 'KES', 'Ghana': 'GHS', 'South Africa': 'ZAR', 'United States': 'USD'}
pairs = list(country_currency.items())
transaction_rows = [
    {
        "transaction_id": f"TXN_{fake.unique.random_number(digits=7, fix_len=True)}",
        "sender": fake.name(),
        "receiver": fake.name(),
        "amount": f"{fake.random_int(min=50, max=100000000):,.2f}",
        "currency": curr,
        "country": country,
        "channel": fake.random_element(elements=['card', 'mobile money', 'bank transfer']),
        "status": fake.random_element(elements=['success', 'failed', 'pending']),
        "timestamp": fake.date_between(start_date="-2y", end_date="today")
    }
    for country, curr in (fake.random_element(elements=pairs) for _ in range(1001))
]
df = pd.DataFrame(transaction_rows)
df.to_csv('/home/shiva/afripay-intelligence-platform/data/transactions.csv', index=False)