# Bugly SDK 变更记录

---

> 版本 v1.2.9
> 
> 更新时间: 2015-08-12

---

## SDK压缩包目录结构说明

> - Bugly.zip
    - Bugly_libc++ 依赖**libc++.dylib**编译的framework
        - `Bugly.framework`
    - Bugly_libstdc++ 依赖**libstdc++.dylib**编译的framework
        - `Bugly.framework`
    - BuglySDKDemo   SDK接入示例工程

---

## 变更日志
* v1.2.9
> 更新时间: 2015-08-12
> 
> 更新内容:
> 
> * 支持iOS Extension的异常捕获


* v1.2.8
> 更新时间: 2015-07-20
> 
> 更新内容:
> 
> * 卡顿监控上报
> * 进程内堆栈符号化
> * 优化objc_msgSend堆栈处理

* v1.2.7
> 更新时间: 2015-06-29
> 
> 更新内容:
> 
> * 修复dump线程堆栈问题
>

* v1.2.5
> 更新时间: 2015-06-08
> 
> 更新内容:
> 
> * 新增设置Tag,Key-Value功能
> * Bug修复
>

* v1.2.4
> 更新时间: 2015-05-05
> 
> 更新内容:
> 
> * 初始化接口变更为installWithAppId:
> * 新增手动上报捕获异常接口
> * 修复崩溃后等待上报再次出现崩溃的问题
> * Bug修复

* v1.2.3
> 更新时间: 2015-02-05
> 
> 更新内容:
> 
> * 修复进程中文名影响堆栈还原的问题

* v1.2.2
> 更新时间: 2015-01-26
> 
> 更新内容:
> 
> * 统一字符编码处理
> * 协议版本变更
> * 其他问题修复及优化

* v1.2.1
> 更新时间：2015-01－12
> 
> 更新内容：
> 
> * 优化联网设备上报
> * 修复userId显示中文乱码问题
> * 其他问题修复及优化

* v1.0.1
> 更新时间：2014-12-03
> 
> 更新内容：
> 
> * 新增SDK接入示例工程 





