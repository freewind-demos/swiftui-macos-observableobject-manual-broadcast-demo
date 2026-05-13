# SwiftUI macOS ObservableObject Manual Broadcast Demo

## 简介

这是 1 个只讲 `ObservableObject` 的 macOS SwiftUI demo。

它故意不用 `@Published`，改成手动 `objectWillChange.send()`，让你单独体会：

- `ObservableObject` 本质是“可被多个 View 观察的广播源”
- 只要它广播，盯着它的 View 就会一起刷新

## 快速开始

### 环境要求

- macOS 14+
- Xcode 15+
- XcodeGen

### 运行

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-observableobject-manual-broadcast-demo
./scripts/build.sh
open ObservableObjectManualBroadcastDemo.xcodeproj
```

### 开发循环

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-observableobject-manual-broadcast-demo
./dev.sh
```

## 注意事项

- 这个 demo 的重点不是 `@Published`
- 这里所有刷新都靠 `objectWillChange.send()`
- 所以你能更清楚看到 `ObservableObject` 自己的职责

## 教程

### 1. 它在解决什么问题

如果左边计数面板、右边计数面板、底部日志区都各存 1 份状态：

- 数据会散
- 改左边不一定同步到右边
- 你需要自己接很多回调

`ObservableObject` 的思路是：

1. 做 1 个共享对象
2. 所有 View 都观察它
3. 它一广播，所有观察者一起刷新

### 2. 为什么这里故意不用 `@Published`

因为你现在只想看清 `ObservableObject`。

所以这里用的是：

```swift
objectWillChange.send()
```

也就是说：

- 先手动摇铃
- 再改值
- 所有观察这个对象的 View 一起刷新

### 3. 生动例子

把它想成店里 1 个“中央战报白板”：

- 左边店员能改白板
- 右边店员也能改白板
- 墙上的投影也在盯白板

谁动白板前先喊 1 声“要更新了”，大家就一起抬头重看。

这句“要更新了”，就是 `objectWillChange.send()`。

### 4. 关键代码

```swift
final class SharedCounterBoard: ObservableObject {
  var count: Int = 0

  func increment(from panel: String) {
    objectWillChange.send()
    count += 1
  }
}
```

重点：

1. `ObservableObject` 让它可被观察
2. `count` 只是普通属性
3. 真正触发刷新的是 `objectWillChange.send()`

## 操作

1. 点左栏 `+1`
2. 看右栏数字同步变
3. 点右栏 `-1`
4. 看左栏数字同步变
5. 看底部日志区一起刷新
