import os
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import  TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DATA_PATH = os.path.join(BASE_DIR, ".." ,'data')

fake_df = pd.read_csv(os.path.join(DATA_PATH, 'Fake.csv'))
true_df = pd.read_csv(os.path.join(DATA_PATH, 'True.csv'))

# Add a column to the dataframes to indicate the source of the data
fake_df['label'] = 0
true_df['label'] = 1 

# Concatenate the dataframes
df = pd.concat([fake_df, true_df], ignore_index=True)

df['content'] = df['title'] + ' ' + df['text']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(df['content'], df['label'], test_size=0.2, random_state=42)

pipeline = Pipeline([
    ('tfidf', TfidfVectorizer()),
    ('classifier', LogisticRegression())
])

pipeline.fit(X_train, y_train)

accuracy = pipeline.score(X_test, y_test)

print(f"Accuracy: {accuracy:.4f}")

MODEL_PATH = os.path.join(BASE_DIR, '..', 'model', 'fake_news_model.pkl')
joblib.dump(pipeline, MODEL_PATH)