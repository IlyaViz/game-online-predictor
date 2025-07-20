import pandas as pd
import os
from constants import IN_PLAYER_FOLDER, OUT_PLAYER_FILE_PATH


def parse_player():
    files = os.listdir(IN_PLAYER_FOLDER)
    counter = 0 
    all_df = []

    for file in files:
        counter += 1

        file_path = os.path.join(IN_PLAYER_FOLDER, file)
        temp_df = pd.read_csv(file_path)

        temp_df["appid"] = os.path.splitext(file)[0]

        temp_df = temp_df.dropna(subset=["Playercount"])

        temp_df["Date"] = pd.to_datetime(temp_df["Time"]).dt.date
        temp_df.drop(columns=["Time"], inplace=True)

        temp_df = temp_df.groupby(["Date", "appid"])["Playercount"].mean().round(0).astype(int).reset_index()

        all_df.append(temp_df)

        print(f"{counter/len(files) * 100}% done")

    df = pd.concat(all_df)
    df = df.reindex(sorted(df.columns, reverse=True), axis=1)
    df.to_csv(OUT_PLAYER_FILE_PATH, index=False)
