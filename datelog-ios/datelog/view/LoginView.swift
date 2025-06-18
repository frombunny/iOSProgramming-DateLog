//
//  LoginView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//
// 로그인 화면

//
//  LoginView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//

import SwiftUI

struct LoginView: View {
    // MARK: – Input
    @State private var email = ""
    @State private var password = ""

    // MARK: – State
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSignUp = false
    @State private var navigateToHome = false

    // MARK: – Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: – Form validation
    private var canSubmit: Bool {
        !email.isEmpty && !password.isEmpty && !isLoading
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        Spacer(minLength: geo.size.height * 0.1)

                        VStack(spacing: 28) {
                            Text("LOGIN")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.black)

                            IconField(sf: "envelope", placeholder: "이메일",
                                      text: $email, isSecure: false)
                            IconField(sf: "lock", placeholder: "비밀번호",
                                      text: $password, isSecure: true)

                            Button {
                                performLogin()
                            } label: {
                                if isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(12)
                                } else {
                                    Text("Sign In")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(canSubmit ? Color.black : Color.black.opacity(0.15))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .disabled(!canSubmit)

                            Button {
                                showSignUp = true
                            } label: {
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
                    // 숨겨진 네비링크
                    .background(
                        Group {
                            NavigationLink(
                                destination: ContentView(),
                                isActive: $navigateToHome,
                                label: { EmptyView() }
                            )
                            NavigationLink(
                                destination: SignUpView(),
                                isActive: $showSignUp,
                                label: { EmptyView() }
                            )
                        }
                    )
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
            // 에러 얼럿
            .alert("로그인 실패", isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("확인", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    // MARK: – Networking
    private func performLogin() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let token = try await APIManager.shared.login(
                    email: email,
                    password: password
                )
                // 토큰 저장
                UserDefaults.standard.set(token, forKey: "jwtToken")
                // 화면 전환
                navigateToHome = true
            } catch {
                errorMessage = (error as NSError).localizedDescription
            }
            isLoading = false
        }
    }
}

// MARK: – Icon + Field Component
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
                        .keyboardType(.emailAddress)
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
