import os


ROW_FOLDER = "row"
CLEANED_FOLDER = "cleaned"

IN_PLAYER_FOLDER = os.path.join(ROW_FOLDER, "player")
IN_PRICE_FOLDER = os.path.join(ROW_FOLDER, "price")
IN_GAMES_FILE_PATH = os.path.join(ROW_FOLDER, "games.csv")
IN_REVIEWS_FILE_PATH = os.path.join(ROW_FOLDER, "reviews.csv")

OUT_PLAYER_FILE_PATH = os.path.join(CLEANED_FOLDER, "online.csv")
OUT_PRICE_FILE_PATH = os.path.join(CLEANED_FOLDER, "price.csv")
OUT_GAMES_FILE_PATH = os.path.join(CLEANED_FOLDER, "games.csv")
OUT_REVIEWS_FILE_PATH = os.path.join(CLEANED_FOLDER, "reviews.csv")