//
//  SA_Widget.swift
//  SA_Widget
//
//  Created by 土井正貴 on 2022/12/10.
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


struct SA_WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(systemName: "magnifyingglass.circle")
            .resizable()
            .scaledToFit()
            .privacySensitive(false)
            .modifier(containerBackgroundToiOS17AndLater())
    }
}

// たしか自作
struct containerBackgroundToiOS17AndLater: ViewModifier {
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

struct SA_Widget: Widget {
    
    let kind: String = "SA_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SA_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("クイックアクセス")
        .description("このウィジェットをタップするとSearch Assistantを開くことができます。ロック画面からホーム画面に移り、そこからアプリを開くより早く調べ物ができる便利なウィジェットです。")
        .supportedFamilies([.accessoryCircular])
    }
}


struct SA_Widget_Previews: PreviewProvider {
    static var previews: some View {
        SA_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
