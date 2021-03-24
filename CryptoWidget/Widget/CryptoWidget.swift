//
//  CryptoWidget.swift
//  CryptoWidgetExtension
//
//  Created by Musa Kokcen on 25.03.2021.
//

import WidgetKit
import SwiftUI

@main
struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CryptoCoinTimelineProvider(), content: { entry in
            CryptoWidgetEntryView(entry: entry)
        })
        
        .configurationDisplayName("Crypto Widget")
        .description("Crypto Coin Investment Tracker")
        .supportedFamilies([.systemLarge])
    }
}
