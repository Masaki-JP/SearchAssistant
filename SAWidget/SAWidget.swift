import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: .init())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [SimpleEntry(date: .init())]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct SAWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            Image(.lockScreenWidgetLogo)
                .resizable()
                .scaledToFit()
                .padding(2)
                .privacySensitive(false)
        }
        .containerBackground(.clear, for: .widget)
    }
}

struct SAWidget: Widget {
    let kind: String = "SAWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SAWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Quick Access")
        .description("ロック画面からアプリを開くことができます。")
        .supportedFamilies([.accessoryCircular])
    }
}

#Preview(as: .accessoryCircular) {
    SAWidget()
} timeline: {
    SimpleEntry(date: .now)
}
