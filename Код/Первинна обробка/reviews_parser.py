import pandas as pd
from constants import IN_REVIEWS_FILE_PATH, OUT_REVIEWS_FILE_PATH


def parse_reviews():
    df = pd.read_csv(IN_REVIEWS_FILE_PATH, usecols=["app_id", "review_id", "timestamp_created", "recommended", "steam_purchase", "votes_helpful", "votes_funny", "author.playtime_at_review", "author.playtime_last_two_weeks", "language"])

    df["timestamp_created"] = pd.to_datetime(df["timestamp_created"], unit="s").dt.date

    df.to_csv(OUT_REVIEWS_FILE_PATH, index=False)
