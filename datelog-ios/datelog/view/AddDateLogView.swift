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
    var onSave: (DateLogEntry) -> Void

    // 입력 상태
    @State private var title: String = ""
    @State private var entryDate: Date = Date()
    @State private var locationName: String = ""
    @State private var locationAddress: String = ""
    @State private var courses: [CourseItem] = []
    @State private var memo: String = ""

    // 사진 피커
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 이미지 선택
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Group {
                            if let data = imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                    Text("사진 선택")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    }
                    .onChange(of: photoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                imageData = data
                            }
                        }
                    }

                    // 제목
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목")
                            .font(.headline)
                        TextField("제목을 입력하세요", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // 날짜 선택
                    VStack(alignment: .leading, spacing: 8) {
                        Text("날짜")
                            .font(.headline)
                        DatePicker("", selection: $entryDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }

                    // 위치 입력
                    VStack(alignment: .leading, spacing: 8) {
                        Text("위치")
                            .font(.headline)
                        HStack { Image(systemName: "mappin.and.ellipse") }
                        TextField("장소 이름", text: $locationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("상세 주소", text: $locationAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // 데이트 코스
                    VStack(alignment: .leading, spacing: 8) {
                        Text("데이트 코스")
                            .font(.headline)
                        ForEach($courses) { $item in
                            HStack(spacing: 12) {
                                Image(systemName: item.iconName)
                                    .frame(width: 24, height: 24)
                                TextField("코스 내용을 입력하세요", text: $item.title)
                            }
                        }
                        Button(action: {
                            courses.append(CourseItem())
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("코스 추가")
                            }
                            .foregroundColor(.blue)
                        }
                    }

                    // 메모
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모")
                            .font(.headline)
                        TextEditor(text: $memo)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(Color.white)
            }
            .navigationBarTitle("데이트 로그 추가", displayMode: .inline)
            .navigationBarItems(
                leading: Button("취소") {
                    isPresented = false
                },
                trailing: Button("저장") {
                    // 저장 처리
                    let entry = DateLogEntry(
                        title: title,
                        description: memo,
                        imageName: imageData != nil ? "" : "sample01", // placeholder
                        date: DateFormatter.localizedString(from: entryDate, dateStyle: .short, timeStyle: .none)
                    )
                    onSave(entry)
                    isPresented = false
                }.disabled(title.isEmpty || courses.isEmpty)
            )
        }
    }
}

// MARK: - CourseItem
struct CourseItem: Identifiable {
    let id = UUID()
    var iconName: String = "mappin.and.ellipse"
    var title: String = ""
}

// MARK: - Preview
struct AddDateLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDateLogView(isPresented: .constant(true)) { _ in }
    }
}
