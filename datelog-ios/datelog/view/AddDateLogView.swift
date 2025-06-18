//
//  AddDateLogView.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import SwiftUI
import PhotosUI



// MARK: - 새로운 데이트 로그 입력 뷰
struct AddDateLogView: View {
    @Binding var isPresented: Bool
    var onSuccess: () -> Void     // 저장 성공시 호출

    // 서버 DTO에 맞는 상태만!
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil

    @State private var name: String = ""           // 장소명
    @State private var entryDate: Date = Date()    // 날짜
    @State private var location: String = ""       // 상세주소(옵션)
    @State private var title: String = ""          // 제목
    @State private var diary: String = ""          // 메모(옵션)

    @State private var isUploading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 1. 이미지
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        ZStack {
                            if let data = imageData, let img = UIImage(data: data) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                VStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 36))
                                        .foregroundColor(.gray.opacity(0.5))
                                    Text("사진 추가")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                            }
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .clipped()
                    }
                    .onChange(of: photoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                imageData = data
                            }
                        }
                    }

                    // 2. 장소명 (필수)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("장소명*").font(.headline)
                        TextField("예: 이태원 식당", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 3. 날짜 (필수)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("날짜*").font(.headline)
                        DatePicker("", selection: $entryDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }

                    // 4. 상세주소 (옵션)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("상세 주소").font(.headline)
                        TextField("예: 서울 용산구 이태원로", text: $location)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 5. 제목 (필수)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목*").font(.headline)
                        TextField("제목을 입력하세요", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 6. 메모 (옵션)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모").font(.headline)
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $diary)
                                .frame(height: 80)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
                            if diary.isEmpty {
                                Text("기억하고 싶은 내용을 적어보세요")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8).padding(.horizontal, 6)
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
            }
            .navigationBarTitle("데이트 로그 추가", displayMode: .inline)
            .navigationBarItems(
                leading: Button("취소") { isPresented = false },
                trailing: Button(isUploading ? "저장중..." : "저장") {
                    Task {
                        isUploading = true
                        defer { isUploading = false }
                        do {
                            try await APIManager.shared.createDateLog(
                                imageData: imageData,
                                name: name,
                                date: DateFormatter.yyyyMMdd.string(from: entryDate),
                                location: location,
                                title: title,
                                diary: diary
                            )
                            isPresented = false
                            onSuccess()
                        } catch {
                            errorMessage = "등록 실패: \(error.localizedDescription)"
                        }
                    }
                }
                .disabled(name.isEmpty || title.isEmpty || isUploading)
            )
            .alert("등록 실패", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("확인", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
