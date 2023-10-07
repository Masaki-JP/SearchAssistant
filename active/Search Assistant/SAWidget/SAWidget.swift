//
//  SAWidget.swift
//  SAWidget
//
//  Created by Masaki Doi on 2023/10/03.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date())]
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
        Image(systemName: "magnifyingglass.circle")
            .resizable()
            .scaledToFit()
            .privacySensitive(false)
    }
}

struct SAWidget: Widget {
    let kind: String = "SAWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SAWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SAWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
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
