//
//  SwipeToActionModifier.swift
//  SwipeToDelete
//
//  Created by Shubham Vyas on 14/11/22.
//

import SwiftUI

//MARK: - Variables
struct SwipeToActionModifier {
    let channelId: String
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let itemWidth: CGFloat
    @State var trailingItems: [SwipeItems]
    @State var leadingItems: [SwipeItems]
    let allowLeadingDestructiveAction: Bool
    let allowTrailingDestructiveAction: Bool
    let buttonStyle: Styles
    let spacing: CGFloat
    private let openTriggerValue: CGFloat = 0.5
    private let closeTriggerValue: CGFloat = 0.5
    @State private var offsetX: CGFloat = 0
    @State private var openSideLock: SwipeDirection?
    @State private var hapticOccurred: Bool = false
    @GestureState private var offsetObserver: CGSize = .zero
    @Binding var swipedChannelId: String?
}

//MARK: - Body
extension SwipeToActionModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            HStack {
                if showLeadingSwipeActions && offsetX > 0 {
                    leadingButtons
                        .transition(.move(edge: .leading))
                        .onAppear {
                            performHaptic()
                        }
                }
                Spacer()
                if showTrailingSwipeActions && offsetX < 0 {
                    trailingButtons
                        .transition(.move(edge: .trailing))
                        .onAppear {
                            performHaptic()
                        }
                }
            }
            .frame(height: buttonHeight)
            .animation(.default, value: offsetX)
            .padding(.horizontal, spacing == 0  ? 0 : 3)

            content
                .background(Color.white.opacity(0.001))
                .offset(x: self.offsetX)
                .simultaneousGesture(
                    DragGesture(
                        minimumDistance: 10,
                        coordinateSpace: .local
                    )
                    .updating($offsetObserver) { (value, gestureState, _) in
                        // Using updating since onEnded is not called if the gesture is canceled.
                        let diff = CGSize(
                            width: value.location.x - value.startLocation.x,
                            height: value.location.y - value.startLocation.y
                        )
                        if diff == .zero {
                            gestureState = .zero
                        } else {
                            gestureState = value.translation
                        }
                    }
                )
        }
        .animation(.default, value: shouldDisplayLeadingLastIcon || shouldDisplayTrailingLastIcon)
        .onChange(of: offsetObserver) { _ in
            DispatchQueue.main.async {
                if offsetObserver == .zero {
                    // gesture ended or cancelled
                    dragEnded()
                } else {
                    dragChanged(to: offsetObserver.width)
                }
            }
        }
        .onChange(of: swipedChannelId) { _ in
            if swipedChannelId != channelId && offsetX != 0 {
                setOffsetX(value: 0)
            }
        }
        .onAppear {
            checkForItemCounts()
        }
    }
}

//MARK: - View Variables
extension SwipeToActionModifier {
    private var leadingButtons: some View {
        HStack(spacing: spacing) {
            ForEach(leadingItems, id: \.id) { item in
                Button {
                    performHaptic()
                    item.onClicked()
                } label: {
                    ZStack(alignment: shouldDisplayLeadingLastIcon ? .trailing : .center) {
                        item.backgroundColor
                        item.buttonView()
                            .padding(.trailing, shouldDisplayLeadingLastIcon ? 20 : 0)
                            .fixedSize()
                    }
                    .frame(maxWidth: destructiveWidth(button: item, side: .leading))
                    .onChange(of: offsetX) { _ in
                        if destructiveWidth(button: item, side: .leading) > buttonWidth(side: .leading) && !hapticOccurred {
                            performHaptic()
                            hapticOccurred = true
                        } else if destructiveWidth(button: item, side: .leading) ~= buttonWidth(side: .leading) && hapticOccurred {
                            performHaptic()
                            hapticOccurred = false
                        }
                    }
                }
                .cornerRadius(buttonStyle.cornerRadius)
                .opacity(shouldDisplayLeadingLastIcon && item != leadingDestructiveItem ? 0 : 1)
                .offset(x: shouldDisplayLeadingLastIcon && item != leadingDestructiveItem ? -30 : 0)
                .transition(.slide)
            }
            .animation(.default, value: shouldDisplayLeadingLastIcon)
        }
    }

    private var trailingButtons: some View {
        HStack(spacing: spacing) {
            ForEach(trailingItems, id: \.id) { item in
                Button {
                    performHaptic()
                    item.onClicked()
                } label: {
                    ZStack(alignment: shouldDisplayTrailingLastIcon ? .leading : .center) {
                        item.backgroundColor
                        item.buttonView()
                            .padding(.leading, shouldDisplayTrailingLastIcon ? 20 : 0)
                            .fixedSize()
                    }
                    .frame(width: destructiveWidth(button: item, side: .trailing))
                    
                }
                .cornerRadius(buttonStyle.cornerRadius)
                .opacity(shouldDisplayTrailingLastIcon && item != trailingDestructiveItem ? 0 : 1)
                .transition(.slide)
                .offset(x: shouldDisplayTrailingLastIcon && item != trailingDestructiveItem ? 30 : 0)
            }
            .animation(.default, value: shouldDisplayLeadingLastIcon)
        }
    }
}

//MARK: - Computed Properties
extension SwipeToActionModifier {
    private var numberOfTrailingItems: Int {
        trailingItems.count
    }

    private var numberOfLeadingItems: Int {
        leadingItems.count
    }

    private var showLeadingSwipeActions: Bool {
        !leadingItems.isEmpty
    }

    private var showTrailingSwipeActions: Bool {
        !trailingItems.isEmpty
    }
    
    private var reservedSpace: CGFloat {
        itemWidth - buttonWidth - 10
    }

    private var shouldDisplayLeadingLastIcon: Bool {
        allowLeadingDestructiveAction &&
        numberOfLeadingItems > 1 &&
        abs(offsetX) > leadingTriggerPoint &&
        offsetX > 0
    }

    private var shouldDisplayTrailingLastIcon: Bool {
        allowTrailingDestructiveAction &&
        numberOfTrailingItems > 1 &&
        abs(offsetX) > trailingTriggerPoint &&
        offsetX < 0
    }

    private var leadingDestructiveItem: SwipeItems {
        leadingItems[0]
    }

    private var trailingDestructiveItem: SwipeItems {
        trailingItems[trailingItems.count - 1]
    }
    
    private var leadingTriggerPoint: CGFloat {
        max((itemWidth * 0.75) + 20, CGFloat(leadingItems.count) * buttonWidth)
    }
    
    private var trailingTriggerPoint: CGFloat {
        max((itemWidth * 0.75) + 20, CGFloat(trailingItems.count) * buttonWidth)
    }
}

//MARK: - Functions
extension SwipeToActionModifier {
    private func menuWidth(side: SwipeDirection) -> CGFloat {
        return buttonWidth * CGFloat(side == .leading ? numberOfLeadingItems : numberOfTrailingItems)
    }

    private func buttonWidth(side: SwipeDirection) -> CGFloat {
        offsetX.magnitude * (buttonWidth / menuWidth(side: side))
    }

    private func destructiveWidth(button: SwipeItems, side: SwipeDirection) -> CGFloat {
        switch side {
        case .leading:
            if button == leadingDestructiveItem && shouldDisplayLeadingLastIcon {
                return offsetX
            } else if shouldDisplayLeadingLastIcon {
                return 0
            } else {
                return buttonWidth(side: side)
            }
        case .trailing:
            if button == trailingDestructiveItem && shouldDisplayTrailingLastIcon {
                performHaptic()
                return abs(offsetX)
            } else if shouldDisplayTrailingLastIcon {
                return 0
            } else {
                return buttonWidth(side: side)
            }
        }
    }

    private func performHaptic() {
        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
        impactHeavy.impactOccurred()
    }

    private func dragChanged(to value: CGFloat) {
        let horizontalTranslation = value

        if horizontalTranslation > 0 && openSideLock == nil && !showLeadingSwipeActions {
            // prevent swiping to left, if not configured.
            return
        }

        if horizontalTranslation < 0 && openSideLock == nil && !showTrailingSwipeActions {
            // prevent swiping to right, if not configured.
            return
        }

        if let openSideLock = self.openSideLock {
            offsetX = menuWidth(side: openSideLock) * openSideLock.sideFactor + horizontalTranslation
            return
        }

        if horizontalTranslation != 0 {
            if swipedChannelId != channelId {
                swipedChannelId = channelId
            }
            offsetX = horizontalTranslation
        } else {
            offsetX = 0
        }
    }

    private func setOffsetX(value: CGFloat) {
        withAnimation {
            self.offsetX = value
        }
        if offsetX == 0 {
            openSideLock = nil
            swipedChannelId = nil
            hapticOccurred = false
        }
    }

    private func lockSideMenu(side: SwipeDirection) {
        setOffsetX(value: side.sideFactor * menuWidth(side: side))
        openSideLock = side
    }

    private func dragEnded() {
        if offsetX == 0 {
            swipedChannelId = nil
            openSideLock = nil
        } else if offsetX > 0 && showLeadingSwipeActions {
            if  abs(offsetX) > leadingTriggerPoint && allowLeadingDestructiveAction {
                performHaptic()
                leadingDestructiveItem.onClicked()
                setOffsetX(value: 0)
            } else if offsetX.magnitude < openTriggerValue || offsetX < menuWidth(side: .leading) * closeTriggerValue {
                performHaptic()
                setOffsetX(value: 0)
            } else {
                lockSideMenu(side: .leading)
            }
        } else if offsetX < 0 && showTrailingSwipeActions {
            if  abs(offsetX) > trailingTriggerPoint && allowTrailingDestructiveAction {
                performHaptic()
                trailingDestructiveItem.onClicked()
                setOffsetX(value: 0)
            } else if offsetX.magnitude < openTriggerValue || offsetX > -menuWidth(side: .trailing) * closeTriggerValue {
                performHaptic()
                setOffsetX(value: 0)
            } else {
                lockSideMenu(side: .trailing)
            }
        } else {
            setOffsetX(value: 0)
        }
    }
    
    private func checkForItemCounts() {
        var leadingWidth: CGFloat = 0
        let leadingCount = leadingItems.count
        for item in leadingItems {
            leadingWidth += buttonWidth
            if(leadingWidth > reservedSpace) {
                if let index = leadingItems.firstIndex(of: item) {
                    leadingItems.remove(at: index)
                }
            }
        }
        if(leadingCount > leadingItems.count) {
            print("You have added more buttons on leading side than it can fit there. \n So, dropped the last item from your passed array. \n Remove one buttton from array to work with it with no issues")
        }
        
        var trailingWidth: CGFloat = 0
        let trailingCount = trailingItems.count
        for item in trailingItems {
            trailingWidth += buttonWidth
            if(trailingWidth > reservedSpace) {
                if let index = trailingItems.firstIndex(of: item) {
                    trailingItems.remove(at: index)
                }
            }
        }
        if(trailingCount != trailingItems.count) {
            print("You have added more buttons on trailing side than it can fit there. \n So, dropped the last item from your passed array. \n Remove one buttton from array to work with it with no issues")
        }
    }
}

public enum SwipeDirection {
    case leading
    case trailing

    var sideFactor: CGFloat {
        switch self {
        case .leading:
            return 1
        case .trailing:
            return -1
        }
    }
}

public enum Styles {
    case rectangle
    case rounded(cornerRadius: CGFloat)
    case circle

    var cornerRadius: CGFloat {
        switch self {
        case .rectangle:
            return 0
        case .rounded(let cornerRadius):
            return cornerRadius
        case .circle:
            return .infinity
        }
    }
}

