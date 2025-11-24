import pandas as pd
import os
from constants import IN_PLAYER_FOLDER, IN_PRICE_FOLDER, IN_GAMES_FILE_PATH, IN_REVIEWS_FILE_PATH, OUT_PLAYER_FILE_PATH, OUT_PRICE_FILE_PATH, OUT_GAMES_FILE_PATH, OUT_REVIEWS_FILE_PATH


print("Row data")

pd.set_option('display.max_columns', None)

for folder in [IN_PLAYER_FOLDER, IN_PRICE_FOLDER]:
    files = os.listdir(folder)

    file_example = files[0]
    file_path = os.path.join(folder, file_example)

    print(f"File: {file_path}")

    temp_df = pd.read_csv(file_path)
    print(temp_df.info())
    print(temp_df.describe())   
    

for file_path in [IN_GAMES_FILE_PATH, IN_REVIEWS_FILE_PATH]:
    print(f"File: {file_path}")

    temp_df = pd.read_csv(file_path)
    print(temp_df.info())
    print(temp_df.describe())

print("Cleaned data")

for file_path in [OUT_PLAYER_FILE_PATH, OUT_PRICE_FILE_PATH, OUT_GAMES_FILE_PATH, OUT_REVIEWS_FILE_PATH]:
    print(f"File: {file_path}")

    temp_df = pd.read_csv(file_path)
    print(temp_df.info())
    print(temp_df.describe())