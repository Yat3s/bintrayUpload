# BintrayUpload
A fast script to upload your project to maven/jcenter, you just run a command to user it.   
一个快速的脚本让你只需要运行一个命令即可上传你的项目到maven库。

## Ready / 准备
Yeah, you must have a bintray account. here to signup https://bintray.com  
Then you forward https://bintray.com/profile/edit   
Click **apikey** and takes note **user name** and **apikey**  
like this


你需要一个bintray的账号，这里注册：https://bintray.com    
然后到https://bintray.com/profile/edit    
点击apikey，记录下自己的apikey和username。

## Start / 开始
Yeah, we have completed 50%.   
Then you need download **uploadToBintray.sh**, and put it under your module. eg: CustomView/app/uploadToBintray.sh    
Open your terminal or use terminal in your android studio  and go to your app path  (maybe: cd app)  
Run ./uploadToBintray.sh, then you will know how to do that.  
Congratulation！  
If you have some problems you can see Issues↓.  


到这里已经完成了50%，是不是很简单。  
接下来，你下载**uploadToBintray.sh**，把他放在你的module目录下，例如CustomView/app/uploadToBintray.sh  
然后打开你的终端或者android studio自带的终端，切换到你的app目录下 ，cd app  
最后运行./uploadToBintray.sh，然后你按照提示填写就行了。  




下面罗列一些可能出现的问题


## Issues / 可能遇到的问题
- 如果权限禁止的话，你需要运行chmod +x uploadToBintray.sh
- 如果你要上传一个库的话，你的项目是依赖是apply plugin: 'com.android.library' 而不是apply plugin: 'com.android.application'
- 第一次运行需要下载几个依赖库可能会占用时间
- 如果最后一步卡在97%请检查你是否开启了proxy，检查你的gradle.properties下是否有proxy的信息，将之删除
- 上传maven成功后你需要打开你的bintray，然后将你的项目add to jcenter，一般在1小时候左右就会审核成功
- 有其他问题可以提Issues
