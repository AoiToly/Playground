# Unity Netcode for GameObjects

官方文档地址：[Get started with Netcode for GameObjects | Unity Multiplayer Networking (unity3d.com)](https://docs-multiplayer.unity3d.com/netcode/current/tutorials/get-started-ngo/)

​	Unity NGO是Unity官方提供的一套用于多人联机游戏的网络插件，本文介绍了Unity NGO框架一些重要的概念

​	关于NGO如何使用，可以查看官方文档，这一部分很简单，以下只针对官方文档中的一些内容做出解释，以方便理解NGO的一些概念。

​	以下内容只考虑局域网联机模式。

​	首先，NGO允许将客户端、主机端、服务器端整合在一个工程中发布，在测试的过程中，我发现在关闭了一些检测之后，不同的工程之间也是存在互通的可能性的，但这就意味着很多NGO提供的功能无法使用，目前仍不清楚这是否会导致一些严重的问题，这种方案的可行性暂未可知。

​	关于NetworkObject，这是网络通信的前提，测试得出，对于任何客户端，只有在被分配了NetworkObject组件的物体之后才能主动向其他单位发送信息，不然只会接受到同步的信息。

​	关于NetworkBehaviour，这个脚本用于定义NetworkObject在网络通信过程中可执行的行为

​	关于tick、延迟等内容，首先肯定是有延迟的，这是无可避免的，但是在局域网下，延迟问题并不严重，并且其实NGO已经帮我们处理了一部分延迟的问题。在数据传输方面，我们只需要搞明白，“让同一个事件尽可能同步地在所有用户主机上出现”这个问题该如何处理。

​	首先，LocalTime和ServerTime，以下是文档中的描述

```
// 文档原文
LocalTime on a client is ahead of the server. If a server RPC is sent at LocalTime from a client it will roughly arrive at ServerTime on the server.
ServerTime on clients is behind the server. If a client RPC is sent at ServerTime from the server to clients it will roughly arrive at ServerTime on the clients.
// 机翻后
客户端的 LocalTime 比服务器的领先。如果客户端在 LocalTime 发送服务器 RPC，则大致会在服务器的 ServerTime 到达。
客户端的 ServerTime 在服务器之后。如果客户端 RPC 以 ServerTime 从服务器发送到客户端，则大致会在客户端的 ServerTime 到达。
```

​	简而言之，LocalTime和ServerTime主要还是用在客户端的概念，LocalTime是基于当前客户端的时间，而ServerTime是基于服务器当前的时间，客户端的时间会比服务器时间稍微快一点，这样的话，客户端向服务器发送数据后，大约就会在客户端的ServerTime到达服务器，而服务器在某时刻向客户端发送数据后，大约就会在客户端的相同ServerTime到达客户端，另外，NGO官方还提供了弥补延迟的案例