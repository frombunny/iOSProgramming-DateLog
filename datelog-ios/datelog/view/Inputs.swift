//
//  Inputs.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//

import SwiftUI

/// 텍스트 필드
struct PaddedField: View {
    var placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboard)
            .textInputAutocapitalization(.never)
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1))
            .foregroundColor(.black)
    }
}

/// 비밀번호 입력 창
struct PaddedSecure: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1))
            .foregroundColor(.black)
    }
}
