import SwiftUI

// 这是 1 块被多个 View 共同观察的白板。
final class SharedCounterBoard: ObservableObject {
  // 这里故意不用 @Published。
  var count: Int

  // 记录最后是谁改了白板。
  var lastEditor: String

  // 记录累计广播次数。
  var broadcastCount: Int

  // 初始化默认状态。
  init(
    count: Int = 0,
    lastEditor: String = "还没人操作",
    broadcastCount: Int = 0
  ) {
    // 保存初始计数。
    self.count = count

    // 保存初始编辑者。
    self.lastEditor = lastEditor

    // 保存初始广播数。
    self.broadcastCount = broadcastCount
  }

  // 左右面板都会走这个入口加 1。
  func increment(from panel: String) {
    // 先手动广播“我要变了”。
    objectWillChange.send()

    // 真正改共享数据。
    count += 1

    // 记录是谁改的。
    lastEditor = "\(panel) 点了 +1"

    // 记录广播次数。
    broadcastCount += 1
  }

  // 左右面板都会走这个入口减 1。
  func decrement(from panel: String) {
    // 先手动广播“我要变了”。
    objectWillChange.send()

    // 真正改共享数据。
    count -= 1

    // 记录是谁改的。
    lastEditor = "\(panel) 点了 -1"

    // 记录广播次数。
    broadcastCount += 1
  }

  // 重置整块白板。
  func reset() {
    // 先广播。
    objectWillChange.send()

    // 重置计数。
    count = 0

    // 重置操作说明。
    lastEditor = "已重置"

    // 广播次数也重算。
    broadcastCount = 1
  }
}
