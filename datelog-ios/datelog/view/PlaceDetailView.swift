//
//  PlaceDetailView.swift
//  datelog
//
//  Created by 임혜정 on 6/17/25.
//

import SwiftUI

// MARK: - 데이터 모델
struct PlaceDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let httpStatus: Int
    let message: String
    let data: PlaceDetail?
    let timeStamp: String
}
struct PlaceDetail: Decodable {
    let id: Int
    let name: String
    let content: String
    let location: String
    let image: String
    let reviewList: [ReviewItem]
}

struct ReviewItem: Decodable, Identifiable {
    var id: String { "\(reviewDate)-\(username)" }
    let reviewDate: String
    let username: String
    let content: String
}

// MARK: - 상세 화면 뷰
struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let place: PlaceDetail
    @State private var newReviews: [ReviewItem] = []
    @State private var showingReviewSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageSection
                infoSection
                locationSection
                reviewSection
                writeButton
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
        .background(Color.white)
        .sheet(isPresented: $showingReviewSheet) {
            SimpleReviewInputView(isPresented: $showingReviewSheet) { comment in
                Task {
                    do {
                        // 1. 서버에 POST 전송
                        try await APIManager.shared.createReview(placeId: String(place.id), content: comment)
                        
                        // 2. 성공 시 새 리뷰를 로컬에 추가 (필요하다면!)
                        let newReview = ReviewItem(
                            reviewDate: ISO8601DateFormatter().string(from: Date()),
                            username: "아보카도", // 서버에서 따로 관리. 임시 UI용
                            content: comment
                        )
                        newReviews.insert(newReview, at: 0)
                        
                    } catch {
                    }
                }
            }
        }
    }

    // 이미지 섹션
    private var imageSection: some View {
        Group {
            if let url = URL(string: place.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.1)
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .failure:
                        Color.red
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 240)
                .clipped()
            }
        }
    }

    // 제목, 설명
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(place.name)
                .font(.title2).bold()
            Text(place.content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    // 위치
    private var locationSection: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.black)
            Text(place.location)
                .font(.subheadline)
        }
        .padding(.horizontal)
    }

    // 리뷰 목록
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("리뷰")
                .font(.headline)
                .padding(.horizontal)

            ForEach(place.reviewList + newReviews) { review in
                reviewRow(review)
            }
        }
    }

    // 리뷰 1개
    private func reviewRow(_ review: ReviewItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.username)
                        .font(.subheadline).bold()
                    Text(formatDate(review.reviewDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Text(review.content)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
    }

    // 리뷰 작성 버튼
    private var writeButton: some View {
        Button(action: { showingReviewSheet = true }) {
            Text("리뷰 남기기")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }

    // 날짜 포맷
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


// 리뷰 입력 뷰 (간단)
struct SimpleReviewInputView: View {
    @Binding var isPresented: Bool
    @State private var comment: String = ""

    var onSubmit: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 10) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.pink)
                        .font(.system(size: 28, weight: .bold))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("리뷰 남기기")
                            .font(.system(size: 20, weight: .semibold))
                        Text("여러분의 경험을 나눠주세요!")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 8)

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 120)
                    TextEditor(text: $comment)
                        .padding(12)
                        .frame(height: 120)
                        .background(Color.clear)
                        .cornerRadius(12)
                    if comment.isEmpty {
                        Text("여기에 리뷰를 입력하세요")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("등록") {
                        onSubmit(comment)
                        isPresented = false
                    }
                    .disabled(comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .font(.system(size: 17, weight: .bold))
                }
            }
        }
    }
}

// MARK: - 미리보기
struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(place: PlaceDetail(
            id:1,
            name: "모수",
            content: "안성재 셰프의 모수에서 한 끼",
            location: "서울시 강남구",
            image: "",
            reviewList: [
                ReviewItem(reviewDate: "2025-06-18T08:10:25.938566", username: "상상부기", content: "너무 맛있어요 안성재 최고"),
                ReviewItem(reviewDate: "2025-06-18T15:35:32.462228", username: "밥 먹는 부기", content: "근사한 경험이었어요")
            ]
        ))
    }
}
