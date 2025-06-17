//
//  LoginView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//
// 로그인 화면

import SwiftUI

// MARK: - 로그인 화면
struct LoginView: View {
    // 입력
    @State private var email = ""
    @State private var password = ""

    // 네비게이션
    @State private var showSignUp = false
    @Environment(\.dismiss) private var dismiss

    var disableLogin: Bool { email.isEmpty || password.isEmpty }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        Spacer(minLength: geo.size.height * 0.1)

                        // ── 카드 컨테이너 ────────────────────────────────
                        VStack(spacing: 28) {
                            // 타이틀
                            Text("LOGIN")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.black)

                            // 이메일
                            IconField(sf: "envelope", placeholder: "이메일",
                                      text: $email, isSecure: false)

                            // 비밀번호
                            IconField(sf: "lock", placeholder: "비밀번호",
                                      text: $password, isSecure: true)

                            // 로그인 버튼
                            Button {
                                // TODO: 로그인 API
                            } label: {
                                Text("Sign In")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(disableLogin ? Color.black.opacity(0.15)
                                                             : Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .disabled(disableLogin)

                            // 회원가입
                            Button { showSignUp = true } label: {
                                Text("회원가입")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(32)
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .navigationDestination(isPresented: $showSignUp) {
                        SignUpView()
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
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
}

// MARK: - 아이콘 + 입력 필드 공통 컴포넌트
private struct IconField: View {
    let sf: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: sf)
                .frame(width: 20)
                .foregroundColor(.black)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(sf == "envelope" ? .emailAddress : .default)
                }
            }
            .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.6), lineWidth: 1)
        )
    }
}

#Preview("Login – Card") {
    NavigationStack { LoginView() }
}
