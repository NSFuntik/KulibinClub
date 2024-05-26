//
//  Item.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
