# Java初见&项目实践

## 环境配置

安装JRE、JDK

安装idea

## 配置idea

maven换[阿里源(aliyun.com)](https://developer.aliyun.com/mvn/guide)：进入idea文件坐在位置，进入..\plugins\maven\lib\maven3\conf\settings.xml，记事本形式打开，找到mirror标签，将下述代码复制到其中

```xml
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

## 创建工程

打开idea，选择新建工程，左侧Generator中选择Spring Initializr

第一页设置中，语言：Java，类型：Maven，组：com.公司名称，打包：Jar

Jar和War的区别在于，Jar包就是别人写好的一些类，然后对这些类进行打包，开发人员可以通过将这些jar包引入自己的项目中来使用这些类和属性，jar包一般放在lib目录下；war包是一个web模块，可以直接运行，参考[【运维面试】面试官： jar包和war包有什么区别？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/260826643)

点击新建工程后，会发现，在Java一栏会发现只有17和21，如果想要用8，可以修改Server URL，将其改成国内镜像，如[阿里云](https://start.aliyun.com/)

第二页设置中，Spring Boot选择无后缀版本，一般后缀版本都是测试或先行版，较不稳定

依赖项中选择：

```
Developer Tools->Spring Boot DevTools
Developer Tools->Lombok // 使用注解辅助实现类似C#中属性的功能
Developer Tools->Spring Configuration Processor
Web->Spring Web // 如果想要开发Web应用必须勾选
SQL->JDBC API
SQL->MySQL Driver
```

