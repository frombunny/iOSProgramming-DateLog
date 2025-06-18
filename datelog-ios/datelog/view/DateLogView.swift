//
//  DateLogView.swift
//  datelog
//
//  Created by 임혜정 on 6/17/25.
//


import SwiftUI

struct DateLogItem: Identifiable, Decodable {
    let id: Int
     let image: String
     let title: String
     let diary: String
}

struct DateLogListResponse: Decodable {
    let isSuccess: Bool
    let data: [DateLogItem]
}

struct DateLogCard: View {
    let entry: DateLogItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 서버 이미지라면 AsyncImage 사용
            if let url = URL(string: entry.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: Color.gray.opacity(0.1)
                    case .success(let img): img.resizable().scaledToFill()
                    case .failure: Color.red
                    @unknown default: EmptyView()
                    }
                }
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            } else {
                Color.gray.opacity(0.1)
                    .frame(height: 180)
                    .cornerRadius(12)
            }

            Text(entry.title)
                .font(.system(size: 17, weight: .semibold))
                .lineLimit(1)

            Text(entry.diary)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    func formatDate(_ iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd"
        if let date = isoFormatter.date(from: iso) {
            return displayFormatter.string(from: date)
        }
        return iso.prefix(10).replacingOccurrences(of: "-", with: ".")
    }
}


// MARK: - 데이트로그 뷰
struct DateLogView: View {
    @State private var entries: [DateLogItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingAdd = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("지난 데이트")
                    .font(.headline)
                    .padding(.horizontal, 16)

                if isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    ForEach(entries) { entry in
                        NavigationLink(destination: DateLogDetailView(datelogId: entry.id)) {
                            DateLogCard(entry: entry)
                                .padding(.horizontal, 16)
                        }
                    }
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
                        }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddDateLogView(isPresented: $showingAdd) {
                        // 저장 성공 시 호출 (전체 리스트 새로고침)
                        Task { await loadDateLogs() }
                    }
                }
                .task { await loadDateLogs() }
        .alert("불러오기 실패", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("확인", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    func loadDateLogs() async {
        isLoading = true
        defer { isLoading = false }
        do {
            entries = try await APIManager.shared.fetchAllDateLogs()
        } catch {
            errorMessage = error.localizedDescription
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
