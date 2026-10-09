import SwiftUI
import WidgetKit

private struct SavingItem: Codable, Identifiable {
    let id: Int
    let name: String
    let amount: Double
}

private struct SavingEntry: TimelineEntry {
    let date: Date
    let items: [SavingItem]
}

private struct SavingProvider: TimelineProvider {
    func placeholder(in context: Context) -> SavingEntry { SavingEntry(date: Date(), items: []) }
    func getSnapshot(in context: Context, completion: @escaping (SavingEntry) -> Void) { completion(read()) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SavingEntry>) -> Void) {
        completion(Timeline(entries: [read()], policy: .never))
    }
    private func read() -> SavingEntry {
        let group = Bundle.main.object(forInfoDictionaryKey: "SavingsAppGroup") as? String ?? ""
        let raw = UserDefaults(suiteName: group)?.string(forKey: "saving_items") ?? "[]"
        let items = (try? JSONDecoder().decode([SavingItem].self, from: Data(raw.utf8))) ?? []
        return SavingEntry(date: Date(), items: Array(items.prefix(3)))
    }
}

private struct SavingWidgetView: View {
    let entry: SavingEntry
    private let paper = Color(red: 0.957, green: 0.941, blue: 0.898)
    private let ink = Color(red: 0.153, green: 0.176, blue: 0.204)
    private var russian: Bool { Locale.current.languageCode == "ru" }
    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content.containerBackground(paper, for: .widget)
        } else {
            content.padding().background(paper)
        }
    }
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(russian ? "Не потратил" : "Not spent").font(.system(.title2, design: .serif)).bold()
            if entry.items.isEmpty {
                Text(russian ? "Выберите до 3 избранных импульсов в меню привычек." : "Choose up to 3 favorites in the Habits menu.")
                    .font(.footnote)
            }
            ForEach(entry.items) { item in
                Link(destination: URL(string: "notspent://saving?id=\(item.id)")!) {
                    HStack {
                        Text(item.name).lineLimit(1)
                        Spacer()
                        Text(String(format: "%.2f ₽", item.amount)).font(.caption)
                    }
                    .padding(.vertical, 6)
                }
                .privacySensitive()
            }
        }
        .foregroundColor(ink)
    }
}

@main
struct SavingsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "SavingsWidget", provider: SavingProvider()) { entry in
            SavingWidgetView(entry: entry)
        }
        .configurationDisplayName("Не потратил")
        .description(Locale.current.languageCode == "ru" ? "Три быстрых решения. Нажмите и подтвердите сумму в приложении." : "Three quick decisions. Tap to confirm the amount in the app.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
