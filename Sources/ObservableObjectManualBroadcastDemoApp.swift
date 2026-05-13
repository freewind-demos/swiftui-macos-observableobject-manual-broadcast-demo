import SwiftUI

// 这是 demo 的应用入口。
@main
struct ObservableObjectManualBroadcastDemoApp: App {
  // 用 StateObject 持有 1 份共享白板。
  @StateObject private var board = SharedCounterBoard()

  // 定义主窗口。
  var body: some Scene {
    // 用 1 个窗口承载 demo。
    Window("ObservableObject Demo", id: "main") {
      // 把共享白板传给内容视图。
      ContentView(board: board)
    }
    // 给窗口 1 个舒服的默认尺寸。
    .defaultSize(width: 1100, height: 760)
  }
}
