import os
import pandas as pd
from sklearn.feature_extraction.text import  TfidfVectorizer
import joblib

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DATA_PATH = os.path.join(BASE_DIR, "..", "data")

job_df = pd.read_csv(os.path.join(DATA_PATH, 'clean_jobs.csv'))

job_df['content'] = (
    job_df['title'] + ' ' +
    job_df['description'] + ' ' +
    job_df['location'] + ' ' +
    job_df['work_type'] + ' ' +
    job_df['employment_type']
)

vectorizer = TfidfVectorizer()
tfidf_matrix = vectorizer.fit_transform(job_df['content'])

MODEL_PATH = os.path.join(BASE_DIR, "..", "model")

joblib.dump(vectorizer, os.path.join(MODEL_PATH, 'vectorizer.pkl'))
joblib.dump(tfidf_matrix, os.path.join(MODEL_PATH, 'tfidf_matrix.pkl'))
joblib.dump(job_df, os.path.join(MODEL_PATH, 'job_df.pkl'))

print(f"Modelo entrenado con {len(job_df)} ofertas")
print("Archivos guardados")
