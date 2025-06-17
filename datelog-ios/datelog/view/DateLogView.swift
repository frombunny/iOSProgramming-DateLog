//
//  DateLogView.swift
//  datelog
//
//  Created by 임혜정 on 6/17/25.
//


import SwiftUI

// MARK: - 모델 & 목업 데이터
struct DateLogEntry: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String   // Assets.xcassets에 넣은 더미 이미지
    let date: String        // yyyy.MM.dd
}

let sampleDateLog: [DateLogEntry] = [
    .init(
        title: "이태원 식당에서 한 끼",
        description: String(repeating: "이태원 식당에서 한 끼 설명 ", count: 2),
        imageName: "sample01",
        date: "2024.07.20"
    ),
    .init(
        title: "영화 관람",
        description: String(repeating: "즐거운 영화 관람 ", count: 2),
        imageName: "sample02",
        date: "2024.07.15"
    ),
    .init(
        title: "한강 피크닉",
        description: String(repeating: "한강 피크닉 설명 ", count: 2),
        imageName: "sample03",
        date: "2024.07.10"
    )
]

// MARK: - 카드 뷰
struct DateLogCard: View {
    let entry: DateLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(entry.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)

            Text(entry.title)
                .font(.system(size: 17, weight: .semibold))
                .lineLimit(1)

            Text(entry.description)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(2)

            Text(entry.date)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - 데이트로그 뷰
struct DateLogView: View {
    @State private var entries: [DateLogEntry] = sampleDateLog
    @State private var showingAdd = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("지난 데이트")
                    .font(.headline)
                    .padding(.horizontal, 16)

                ForEach(entries) { entry in
                    DateLogCard(entry: entry)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .navigationTitle("데이트 로그")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAdd = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddDateLogView(
                    isPresented: $showingAdd     // ① 바인딩 전달
                ) { newEntry in                 // ② 저장 콜백
                    entries.insert(newEntry, at: 0)
                }
        }
    }
}

// MARK: - 미리보기
struct DateLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DateLogView()
        }
    }
}
