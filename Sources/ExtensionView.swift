//
//  ExtensionView.swift
//  SwipeToDelete
//
//  Created by Shubham Vyas on 19/10/22.
//

import Foundation
import SwiftUI

extension View {
    public func swipe(
        channelId: String = UUID().uuidString,
        buttonWidth: CGFloat = 70,
        buttonHeight: CGFloat = 70,
        itemWidth: CGFloat,
        trailingItems: [SwipeItems] = [],
        leadingItems: [SwipeItems] = [],
        allowLeadingDestructiveAction: Bool = true,
        allowTrailingDestructiveAction: Bool = true,
        buttonStyle: Styles = .rectangle,
        spacing: CGFloat = 0,
        swipedChannelId: Binding<String?>
    ) -> some View {
        modifier(SwipeToActionModifier(
            channelId: channelId,
            buttonWidth: buttonWidth,
            buttonHeight: buttonHeight,
            itemWidth: itemWidth,
            trailingItems: trailingItems,
            leadingItems: leadingItems,
            allowLeadingDestructiveAction: allowLeadingDestructiveAction,
            allowTrailingDestructiveAction: allowTrailingDestructiveAction,
            buttonStyle: buttonStyle,
            spacing: spacing,
            swipedChannelId: swipedChannelId))
    }

    public func castToAnyView() -> AnyView {
        return AnyView(self)
    }
}
