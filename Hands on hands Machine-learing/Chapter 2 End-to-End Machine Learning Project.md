## Chapter 2 End-to-End Machine Learning Project
![](img/2020-03-22-10-04-25.png)
#### California Housing Prices (房价预测实例)
![](img/2020-03-22-10-06-21.png)
##### 房价问题的定性
![](img/2020-03-22-10-08-38.png)

##### Select a Performance Measure
A typical performance measure for regression problems is the Root Mean Square Error (RMSE). It measures the standard deviation 4 of the errors the system makes in its predictions.

###### Equation 2-1. Root Mean Square Error (RMSE)
$$\operatorname{RMSE}(\mathbf{X}, h)=\sqrt{\frac{1}{m} \sum_{i=1}^{m}\left(h\left(\mathbf{x}^{(i)}\right)-y^{(i)}\right)^{2}}$$

![](img/2020-03-22-10-15-22.png)
![](img/2020-03-22-10-15-50.png)
![](img/2020-03-22-10-16-05.png)

#### Coding

#####  the function to fetch the data(数据抓取)
```python
import os
import tarfile
from six.moves import urllib
DOWNLOAD_ROOT = "https://raw.githubusercontent.com/ageron/handson-ml/master/"
HOUSING_PATH = "datasets/housing"
HOUSING_URL = DOWNLOAD_ROOT + HOUSING_PATH + "/housing.tgz"
def fetch_housing_data(housing_url=HOUSING_URL, housing_path=HOUSING_PATH):
    if not os.path.isdir(housing_path):
       os.makedirs(housing_path)
    tgz_path = os.path.join(housing_path, "housing.tgz")
    urllib.request.urlretrieve(housing_url, tgz_path)
    housing_tgz = tarfile.open(tgz_path)
    housing_tgz.extractall(path=housing_path)
    housing_tgz.close()
```
##### load the data using Pandas(加载数据)
```python
import pandas as pd
def load_housing_data(housing_path=HOUSING_PATH):
    csv_path = os.path.join(housing_path, "housing.csv")
    return pd.read_csv(csv_path)
```
##### Take a Quick Look at the Data Structure(表格速览)
```python
housing = load_housing_data()
housing.head()
```
![](img/2020-03-22-15-52-55.png)
##### The info() method(表格信息总览)
The info() method is useful to get a quick description of the data, in particular the
total number of rows, and each attribute’s type and number of non-null values (see
Figure 2-6)
![](img/2020-03-22-15-55-59.png)

##### the value_counts() method:(子类方法)
You can find out what categories exist and how many
districts belong to each category by using the value_counts() method:
```python
housing["ocean_proximity"].value_counts()
```
![](img/2020-03-22-16-03-34.png)

#####  The describe() method(数值熟悉总览)
![](img/2020-03-22-16-04-04.png)

##### plot a histogram for each numerical attribute.(直方图特征速栏)
```python
%matplotlib inline # only in a Jupyter notebook
import matplotlib.pyplot as plt
housing.hist(bins=50, figsize=(20,15))
plt.show()
```
![](img/2020-03-22-16-10-02.png)
<b>Note:</b>attribute指代的是特征，比如longitude,lattitude,housing_median_age等
target attribute (your labels)：house value

#### Create a Test Set(测试文件的生成)
###### 方法一
```python
import numpy as np
def split_train_test(data, test_ratio):
    shuffled_indices = np.random.permutation(len(data))
    test_set_size = int(len(data) * test_ratio)
    test_indices = shuffled_indices[:test_set_size]
    train_indices = shuffled_indices[test_set_size:]
    return data.iloc[train_indices], data.iloc[test_indices]
```
![](img/2020-03-22-18-53-31.png)
解析：这个方法可行，但是并不完美：如果再次运行程序，就会产生一个不同的测试集！多次运行之后，你（或你的机器学习算法）就会得到整个数据集，这是需要避免的。因为测试集始终是你最后一个验证模型的数据集。


###### 方法二
![](img/2020-03-22-19-20-29.png)
解析：np.random.seed() 函数解决了上面的问题，但是当我们更新了原始数据库时这个方法就不行了。
<b>Note</b>
np.random.permutation()函数
https://blog.csdn.net/weixin_44188264/article/details/93752505
np.random.seed() 函数：固定随机·数组为唯一的一个
https://www.runoob.com/python/func-number-seed.html

###### 方法三（难）
```python
import hashlib
def test_set_check(identifier, test_ratio, hash):
    return hash(np.int64(identifier)).digest()[-1] < 256 * test_ratio
def split_train_test_by_id(data, test_ratio, id_column,      hash=hashlib.md5):
    ids = data[id_column]
    in_test_set = ids.apply(lambda id_: test_set_check(id_, test_ratio, hash))
    return data.loc[~in_test_set], data.loc[in_test_set]
```
Unfortunately, the housing dataset does not have an identifier column. The simplest solution is to use the row index as the ID:
```python
housing_with_id = housing.reset_index() # adds an `index` column
train_set, test_set = split_train_test_by_id(housing_with_id, 0.2, "index")
```
上面这种用row index 作为ID的方法不是很可靠，比如说你有删除过几行然后你又新添加几行，这样就导致上面的方法彻底乱套了。我们可以用下面的方法来生成一套更加可靠的ID:
```python
housing_with_id["id"] = housing["longitude"] * 1000 + housing["latitude"]
train_set, test_set = split_train_test_by_id(housing_with_id, 0.2, "id")
```
方法四：Scikit-Learn方法
```python
from sklearn.model_selection import train_test_split
train_set, test_set = train_test_split(housing, test_size=0.2, random_state=42)
```
<b>上面的四种方法都是采用了随机取样，这在样本数量足够大的情况下是OK的但是当样本数量不够大时我们应该采取加权取样法</b>
在房价问题上，该地区的人均收入是一个极其重要的attribute（特征，衡量指标），所以我们可以根据它来分配权重！
![](img/2020-03-22-20-05-58.png)
加权分配时应该注意我们不能有大多的分支，而且每个分支的数据也不能太少！所以我们把median income/1.5,并且把大于5的数据全部归入到分支5里。
```python
housing["income_cat"] = np.ceil(housing["median_income"] / 1.5)
housing["income_cat"].where(housing["income_cat"] < 5, 5.0, inplace=True)
```
Now you are ready to do stratified sampling based on the income category. For this you can use Scikit-Learn’s StratifiedShuffleSplit class:
```python
from sklearn.model_selection import StratifiedShuffleSplit
split = StratifiedShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
for train_index, test_index in split.split(housing, housing["income_cat"]):
    strat_train_set = housing.loc[train_index]
    strat_test_set = housing.loc[test_index]
```
Now you should remove the income_cat attribute so the data is back to its original
state:
```python
for set in (strat_train_set, strat_test_set):
    set.drop(["income_cat"], axis=1, inplace=True)
```

### Discover and Visualize the Data to Gain Insights
<b><em>Note:</em><b>数据集的备份
```python
housing = strat_train_set.copy()
```
- Visualizing Geographical Data

Since there is geographical information (latitude and longitude), it is a good idea to create a scatterplot of all districts to visualize the data (Figure 2-11):
```python
housing.plot(kind="scatter", x="longitude", y="latitude")
```
![](img/2020-03-22-20-22-43.png)
Setting the alpha option to 0.1 makes it much easier to visualize the places where there is a high density of data points (Figure 2-12):
```python
housing.plot(kind="scatter", x="longitude", y="latitude", alpha=0.1)
```
![](img/2020-03-22-20-25-37.png)
我们还能借用cmap来展示三维数据：我们可以把房价也在图中展示
```python
housing.plot(kind="scatter", x="longitude", y="latitude", alpha=0.4,
    s=housing["population"]/100, label="population",
    c="median_house_value", cmap=plt.get_cmap("jet"), colorbar=True,
)
plt.legend()
```
![](img/2020-03-22-20-36-14.png)
This image tells you that the housing prices are very much related to the location (e.g., close to the ocean) and to the population density, as you probably knew already.

- Looking for Correlations

Since the dataset is not too large, you can easily compute the standard correlation coefficient (also called Pearson’s r) between every pair of attributes using the corr() method:
```python
corr_matrix = housing.corr()
corr_matrix["median_house_value"].sort_values(ascending=False)
```
![](img/2020-03-22-20-39-58.png)
![](img/2020-03-22-20-40-43.png)
The correlation coefficient ranges from –1 to 1. When it is close to 1, it means that there is a strong positive correlation.
![](img/2020-03-22-20-41-54.png)
Since there are now 11 numerical attributes, you would get 11<sup>2 =121 plots, which would not fit on a page, so let’s just focus on a few promising attributes that seem most correlated with the median housing value (Figure 2-15):
```python
from pandas.tools.plotting import scatter_matrix
attributes = ["median_house_value", "median_income", "total_rooms",
             "housing_median_age"]
scatter_matrix(housing[attributes], figsize=(12, 8))
```
![](img/2020-03-22-20-50-50.png)
The most promising attribute to predict the median house value is the median income, so let’s zoom in on their correlation scatterplot (Figure 2-16):
```python
housing.plot(kind="scatter", x="median_income", y="median_house_value",
alpha=0.1)
```
![](img/2020-03-22-20-52-21.png)
This plot reveals a few things. First, the correlation is indeed very strong;

- Experimenting with Attribute Combinations
```python
housing["rooms_per_household"] = housing["total_rooms"]/housing["households"]
housing["bedrooms_per_room"] = housing["total_bedrooms"]/housing["total_rooms"]
housing["population_per_household"]=housing["population"]/housing["households"]
```
![](img/2020-03-22-20-56-03.png)

### Prepare the Data for Machine Learning Algorithms
在数据处理之前我们应当把房价(the target values)下剔除出数据库，我们不需要处理它，当然剔除后最好马上备份一下
```python
housing = strat_train_set.drop("median_house_value", axis=1)
housing_labels = strat_train_set["median_house_value"].copy()
```
- Data Cleaning
某些特征（attribute）可能是空值，这对我们的算法来说是个难以处理的问题，所以我们需要事先处理掉这些空值，有一下三种办法：
![](img/2020-03-22-21-14-58.png)
```python
housing.dropna(subset=["total_bedrooms"]) # option 1
housing.drop("total_bedrooms", axis=1) # option 2
median = housing["total_bedrooms"].median()
housing["total_bedrooms"].fillna(median) # option 3
```
在我们应用Scikit-Learn之后我们可以更轻松的处理这个问题：
```python
from sklearn.preprocessing import Imputer
imputer = Imputer(strategy="median")
```
但是中位数（median）只能适用于数值型特征（attribute），对于文本（text）属性的特征，我们可以事先也把它剔除出去：
```python
housing_num = housing.drop("ocean_proximity", axis=1)
```
Now you can fit the imputer instance to the training data using the fit() method:
```python
imputer.fit(housing_num)
```
Now you can use this “trained” imputer to transform the training set by replacing missing values by the learned medians:
```python
X = imputer.transform(housing_num)
```
The result is a plain Numpy array containing the transformed features. If you want to put it back into a Pandas DataFrame, it’s simple:
```python
housing_tr = pd.DataFrame(X, columns=housing_num.columns)
```
- Handling Text and Categorical Attributes

在之前我们把文本型（text）数据排除在外，实际上我们也可以把文本型数据转换成数值型来处理：
Scikit-Learn provides a transformer for this task called LabelEncoder ：
```python
from sklearn.preprocessing import LabelEncoder
encoder = LabelEncoder()
housing_cat = housing["ocean_proximity"]
housing_cat_encoded = encoder.fit_transform(housing_cat)
housing_cat_encoded
```
array([1, 1, 4, ..., 1, 0, 3])
<1H OCEAN” is mapped to 0, “INLAND” is mapped to 1, etc.
另外一种更好的编码模式：one-hot encoding
```python
>>> from sklearn.preprocessing import OneHotEncoder
>>> encoder = OneHotEncoder()
>>> housing_cat_1hot = encoder.fit_transform(housing_cat_encoded.reshape(-1,1))
>>> housing_cat_1hot
result:<16513x5 sparse matrix of type '<class 'numpy.float64'>'
with 16513 stored elements in Compressed Sparse Row format>
```
Notice that the output is a SciPy sparse matrix, instead of a NumPy array.我们需要手动去转换：
![](img/2020-03-22-22-03-25.png)
![](img/2020-03-22-22-03-43.png)
We can apply both transformations (from text categories to integer categories, then from integer categories to one-hot vectors) in one shot using the LabelBinarizer class：
![](img/2020-03-22-22-05-39.png)

- Custom Transformers（定制自己的Transformers）
```python
from sklearn.base import BaseEstimator, TransformerMixin
rooms_ix, bedrooms_ix, population_ix, household_ix = 3, 4, 5, 6
class CombinedAttributesAdder(BaseEstimator, TransformerMixin):
    def __init__(self, add_bedrooms_per_room = True): # no *args or **kargs
self.add_bedrooms_per_room = add_bedrooms_per_room
    def fit(self, X, y=None):
return self # nothing else to do
    def transform(self, X, y=None):
rooms_per_household = X[:, rooms_ix] / X[:, household_ix]
population_per_household = X[:, population_ix] / X[:, household_ix]
        if self.add_bedrooms_per_room:
bedrooms_per_room = X[:, bedrooms_ix] / X[:, rooms_ix]
        return np.c_[X, rooms_per_household, population_per_household,
bedrooms_per_room]
        else:
        return np.c_[X, rooms_per_household, population_per_household]
attr_adder = CombinedAttributesAdder(add_bedrooms_per_room=False)
housing_extra_attribs = attr_adder.transform(housing.values)
```
- Feature Scaling
![](img/2020-03-22-22-11-59.png)
- Transformation Pipelines
![](img/2020-03-22-22-17-00.png)

### Select and Train a Model
- Training and Evaluating on the Training Set
1. LinearRegression
```python
from sklearn.linear_model import LinearRegression
lin_reg = LinearRegression()
lin_reg.fit(housing_prepared, housing_labels)
```
上面的代码为我们搭建好了一个线性回归( LinearRegression)模型,之后我们就可以开始训练了。
```python
>>> some_data = housing.iloc[:5]
>>> some_labels = housing_labels.iloc[:5]
>>> some_data_prepared = full_pipeline.transform(some_data)
>>> print("Predictions:\t", lin_reg.predict(some_data_prepared))
Predictions: [ 303104. 44800. 308928. 294208. 368704.]
>>> print("Labels:\t\t", list(some_labels))
Labels: [359400.0, 69700.0, 302100.0, 301300.0, 351900.0]
```
Predictions是模型的预测值，而Labels是我们事先准备的标签（答案）用来检验预测结果的准确性。当然我们还可以通过计算RMSE值来定量衡量这个准确性：
```python
>>> from sklearn.metrics import mean_squared_error
>>> housing_predictions = lin_reg.predict(housing_prepared)
>>> lin_mse = mean_squared_error(housing_labels, housing_predictions)
>>> lin_rmse = np.sqrt(lin_mse)
>>> lin_rmse
68628.413493824875
```
误差有点大，我们换一个模型

2. Decision Trees
```python
from sklearn.tree import DecisionTreeRegressor
tree_reg = DecisionTreeRegressor()
tree_reg.fit(housing_prepared, housing_labels)
# 上面的代码完成了训练过程，之后就能检验了
>>> housing_predictions = tree_reg.predict(housing_prepared)
>>> tree_mse = mean_squared_error(housing_labels, housing_predictions)
>>> tree_rmse = np.sqrt(tree_mse)
>>> tree_rmse
0.0
```
0.0!!!震惊了，显然这是overfitting了。RMSE这时不是一个很好的衡量指标了，我们换Cross-Validation来重新算一下准确性
```python
from sklearn.model_selection import cross_val_score
scores = cross_val_score(tree_reg, housing_prepared, housing_labels,
scoring="neg_mean_squared_error", cv=10)
rmse_scores = np.sqrt(-scores)
>>> def display_scores(scores):
... print("Scores:", scores)
... print("Mean:", scores.mean())
... print("Standard deviation:", scores.std())
...
>>> display_scores(tree_rmse_scores)
Scores: [ 74678.4916885 64766.2398337 69632.86942005 69166.67693232
71486.76507766 73321.65695983 71860.04741226 71086.32691692
76934.2726093 69060.93319262]
Mean: 71199.4280043
Standard deviation: 3202.70522793
```
为了便于对比，我们当然也要用Cross-Validation来重新计算LinearRegression模型的准确性。
```python
>>> lin_scores = cross_val_score(lin_reg, housing_prepared, housing_labels,
... scoring="neg_mean_squared_error", cv=10)
...
>>> lin_rmse_scores = np.sqrt(-lin_scores)
>>> display_scores(lin_rmse_scores)
Scores: [ 70423.5893262 65804.84913139 66620.84314068 72510.11362141
66414.74423281 71958.89083606 67624.90198297 67825.36117664
72512.36533141 68028.11688067]
Mean: 68972.377566
Standard deviation: 2493.98819069
```
显然啊由于Decision Trees模型overfitting了导致它的误差更大了！我们需要修正一下它

### Random Forests 
Random Forests work by training many Decision Trees on random subsets of the features.

```python
>>> from sklearn.ensemble import RandomForestRegressor
>>> forest_reg = RandomForestRegressor()
>>> forest_reg.fit(housing_prepared, housing_labels)
>>> [...]
>>> forest_rmse
22542.396440343684
>>> display_scores(forest_rmse_scores)
Scores: [ 53789.2879722 50256.19806622 52521.55342602 53237.44937943
52428.82176158 55854.61222549 52158.02291609 50093.66125649
53240.80406125 52761.50852822]
Mean: 52634.1919593
Standard deviation: 1576.20472269
```
现在的结果显然变得更好了1576的SDE值很低了！


### Fine-Tune Your Model
什么是超参数(Hyperparameter)?

机器学习模型中一般有两类参数：一类需要从数据中学习和估计得到，称为模型参数（Parameter）---即模型本身的参数。比如，线性回归直线的加权系数（斜率）及其偏差项（截距）都是模型参数。还有一类则是机器学习算法中的调优参数（tuning parameters），需要人为设定，称为超参（Hyperparameter）。比如，正则化系数λ，决策树模型中树的深度。

参数和超参数的区别：

模型参数是模型内部的配置变量，需要用数据估计模型参数的值；模型超参数是模型外部的配置，需要手动设置超参数的值。机器学习中一直说的“调参”，实际上不是调“参数”，而是调“超参数”。

 

哪些属于超参数？

梯度下降法中的学习速率α，迭代次数epoch，批量大小batch-size，k近邻法中的k（最相近的点的个数），决策树模型中树的深度，等等。

 

超参数的优化：

有四种主要的策略可用于搜索最佳配置：
照看（babysitting，又叫试错）
网格搜索
随机搜索
贝叶斯优化

- Grid Search
for example, the following code searches for the best combi‐
nation of hyperparameter values for the RandomForestRegressor ；
```python
from sklearn.model_selection import GridSearchCV
param_grid = [
{'n_estimators': [3, 10, 30], 'max_features': [2, 4, 6, 8]},
{'bootstrap': [False], 'n_estimators': [3, 10], 'max_features': [2, 3, 4]},
]
forest_reg = RandomForestRegressor()
grid_search = GridSearchCV(forest_reg, param_grid, cv=5,
scoring='neg_mean_squared_error')
grid_search.fit(housing_prepared, housing_labels)
```








