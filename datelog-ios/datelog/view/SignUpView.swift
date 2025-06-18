//
//  SignUpView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss

    // MARK: - Input fields
    @State private var nickname = ""
    @State private var email    = ""
    @State private var password = ""
    
    // MARK: - Avatar image picker
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    // MARK: - Loading & Error state
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToLogin = false
    
    // MARK: - Form validation
    private var formValid: Bool {
        !nickname.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        avatarImage != nil &&
        !isLoading
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("회원가입")
                    .font(.system(size: 26, weight: .semibold))
                    .padding(.top, 40)
                    .foregroundColor(.black)
                
                // Profile image preview
                ZStack {
                    if let img = avatarImage {
                        img
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .padding(30)
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 120)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                // Photo picker button
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Text(avatarImage == nil ? "이미지 선택" : "다른 이미지 선택")
                        .font(.footnote)
                        .foregroundColor(.black)
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
                
                // Nickname field
                PaddedField(placeholder: "닉네임", text: $nickname)
                
                // Email field
                PaddedField(placeholder: "이메일", text: $email, keyboard: .emailAddress)
                
                // Password field
                PaddedSecure(placeholder: "비밀번호", text: $password)
                
                // Sign up button
                Button {
                    signUp()
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    } else {
                        Text("회원가입")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(formValid ? Color.black : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(!formValid)
                
                Button{
                    navigateToLogin = true
                }label:{
                    Text("로그인")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)     // 항상 검은색
                            .foregroundColor(.white)
                            .cornerRadius(10)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .background(
          NavigationLink(
            destination: LoginView(),
            isActive: $navigateToLogin,
            label: { EmptyView() }
          )
        )
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
        // Error alert
        .alert("회원가입 실패", isPresented: Binding<Bool>(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
    
    // MARK: - Networking
    private func signUp() {
        isLoading = true
            errorMessage = nil
            Task {
                do {
                    try await APIManager.shared.signUp(
                        nickname: nickname,
                        email: email,
                        password: password,
                        profileImageItem:avatarItem
                    )
                    // 네트워크 요청 성공 → 네비게이션 플래그를 true 로
                    navigateToLogin = true
                } catch {
                    errorMessage = (error as NSError).localizedDescription
                }
                isLoading = false
            }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
        }
    }
}

#Preview("SignUpView") {
    NavigationStack { SignUpView() }
}
