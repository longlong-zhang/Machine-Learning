## Chemical Space课题笔记
<font color=red size=4 face="TimesNewRoman"><b>&sect; &brvbar; Weighted Network Analysis of Biologically Relevant Chemical Spaces</b></font>
```
ArXiv ID:arXiv:1911.05259v1
```
****
### Abstract
<em>We investigated the relationship between the strength of the link connection and the bioactivity closeness in the weighted networks. We found that compounds with significantly high or low bioactivity have a stronger connection than those in the overall network</em>

### Key points
- >怎么构建Weighted Space
1. In the network representation of these compounds, a node represents a compound, and a link between two nodes is drawn if the similarity between them exceeds a preset threshold.
2. where the weight of each link is the similarity between connecting compounds.
- >what is Tanimoto coefficien ?
1. We defined the weighted network where the weight of each link between the nodes equals the Tanimoto coefficient between the bioactive compounds (nodes) .
2. For two molecules that have fingerprints x<sub>i</sub> and x<sub>j</sub>, the Tanimoto coefficient T<sub>ij</sub>  is calculated as
$$T_{i j}=\frac{\mathbf{x}_{i} \cdot \mathbf{x}_{j}}{\left|\mathbf{x}_{i}\right|^{2}+\left|\mathbf{x}_{j}\right|^{2}-\mathbf{x}_{i} \cdot \mathbf{x}_{j}}$$
<b>Note:</b> The fingerprint description is a bit string where each bit indicates the existence of predefined substructure 

- >how strength is distributed in each weighted network ?
1. 通过 modularity Q 来判别：
$$Q=\frac{1}{2 m} \sum_{i, j} M_{i j} \delta(c(i), c(j))$$
2.  Q<sub>C</sub> can measure how strongly links within C are connected without considering other communities.
![](img/2020-03-23-23-18-32.png)

&emsp; &emsp;按照定义，当node i 和node j 属于同一个群的时候$\delta=1$,反之$\delta=0$

- >what is pChEMBL value ?
1. We regard the pChEMBL value of the compound as an indicator of its bioactivity[19][20]
2. The larger the <b>pChEMBL value</b>, the stronger is the bioactivity against the target 

- >whether nodes connected with high similarity tend to share similar bioactivity?(核心问题！)
1.  This suggests that certain sets of compounds are similar to each other and share stronger/weaker bioactivity against the target than the compounds in general.
2.  Therefore, the sets of nodes with high/low pChEMBL values in particular are connected with stronger weights than the overall network
3. However, we observed that nodes with high/low bioactivity against the target were connected strongly to each other compared to the nodes of the overall network.--最终结论
![](img/2020-03-23-22-52-54.png)

### Result(补充说明)

1. in each network. As shown, many nodes share a similar strength, while a few nodes exhibit small strength. No node exhibited extremely large strength in all networks.
![](img/2020-03-23-22-40-38.png)

### 文章的意义
>If the novel compound is structurally similar to compounds in a community sharing high bioactivity, we can expect it to exhibit high bioactivity. Such a prediction is useful in drug discovery.


<font color=red size=4 face="TimesNewRoman"><b>&sect; &brvbar; Combining Similarity Searching and Network Analysis for the Identification of Active Compounds</b></font>
```
DOI:10.1021/acsomega.8b00344
```
****
![](img\微信截图_20200319234947.png)


****
<font color=red size=4 face="TimesNewRoman"><b>&sect; &brvbar; Combining Chemical space exploration guided by deep neural networks†</b></font>
```
DOI:10.1039/c8ra10182e
```
### Abstract
<em>
The work flow consists of three main stages. First, we trained a set of the mapper functions varying the perplexity level in the loss function with the over fitting controlled by the external test set (Fig. 1). Second, since the dimensionality reduction techniques lead to information loss, we trained a set of classifiers on the mapped 2D data and compared the resulting accuracy. Third, we provide the visualization and analysis of the TAAR1 data set taken from Pubchem
</em>
#### Main point
- >waht is chemical space?
1. Chemical space is usually considered as the union of all feasible chemical compounds.
2. it is an information-losing projection from multi- dimensional molecular space (commonly described by molec- ular descriptors, so-called descriptor space) into two- or three- dimensional space, in which humans can operate easily
- >chemical space visulation method
1. The majority of chemical space visualization methods use two discrete procedures: (i) calculation of molecular descriptors (ii) performing a projection from descriptor space into a 2D plane or 3D volume by one of several known techniques.
- >dimensionality reduction techniques
1. Principal Component Analysis (PCA)
2. The method of Self-Organizing Maps
(SOM)
3.  Scaffold Trees

4. Parametric t-SNE(new)

5. parametric t-SNE

- >what is fingerprint description?

1. The fingerprint description is a bit string where each bit indicates the existence of predefined substructure (MACCS Structural Keys; Symyx Soware: San Ramon, CA, 2002.) or the certain atom types in the predefined atomic environment (ECFP fingerprints). 

- >what is Principal Component Analysis (PCA)?

1. The algorithm of Principal Component Analysis (PCA) performs an iterative search of directions with the highest variation in a multidimensional data space

- >what is parametric t-SNE?

1. In parametric t-SNE, a function which performs a mapping from the high-dimensional descriptor space to a low-dimensional space (2D or 3D) f: X / Y is a normal feed-forward neural network with trainable weights.
![](img/2020-03-23-16-12-28.png)
### Validation protocols
To control over fitting during training our mapper ANN we used 10% of the data as test set.


### Results
![](img/2020-03-23-16-14-40.png)



