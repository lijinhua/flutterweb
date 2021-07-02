# flutterwebtest

A new Flutter project.


# **flutter web 页面加载性能优化(文件分片加载实战)**
# **flutter web 设计**

![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625197610/image.png)

## 实现原理
在Flutter Web的设计之初，主要考虑了两个方案用于Web支持:

HTML+CSS+Canvas
CSS Paint API

方案1具有最好的兼容性，它优先考虑HTML+CSS表达，当HTML+CSS无法表达图片的时候，会使用Canvas来绘制。但2D Canvas在浏览器中是位图表示，会造成像素化下的性能问题。

方案2是新的Web API, 属于Houdini的组成部分。Houdini提供了一组可以直接访问CSS对象模型的API，使得开发者可以去书写代码并被浏览器作为CSS加以解析，这样在无需等待浏览器原生的支持下，创造了新的CSS特性。它的绘制并非由核心Javascript完成，而是类似Web Worker的机制。其绘制由显示列表支持，而不是位图。但目前CSS Paint API不支持文本，此外各家厂商对齐支持也并不统一。

鉴于此，目前Flutter Web使用的是基于方案1的实现。

# **环境准备**

## flutter web 环境检测
```
执行命令：
flutter doctor
```
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625198460/image.png)

需要配置环境参数在.bash_profile增加chrome的参数，这里面的路径是你电脑的路径
```
export PATH=/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary:$PATH
export CHROME_EXECUTABLE=/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary
```

重新运行：flutter doctor
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625198633/image.png)


然后接下就是创建项目支持web，运行，这里面的省略
构建和运行参考官网
https://flutter.dev/docs/deployment/web
https://flutter.dev/docs/development/tools/web-renderers
运行效果
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625198783/image.png)

直接调试的运行：
flutter run -d chrome

手机端测试：电脑和手机连接同一个网，然后直接通过charles代理，手机连接电脑的代理，然后输入ip就可以查看
坑1：虽然现在flutter 2.0已经正式支持flutter web，但是我在测试的时候使用还是有坑的，使用的版本的是flutter版本是2.2.2，然后编译过后，在android里面的webview是白屏ios是正常的，网页是正常的
解决：使用flutter的版本：2.3.0-24.1.pre在android端的h5就可以打开了

## **flutter打包原理**

我们知道flutter的打包命令是
```
flutter build web --release
```
本地部署服务使用python,我使用的pythone版本是2.7命令执行命令：
3.0命令不一样，自行百度：在项目的build/web下执行，然后打开浏览器localhost:9000就可以访问了
python -m SimpleHTTPServer 9000
说一下结论就是通过dart2js把dart转换成javascript代码
参考
https://dart.dev/tools/dart2js
https://www.yuque.com/xytech/flutter/aqsvov#4bbf9510
会把dart代码打包成一个main.dart.js文件,具体的可以参考我的github地址的代码去掉
```dart
deferred as和FutureBuilder的代码，通过chrome浏览器的调试工具，点击看http的请求，去掉过后的代码
```
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625206570/image.png)
通过chrome浏览器从page1到page3都没有请求可以看到，如果我们的业务比较复杂main.dart.js文件非常大会造成首次加载速度非常的慢
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625206312/image.png)


# **#文件分片懒加载实现**

使用 Dart 对延迟加载的支持来减少应用程序的初始下载大小,deferred as和FutureBuilder来实现,每一个dart文件就会对应一个js文件
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625207332/image.png)
参考：https://dart.dev/guides/language/language-tour#lazily-loading-a-library
加上这个过后从page1到page2才会在需要的时候去加载js
![image.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1625207277/image.png)


这样就完成的了，现在虽然进行了分片加载减少main.dart.js的大小，一个hello world的main.dart.js通过relase打包完也有1M多，这里面包括了很多通用的函数，在真实的项目中我们可以开启http的gzip压缩和cdn加速来解决

flutter web方面还有优化的空间，后面逐步的去探索
1、编译的dartjs支持script标签，现在是静态引用的方式
2、通过cdn进行加速js的加速
3、还有一些打包有一些字体没有用的可以去掉

上面代码演示的地址：
https://github.com/lijinhua/flutterweb
使用的flutter的版本是：2.3.0-24.1.pre
参考连接：
https://www.yuque.com/xytech/flutter/aqsvov#4bbf9510
https://dart.dev/web/deployment
https://tech.meituan.com/2021/03/18/flutterweb-in-meituanwaimai.html
https://dart.dev/web/deployment#use-deferred-loading-to-reduce-your-apps-initial-size



