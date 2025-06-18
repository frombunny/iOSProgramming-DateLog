//
//  DatelogApp.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import SwiftUI

@main
struct DatelogApp: App {
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.showSplash = false
                                }
                            }
                        }
                } else {
                    NavigationStack {
                        SignUpView()
                    }
                }
            }
        }
    }
}


