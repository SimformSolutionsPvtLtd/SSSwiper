//
//  SwipeItems.swift
//  SwipeToDelete
//
//  Created by Shubham Vyas on 14/11/22.
//

import SwiftUI

public struct SwipeItems: Equatable {
    public static func == (lhs: SwipeItems, rhs: SwipeItems) -> Bool {
        return lhs.id == rhs.id
    }

    public var id: String
    var buttonView: () -> AnyView
    let backgroundColor: Color
    var onClicked: () -> Void
    let iconWidth: CGFloat

    public init(id: String = UUID().uuidString, buttonView: @escaping () -> AnyView, backgroundColor: Color, iconWidth: CGFloat, onClicked: @escaping () -> Void) {
        self.id = id
        self.buttonView = buttonView
        self.backgroundColor = backgroundColor
        self.iconWidth = iconWidth
        self.onClicked = onClicked
    }
}
