//
//  DateLogDetailView.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import SwiftUI

struct DateLogDetailRes: Decodable, Identifiable {
    let id: Int
    let image: String
    let title: String
    let diary: String
}

struct DateLogDetailResponse: Decodable {
    let isSuccess: Bool
    let data: DateLogDetailRes
}



struct DateLogDetailView: View {
    let datelogId: Int
    @Environment(\.dismiss) private var dismiss

    @State private var detail: DateLogDetailRes?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    // MARK: - 랜덤 문구 배열 추가
    private let randomQuotes: [String] = [
        "오늘의 데이트도 행복한 추억으로 남으셨나요?",
        "모든 순간이 소중한 기억이 될 거예요.",
        "사랑은 작은 기록에서 시작됩니다.",
        "당신의 데이트를 DateLog가 응원합니다!",
        "오늘도 사랑이 가득한 하루였네요."
    ]

    // MARK: - 랜덤 문구를 선택하는 함수
    private func getRandomQuote() -> String {
        return randomQuotes.randomElement() ?? "오늘도 행복한 하루 되세요!"
    }
    
    // MARK: - 랜덤 한마디 배너 뷰
        private var randomQuoteBanner: some View {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "heart.fill") // 하트 아이콘으로 변경
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color.red) // 색상도 빨간색으로 변경
                VStack(alignment: .leading, spacing: 2) {
                    Text(getRandomQuote()) // 여기서 랜덤 문구를 가져옴
                        .font(.system(size: 17, weight: .semibold)) // 폰트 사이즈 조정
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.red.opacity(0.15)) // 배경 색상도 빨간색 계열로 변경
            )
            .padding(.horizontal, 20) // 양 옆 패딩 좀 더 넓게
            .padding(.top, 20) // 위쪽 패딩 추가
        }

    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                if isLoading {
                    VStack(spacing: 12) {
                        Spacer(minLength: 100)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        Text("불러오는 중...").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 320)
                } else if let detail = detail {
                    VStack(alignment: .leading, spacing: 28) {
                        // 이미지 카드
                        if let url = URL(string: detail.image) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        Color(.systemGray5)
                                        ProgressView()
                                    }
                                case .success(let img):
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .overlay(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.black.opacity(0.04), .clear, .black.opacity(0.13)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                case .failure:
                                    ZStack {
                                        Color(.systemGray5)
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                    }
                                @unknown default: EmptyView()
                                }
                            }
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(18)
                            .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
                            .padding([.top, .horizontal])
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            // 날짜 (오늘 날짜가 아니라면 아래처럼 가공)
                            Text(Date.now, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.bottom, 2)
                            // 제목
                            Text(detail.title)
                                .font(.system(size: 23, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                        }

                        // 일기(메모) 카드
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "text.justify.left")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18))
                                Text("일기")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.bottom, 2)

                            Text(detail.diary)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(6)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color(.white))
                                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                                )
                            
                            randomQuoteBanner // 새로 정의한 랜덤 한마디 배너 추가
                                .padding(.bottom, 20) // 배너 아래 여백
                            Spacer(minLength: 20)
                        }
                        
                        
                        .padding([.horizontal, .bottom])

                        Spacer(minLength: 20)
                    }
                    .padding(.top, 10)
                } else {
                    VStack(spacing: 12) {
                        Spacer(minLength: 100)
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("불러오기 실패")
                            .font(.headline)
                        if let msg = errorMessage {
                            Text(msg).font(.footnote).foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 320)
                }
            }
        }
        .navigationBarTitle("데이트 로그", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .task { await loadDetail() }
        .alert("불러오기 실패", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("확인", role: .cancel) { errorMessage = nil }
        }
    }

    func loadDetail() async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.detail = try await APIManager.shared.fetchDateLogDetail(datelogId: datelogId)
            self.errorMessage = nil
        } catch {
            self.detail = nil
            self.errorMessage = error.localizedDescription
        }
    }
}
