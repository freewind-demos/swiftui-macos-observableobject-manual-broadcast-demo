import SwiftUI

// 这是主界面。
struct ContentView: View {
  // 直接观察共享白板。
  @ObservedObject var board: SharedCounterBoard

  // 组织整体布局。
  var body: some View {
    // 用纵向布局包住标题、双栏、说明区。
    VStack(alignment: .leading, spacing: 16) {
      // 顶部说明卡。
      headerCard

      // 两个面板同时盯同 1 块白板。
      HStack(alignment: .top, spacing: 16) {
        counterPanel(title: "左边店员")
        counterPanel(title: "右边店员")
      }

      // 底部状态墙。
      statusPanel
    }
    // 留边距。
    .padding(20)
    // 设定最小尺寸。
    .frame(minWidth: 1000, minHeight: 700)
  }

  // 顶部讲清楚 demo 的焦点。
  private var headerCard: some View {
    // 用卡片包住核心结论。
    VStack(alignment: .leading, spacing: 10) {
      Text("ObservableObject = 会广播的共享白板")
        .font(.system(size: 28, weight: .bold))

      Text("这个 demo 故意不用 @Published。每次点击前都手动 objectWillChange.send()，所以你能单独看到 ObservableObject 的作用。")
        .foregroundStyle(.secondary)

      HStack(spacing: 10) {
        badge("共享对象")
        badge("多个 View 同时观察")
        badge("手动广播刷新")
      }
    }
    .padding(18)
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 构造左右共用的计数面板。
  private func counterPanel(title: String) -> some View {
    // 用卡片承载内容。
    VStack(alignment: .leading, spacing: 14) {
      Text(title)
        .font(.headline)

      Text("当前计数")
        .font(.caption)
        .foregroundStyle(.secondary)

      Text("\(board.count)")
        .font(.system(size: 56, weight: .bold, design: .rounded))

      Text("两个面板都只是在看同 1 个 ObservableObject。")
        .foregroundStyle(.secondary)

      HStack {
        Button("+1") {
          board.increment(from: title)
        }

        Button("-1") {
          board.decrement(from: title)
        }

        Button("重置") {
          board.reset()
        }
      }

      Spacer(minLength: 0)
    }
    .padding(18)
    .frame(maxWidth: .infinity, minHeight: 280, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 底部状态墙。
  private var statusPanel: some View {
    // 用卡片展示广播结果。
    VStack(alignment: .leading, spacing: 12) {
      Text("状态墙")
        .font(.headline)

      stateRow(name: "count", value: "\(board.count)")
      stateRow(name: "lastEditor", value: board.lastEditor)
      stateRow(name: "broadcastCount", value: "\(board.broadcastCount)")

      insightCard(
        title: "体感重点",
        body: "左边按按钮，右边也跟着变，不是因为左边通知了右边，而是因为它们都在观察同 1 个 ObservableObject。"
      )

      insightCard(
        title: "这句最关键",
        body: "这里真正触发刷新的，是 SharedCounterBoard 里的 objectWillChange.send()。所以 ObservableObject 本质是广播源。"
      )
    }
    .padding(18)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 构造状态行。
  private func stateRow(name: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(name)
        .font(.caption)
        .foregroundStyle(.secondary)

      Text(value)
        .font(.system(.body, design: .monospaced))
        .textSelection(.enabled)
    }
  }

  // 构造说明卡片。
  private func insightCard(title: String, body: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      Text(body)
        .foregroundStyle(.secondary)
    }
    .padding(14)
    .background(Color.primary.opacity(0.04))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  // 顶部小标签。
  private func badge(_ text: String) -> some View {
    Text(text)
      .font(.caption.weight(.medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color.primary.opacity(0.06))
      .clipShape(Capsule())
  }
}
