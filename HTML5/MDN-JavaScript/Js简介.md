# JavaScipt
![](Note_files/1.jpg)

## A example
![](Note_files/2.jpg)
![](Note_files/3.jpg)
## **源代码可以看本目录下的example**

## API
![](Note_files/4.jpg)
![](Note_files/5.jpg)
![](Note_files/6.jpg)
![](Note_files/7.jpg)

![](Note_files/8.jpg)
![](Note_files/9.jpg)
![](Note_files/10.jpg) 

## 脚本依赖关系处理
![](Note_files/11.jpg)
![](Note_files/12.jpg)

## 代码调错
![](Note_files/13.jpg)
![](Note_files/14.jpg)
 
 ## 字符串对象
 ![](Note_files/15.jpg)
 ![](Note_files/16.jpg)
 
 ![](Note_files/17.jpg)
 ![](Note_files/18.jpg)
 ![](Note_files/19.jpg)
 ![](Note_files/20.jpg)
 ![](Note_files/21.jpg)
 
 ![](Note_files/22.jpg)
 ### solution
 ```javascript
 const list = document.querySelector('.output ul');
 list.innerHTML = '';
 let greetings = ['Happy Birthday!',
                  'Merry Christmas my love',
                  'A happy Christmas to all the family',
                  'You\'re all I want for Christmas',
                  'Get well soon'];
 
 for (let i = 0; i < greetings.length; i++) {
   let input = greetings[i];
   if (greetings[i].indexOf('Christmas') !== -1) {
     let result = input;
     let listItem = document.createElement('li');
     listItem.textContent = result;
     list.appendChild(listItem);
   }
 }
 ```
 
 
 ![](Note_files/23.jpg)
  ### solution
 ```javascript
 const list = document.querySelector('.output ul');
 list.innerHTML = '';
 let cities = ['lonDon', 'ManCHESTer', 'BiRmiNGHAM', 'liVERpoOL'];
 
 for (let i = 0; i < cities.length; i++) {
   let input = cities[i];
   let lower = input.toLowerCase();
   let firstLetter = lower.slice(0,1);
   let capitalized = lower.replace(firstLetter,firstLetter.toUpperCase());
   let result = capitalized;
   let listItem = document.createElement('li');
   listItem.textContent = result;
   list.appendChild(listItem);
 
 }
 ```
 ## Array
 ![](Note_files/24.jpg)
 ![](Note_files/25.jpg)
 ![](Note_files/26.jpg)
 ![](Note_files/27.jpg)
 ![](Note_files/28.jpg)
 ![](Note_files/29.jpg)
 ![](Note_files/30.jpg)
 
 ## document.getElementById
 ![](Note_files/31.jpg)
 ![](Note_files/34.jpg)
 
 
 