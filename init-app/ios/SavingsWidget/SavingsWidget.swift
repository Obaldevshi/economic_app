import SwiftUI
import WidgetKit

private struct SavingItem: Codable, Identifiable {
    let id: Int
    let name: String
    let amount: Double
    let currency: String?
}

private struct SavingEntry: TimelineEntry {
    let date: Date
    let items: [SavingItem]
    var title = "Not spent"
    var empty = "Choose up to three favorites in the Impulses menu."
    var locale = "en"
}

private struct SavingProvider: TimelineProvider {
    func placeholder(in context: Context) -> SavingEntry { SavingEntry(date: Date(), items: []) }
    func getSnapshot(in context: Context, completion: @escaping (SavingEntry) -> Void) { completion(read()) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SavingEntry>) -> Void) {
        completion(Timeline(entries: [read()], policy: .never))
    }
    private func read() -> SavingEntry {
        let group = Bundle.main.object(forInfoDictionaryKey: "SavingsAppGroup") as? String ?? ""
        let defaults = UserDefaults(suiteName: group)
        let raw = defaults?.string(forKey: "saving_items") ?? "[]"
        let items = (try? JSONDecoder().decode([SavingItem].self, from: Data(raw.utf8))) ?? []
        return SavingEntry(date: Date(), items: Array(items.prefix(3)),
            title: defaults?.string(forKey: "saving_title") ?? "Not spent",
            empty: defaults?.string(forKey: "saving_empty") ?? "Choose up to three favorites in the Impulses menu.",
            locale: defaults?.string(forKey: "saving_locale") ?? "en")
    }
}

private struct SavingWidgetView: View {
    let entry: SavingEntry
    private let paper = Color(red: 0.957, green: 0.941, blue: 0.898)
    private let ink = Color(red: 0.153, green: 0.176, blue: 0.204)
    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content.containerBackground(paper, for: .widget)
        } else {
            content.padding().background(paper)
        }
    }
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.title).font(.system(.title2, design: .serif)).bold()
            if entry.items.isEmpty {
                Text(entry.empty)
                    .font(.footnote)
            }
            ForEach(entry.items) { item in
                Link(destination: URL(string: "notspent://saving?id=\(item.id)")!) {
                    HStack {
                        Text(item.name).lineLimit(1)
                        Spacer()
                        Text(item.amount, format: .currency(code: item.currency ?? "RUB")).font(.caption)
                    }
                    .padding(.vertical, 6)
                }
                .privacySensitive()
            }
        }
        .foregroundColor(ink)
        .environment(\.locale, Locale(identifier: entry.locale))
        .environment(\.layoutDirection, entry.locale == "ar" ? .rightToLeft : .leftToRight)
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
