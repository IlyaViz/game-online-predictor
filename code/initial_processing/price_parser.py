import pandas as pd
import os
from constants import IN_PRICE_FOLDER, OUT_PRICE_FILE_PATH


def parse_price():
    files = os.listdir(IN_PRICE_FOLDER)
    counter = 0 
    all_df = []

    for file in files:
        counter += 1

        file_path = os.path.join(IN_PRICE_FOLDER, file)
        temp_df = pd.read_csv(file_path)

        temp_df["appid"] = os.path.splitext(file)[0]

        all_df.append(temp_df)

        print(f"{counter/len(files) * 100}% done")

    df = pd.concat(all_df)
    df = df.reindex(sorted(df.columns, reverse=True), axis=1)
    df.to_csv(OUT_PRICE_FILE_PATH, index=False)



