//
//  ViewController.swift
//  SSSwiper
//
//  Created by shubhamsimformsolutions on 02/10/2023.
//  Copyright (c) 2023 shubhamsimformsolutions. All rights reserved.
//

import UIKit
import SSSwiper
import SwiftUI

struct MainView {
    @State var swipedChannelId: String?
    @State var values = Array(1...100)
    @State var archived: [Int] = []
    @State var trash: [Int] = []
    @State var arraySelector: Int = 1
    let width = UIScreen.main.bounds.size.width
}

extension MainView : View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(getArray(), id: \.self) { number in
                    item(number)
                        .swipe(
                            channelId: "\(number)",
                            buttonWidth: 75,
                            buttonHeight: 75,
                            itemWidth: UIScreen.main.bounds.size.width,
                            trailingItems: self.trailingItems(number: number),
                            leadingItems: trailingItems(number: number),
                            allowLeadingDestructiveAction: false,
                            allowTrailingDestructiveAction: true,
                            buttonStyle:  number % 3 == 0 ? .circle : number % 2 == 0 ? .rounded(cornerRadius: 15) : .rectangle,
                            spacing: number % 3 == 0 || number % 2 == 0 ? 5 : 0,
                            swipedChannelId: $swipedChannelId)
                }
            }
            .background(Color.gray.opacity(0.5))
            .padding(.top, 45)
        }
        .padding(.horizontal, 20)
    }
    
    private func item(_ number: Int) -> some View {
        VStack(spacing: 0) {
            Text("\(number)")
                .foregroundColor(.black)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .frame(width: UIScreen.main.bounds.size.width, height: 75)
            Divider()
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 75)
    }
    
    private func destruction(number: Int) {
        withAnimation {
            self.values.remove(at: values.firstIndex(of: number) ?? -1)
        }
    }
    
    private func getArray() -> [Int] {
        if arraySelector == 1 {
            return values
        } else if arraySelector == 2 {
            return archived
        } else if arraySelector == 3 {
            return trash
        }
        return []
    }
    
    private func trailingItems(number: Int) -> [SwipeItems] {
        return [
            SwipeItems(
                buttonView: delete ,
                backgroundColor: .red,
                iconWidth: 20,
                onClicked: {
                    self.values.remove(at: values.firstIndex(of: number) ?? -1)
                }
            ),
            SwipeItems(
                buttonView: Text("Edit").foregroundColor(.white).castToAnyView ,
                backgroundColor: .purple,
                iconWidth: 20,
                onClicked: {
                    self.values.remove(at: values.firstIndex(of: number) ?? -1)
                }
            ),
            SwipeItems(
                buttonView: mute ,
                backgroundColor: .black,
                iconWidth: 20,
                onClicked: {
                    self.values.remove(at: values.firstIndex(of: number) ?? -1)
                    
                }
            ),
            SwipeItems(
                buttonView: archive ,
                backgroundColor: .gray,
                iconWidth: 30,
                onClicked: {
                    self.values.remove(at: values.firstIndex(of: number) ?? 0)
                }
            )
        ]
    }
    
    private func delete() -> AnyView {
        VStack(spacing: 2) {
            Image(systemName: "trash.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
            Text("Delete")
                .font(.system(size: 12))
                .foregroundColor(.white)
        }
        .castToAnyView()
    }
    
    private func archive() -> AnyView {
        Image(systemName: "archivebox.circle.fill")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .castToAnyView()
    }
    
    private func mute() -> AnyView {
        Image(systemName: "speaker.slash.circle.fill")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .castToAnyView()
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: MainView())
        addChild(childView)
        childView.view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height
        )
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

