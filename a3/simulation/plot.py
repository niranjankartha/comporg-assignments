import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("output.csv")
print(df.head())
df['iratio'] = df['ITLB hit'] / (df['ITLB hit'] + df['ITLB miss'])
df['dratio'] = df['DTLB hit'] / (df['DTLB hit'] + df['DTLB miss'])
df['sratio'] = df['STLB hit'] / (df['STLB hit'] + df['STLB miss'])
df['TLB hit'] = df['ITLB hit'] + df['STLB hit'] + df['DTLB hit']
df['TLB miss'] = df['ITLB miss'] + df['STLB miss'] + df['DTLB miss']
df['ratio'] = df['TLB hit'] / (df['TLB hit'] + df['TLB miss'])

# sns.scatterplot(y='iratio', x='lg2_pagesize', hue='levels', palette='rainbow', data=df)
sns.scatterplot(y='IPC', x='lg2_pagesize', hue='levels', palette='rainbow', data=df)
# sns.scatterplot(y='dratio', x='columns', hue='lg2_pagesize', palette='rainbow', data=df)

# sns.scatterplot(y='ratio', x='levels', hue='lg2_pagesize', palette='rainbow', data=df)

plt.show()
