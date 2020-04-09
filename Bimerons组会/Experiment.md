<font color=red size=10 face="宋体">2020-3-4</font>
***
<font color=blue size=6 face="宋体">**动力学 测试**</font>
***
### 1 .set current_density_CPP 1e12;# A/m^2

SKHE 效应过强导致bimerons快速跑到上边上

![](img/2.jpg)

![](img/1.jpg)


### 2 .set current_density_CPP 1e12;# A/m^2
<br/>
缓慢的右上移动

### 3 .set current_density_CPP 5e10;# A/m^2
<br/>
缓慢的右上移动

### 4 .set current_density_CPP 8e10;# A/m^2
<br/>
缓慢的右上移动




***
<font color=blue size=6 face="宋体">**Relax 测试**</font>
***
### SIMULATION WORLD
<li>set xlength  200.0e-9 ;# m</li>
<li>set ylength  200.0e-9 ;# m</li>
<li>set thickness  0.4e-9 ;# m</li>

### 1.DZYALOSHINSKI-MORIYA INTERACTION
**初始状态**
<br/>
![](img/5.jpg)


**set D 1.0 ;# mJ/m^2**
![](img/9.jpg)

**set D 3.0 ;# mJ/m^2**
![](img/4.jpg)


**set D 5.0 ;# mJ/m^2**
![](img/3.jpg)


**set D 7.0 ;# mJ/m^2**
![](img/6.jpg)


<font color=black size=5 face="宋体">**D=5 有形成skyrmions的趋势，可以把A调大测试**</font>

***
### 2.EXCHANGE STIFFNESS

**set A 10.0e-12 ;# J/m**
![](img/14.jpg)

**set A 13.0e-12 ;# J/m**
![](img/13.jpg)

**set A 15.0e-12 ;# J/m**
![](img/3.jpg)

**set A 17.0e-12 ;# J/m**
![](img/11.jpg)
 
**set A 20.0e-12 ;# J/m**
![](img/12.jpg)

<font color=black size=5 face="宋体">**D=5  K=15.0e-12 有形成skyrmions的趋势，可以把K调大测试**</font>
***
### 3.UNIAXIAL ANISOTROPY

**set K      0.1e6 ;# J/m^3**
![](img/17.jpg)
**set K      0.2e6 ;# J/m^3**
![](img/3.jpg)

**set K      0.5e6 ;# J/m^3**
![](img/16.jpg)

**set K      0.8e6 ;# J/m^3**
![](img/15.jpg)




<font color=red size=6 face="宋体">**500*500nm simualtion word**</font>
***
### SIMULATION WORLD
<ul>set xlength  500.0e-9 ;# m</ul>
<ul>set ylength  500.0e-9 ;# m</ul>
<ul>set thickness  0.4e-9 ;# m</ul>

### set K      0.12e6 ;# J/m^3

<img src="img/15.jpg" width=100% height=100% align="left" />


<font color=red size=10 face="宋体">2020-3-5</font>
***
### 由于在500*500nm下relax失败，我们修改了relax的初始状态，这时我们让体系的初始状态就是Bimerons!

![](img/7.jpg)

<font color=blue size=5 face="宋体">**realx之后的结果**</font>
![](img/8.jpg)

<font color=blue size=5 face="宋体">**把K值统一之后重新relax的结果**</font>

![](img/10.jpg)

<font color=red size=6 face="宋体">**500nm Atlas下Bimerons的动力学研究**</font>
### 初始状态
![](img/20.jpg)
### 结束状态 set current_density_CPP 1e12;# A/m^2
![](img/18.jpg)

### 结束状态 set current_density_CPP 5e11;# A/m^2
![](img/19.jpg)
