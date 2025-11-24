import pandas as pd
from constants import IN_GAMES_FILE_PATH, OUT_GAMES_FILE_PATH


def parse_games():
    df = pd.read_csv(IN_GAMES_FILE_PATH, usecols=["appid", "name", "release_date", "developer", "platforms", "required_age", "steamspy_tags", "achievements", "positive_ratings", "negative_ratings", "average_playtime", "median_playtime", "owners", "price"])

    df["owners"] = df["owners"].apply(lambda x: (int(x.split('-')[1]) + int(x.split('-')[0])) // 2)
    df["price"] = df["price"] * 1.26

    df.to_csv(OUT_GAMES_FILE_PATH, index=False)
