//
//  SignUpView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
// 회원가입 화면

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 입력
    @State private var nickname = ""
    @State private var email    = ""
    @State private var password = ""
    
    // 이미지
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var formValid: Bool {
        !nickname.isEmpty && !email.isEmpty && !password.isEmpty && avatarImage != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("회원가입")
                    .font(.system(size: 26, weight: .semibold))
                    .padding(.top, 40)
                    .foregroundColor(.black)
                
                // ── 프로필 이미지 ──────────────────
                ZStack {
                    if let img = avatarImage {
                        img.resizable().scaledToFill()
                    } else {
                        Image(systemName: "person")
                            .resizable().scaledToFit()
                            .padding(30)
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 120)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Text(avatarImage == nil ? "이미지 선택" : "다른 이미지 선택")
                        .font(.footnote).foregroundColor(.black)
                }
                .onChange(of: avatarItem) { newItem in
                    guard let newItem else { return }
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let ui = UIImage(data: data) {
                            avatarImage = Image(uiImage: ui)
                        }
                    }
                }
                
                // ── 닉네임 ────────────────────────
                PaddedField(placeholder: "닉네임", text: $nickname)
                
                // ── 아이디(이메일) ────────────────
                PaddedField(placeholder: "이메일", text: $email, keyboard: .emailAddress)
                
                // ── 비밀번호 ─────────────────────
                PaddedSecure(placeholder: "비밀번호", text: $password)
                
                // ── 회원가입 버튼 ────────────────
                Button {
                    // TODO: 회원가입 로직
                } label: {
                    Text("회원가입")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(formValid ? Color.black : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!formValid)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview("SignUp") {
    NavigationStack { SignUpView() }
}
