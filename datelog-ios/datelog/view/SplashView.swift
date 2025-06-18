//
//  SplashView.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white) // 아이콘 색상 흰색

                Text("DateLog")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // 텍스트 색상 흰색
            }
        }
    }
}
