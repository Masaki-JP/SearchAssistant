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
            .modifier(ContainerBackgroundToiOS17AndLater())
    }
}

struct ContainerBackgroundToiOS17AndLater: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            return content.containerBackground(for: .widget) {
                Color.clear
            }
        } else {
            return content
        }
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


//// Previewがうまくいかない。原因は不明
//#Preview(as: .accessoryCircular) {
//    SAWidget()
//} timeline: {
//    SimpleEntry(date: .now)
//}

struct SA_Widget_Previews: PreviewProvider {
    static var previews: some View {
        SAWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
