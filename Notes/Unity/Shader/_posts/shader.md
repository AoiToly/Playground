# 一些Shader笔记

## 基础知识

### 不同平台之间的区别

由于OpenGL和DirectX等平台所使用的坐标系不一定相同，OpenGL原点在屏幕右下角，DirectX原点在屏幕左上角，shader的最终呈现效果可能是不同的，尽管Unity在背后帮我们做了一部分的处理，但在某些情况下，仍然会产生问题，例如：在开启了抗锯齿并在此时使用了渲染到纹理的技术，那么就可能会出现问题。因此，在shader中可以用宏命令进行判断

```glsl
// 判断是否是DirectX类型的平台
#if UNITY_UV_STARTS_AT_TOP
// 判断是否开启抗锯齿
// 主纹理的纹素大小在开启抗锯齿后在竖直方向上会变成负值
if (_MainTex_TexelSize.y < 0)
{
    uv.y = 1 - uv.y;
}
#endif
```

### 关于颜色和光照

参考[颜色 - LearnOpenGL CN (learnopengl-cn.github.io)](https://learnopengl-cn.github.io/02 Lighting/01 Colors/)

对于a颜色的光打到b颜色的物体上，人所看到的颜色如下所示

```
# a颜色
glm::vec3 lightColor(1.0f, 1.0f, 1.0f);
# b颜色
glm::vec3 toyColor(1.0f, 0.5f, 0.31f);
# (1.0f*1.0f, 1.0f*0.5f, 1.0f*0.31f)
glm::vec3 result = lightColor * toyColor; // = (1.0f, 0.5f, 0.31f);
```

### 标准光照模型

自发光+高光反射+漫反射+环境光

环境光一般是一个全局的变量

自发光一般由材质的自发光颜色决定

漫反射由粗糙度决定，视角并不重要，因为漫反射方向是随机的，入射角方向很重要，公式为$c_{diffuse}=(c_{light} \cdot m_{diffuse})max(0,\vec{n}\cdot\vec{l})$

高光反射，需要知道法线、视角方向、光源方向、反射方向，反射方向可推导：$\vec{r}=2(\vec{n}\cdot\vec{l})-\vec{l}$

高光反射公式为$c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{v}\cdot\vec{r})^{m_{gloss}}$，其中，gloss是材质的光泽度

Blinn模型为避免计算反射方向，引入了一个新矢量$\vec{h}=\frac{\vec{v}+\vec{l}}{|\vec{v}+\vec{l}|}$

Blinn模型的高光反射公式为$c_{specular}=(c_{light}\cdot m_{specular})max(0,\vec{n}\cdot\vec{h})^{m_{gloss}}$

当距离足够远时，$\vec{v}$和$\vec{l}$近似于定值，$\vec{h}$为常量

## Unity Shader

### Shader结构

渲染状态

SubShader和Pass中的状态通用，SubShader中指定的状态会影响所有的Pass，但也会被Pass中指定的状态覆盖

常见渲染状态

| 状态名称 | 设置指令                                                     | 解释                              |
| -------- | ------------------------------------------------------------ | --------------------------------- |
| Cull     | Cull Back \| Front \| Off                                    | 设置剔除模式：剔除背面I正面／关闭 |
| ZTest    | ZTest Less Greater \| LEqual \| GEqual \| Equal \| NotEqual \| Always | 设置深度测试时使用的函数          |
| ZWrite   | ZWrite On \| Off                                             | 开启/关闭深度写入                 |
| Blend    | Blend SrcFactor DstFactor                                    | 开启并设置混合模式                |

渲染标签

`Tags { "TagName1" = "Value1" "TagName2" = "Value2" }`

渲染标签在SubShader和Pass中一般并不通用

SubShader标签类型

| 标签类型             | 说明                                                         | 例子                                       |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| Queue                | 控制渲染顺序，指定物体的渲染队列                             | `Tags { "Queue" = "Transparent" }`         |
| RenderType           | 对着色器进行分类，例如这是一个不透明的着色器，可被用于着色器替换（Shader Replacement）功能 | `Tags { "RenderType" = "Opaque" }`         |
| DisableBatching      | 是否使用批处理                                               | `Tags { "DisableBatching" = "True" }`      |
| ForceNoShadowCasting | 是否投射阴影                                                 | `Tags { "ForceNoShadowCasting" = "True" }` |
| IgnoreProjector      | 是否受Projector影响，通常用于半透明物体                      | `Tags { "IgnoreProjector" = "True" }`      |
| CanUseSpriteAtlas    | 当该SubShader是用于sprites时，将该标签置为false              | `Tags { "CanUseSpriteAtlas" = "False" }`   |
| PreviewType          | 指明材质面板将如何预览该材质，默认情况下为球形，还有"Plane" "SkyBox" | `Tags { "PreviewType" = "Plane" }`         |

Pass的标签类型

| 标签类型       | 说明                                  | 例子                                           |
| -------------- | ------------------------------------- | ---------------------------------------------- |
| LightMode      | 定义该Pass在Unity的渲染流水线中的角色 | `Tags { "LightMode" = "ForwardBase" }`         |
| RequireOptions | 指定满足某些条件时才渲染该Pass        | `Tags { "RequireOptions" = "SoftVegetation" }` |

### 常见属性

| ShaderLab属性 | CG变量属性            |
| ------------- | --------------------- |
| Color, Vector | float4, half4, fixed4 |
| Range, Float  | float, half, fixed    |
| 2D            | sampler2D             |
| Cube          | samplerCube           |
| 3D            | sampler3D             |

### 常见包含文件

| 文件名                     | 描述                                                   |
| -------------------------- | ------------------------------------------------------ |
| UnityCG.cginc              | 包含了最常使用的帮助函数、宏和结构体                   |
| UnityShaderVariables.cginc | 编译shader时会被自动包含进来，包含了很多内置的全局变量 |
| Lighting.cginc             | 包含了很多内置的光照模型                               |
| HLSLSupport.cginc          | 编译时会被自动包含，声明了很多用于跨平台编译的宏和定义 |

### UnityCG.cginc文件

常用结构体：

```glsl
//appdata 基础结构体
struct appdata_base {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
//appdata 切向量结构体
struct appdata_tan {
    float4 vertex : POSITION;
    float4 tangent : TANGENT;
    float3 normal : NORMAL;
    float4 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
//appdata 完整结构体
struct appdata_full {
    float4 vertex : POSITION;
    float4 tangent : TANGENT;
    float3 normal : NORMAL;
    float4 texcoord : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
    float4 texcoord2 : TEXCOORD2;
    float4 texcoord3 : TEXCOORD3;
    fixed4 color : COLOR;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
// appdata 图像特效结构体
struct appdata_img
{
    float4 vertex : POSITION;
    half2 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
// v2f 图像特效结构体
struct v2f_img
{
    float4 pos : SV_POSITION;
    half2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
```

顶点变换函数：

| 函数                                    | 说明                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| float4 UnityObjectToClipPos(float3 pos) | 将顶点从**模型空间变换到齐次裁切空间**，等同于 mul(UNITY_MATRIX_MVP,float4(pos,1.0)) |
| float3 UnityObjectToViewPos(float3 pos) | 将顶点从**模型空间变换到摄像机空间**，等同于 mul(UNITY_MATRIX_MV,float4(pos,1.0)).xyz。当输入为float4类型，Unity会自动重载为float3类型 |
| float3 UnityWorldToViewPos(float3 pos)  | 将顶点从**世界空间变换到摄像机空间**，等同于 mul(UNITY_MATRIX_V,float4(pos,1.0)).xyz |
| float4 UnityWorldToClipPos(float3 pos)  | 将顶点从**世界空间变换到齐次裁切空间**，等同于 mul(UNITY_MATRIX_VP,float4(pos,1.0)) |
| float4 UnityViewtToClipPos(float3 pos)  | 将顶点从**摄像机空间变换到齐次裁切空间**，等同于 mul(UNITY_MATRIX_P,float4(pos,1.0)) |

向量变换函数：

| 函数                                      | 说明                                           |
| ----------------------------------------- | ---------------------------------------------- |
| float3 UnityObjectToWorldDir(float3 v)    | 将向量从**模型空间转换到世界空间**，已经标准化 |
| float3 UnityWorldToObjectDir(float3 v)    | 将向量从**世界空间转换到模型空间**，已经标准化 |
| float3 UnityObjectToWorldNormal(float3 v) | 将法线从**模型空间转换到世界空间**，已经标准化 |

灯光辅助函数（只适用于前向渲染路径（ForwardBase 或 ForwardAdd Pass）

| 函数                                        | 说明                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| float3 UnityWorldSpaceLightDir(in float3 v) | 输入世界空间顶点坐标，**返回世界空间从顶点指向灯光的向量**，没有被标准化 |
| float3 ObjSpaceLightDir(in float4 v)        | 输入模型空间顶点坐标，返回**模型空间中从顶点指向灯光的向量**，没有被标准化 |
| float3 Shader4PointLights(...)              | 输入一系列所需变量，返回4个点光源的光照信息，在前向渲染中使用这个函数计算逐顶点的光照 |

视角向量函数（顶点指向摄像机的方向向量）：

| 函数                                    | 说明                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| float3 UnityWorldSpaceViewDir(float3 v) | 输入世界空间中的顶点，**返回世界空间中从顶点指向摄像机的向量**，没有被标准化 |
| float3 ObjSpaceViewDir(float4 v)        | 输入模型空间顶点，**返回模型空间中从顶点指向摄像机的向量**，没有被标准化 |

其他辅助函数和宏：

| 函数                                    | 说明                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| TRANSFORM_TEX(tex,name)                 | 宏定义，**输入UV坐标和纹理名称，得到贴图的纹理坐标**         |
| fixed3 UnpackNormal(fixed packedNormal) | **将法线向量从[0,1]映射到[-1,1]**                            |
| half Luminance(half3 rgb)               | **将颜色数据转化为灰度数据**                                 |
| float4 ComputeScreenPos(float4 pos)     | 输入裁切空间顶点坐标，得到屏幕空间纹理坐标，**用于屏幕空间纹理映射** |
| float4 ComputeGrabScreenPos(float4 pos) | 输入裁切空间顶点坐标，得到采样GrabPass的纹理坐标             |

### Unity常用语义

从应用阶段传递模型数据给顶点着色器时Unity支持的常用语义

| 语义      | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| POSITION  | 模型空间中的顶点位置，通常是float4类型                       |
| NORMAL    | 顶点法线，通常是float3类型                                   |
| TANGENT   | 顶点切线，通常是float4类型                                   |
| TEXCOORDn | 该顶点的纹理坐标，TEXCOORD0表示第一组纹理坐标，依此类推，通常是float2或float4类型 |
| COLOR     | 顶点颜色，通常是fixed4或float4类型                           |

从顶点着色器传递数据给片元着色器时Unity使用的常用语义

| 语义                | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| SV_POSITION         | 裁剪空间中的顶点坐标，结构体中必须包含一个用该语义修饰的变量 |
| COLOR0              | 通常用于输出第一组顶点颜色                                   |
| COLOR1              | 通常用于输出第二组顶点颜色                                   |
| TEXCOORD0~TEXCOORD7 | 通常用于输出纹理坐标                                         |

片元着色器输出时Unity支持的常用语义

| 语义      | 描述                                        |
| --------- | ------------------------------------------- |
| SV_Target | 输出值将会存储到渲染目标（render target）中 |

### 常用函数

| 函数         | 参数                     | 描述         |
| ------------ | ------------------------ | ------------ |
| reflect(i,n) | i，入射方向；n，法线方向 | 计算反射方向 |

