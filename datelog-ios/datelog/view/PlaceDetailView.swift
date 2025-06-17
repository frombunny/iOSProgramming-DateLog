//
//  PlaceDetailView.swift
//  datelog
//
//  Created by 임혜정 on 6/17/25.
//

import SwiftUI

// MARK: - 데이터 모델
struct Review: Identifiable {
    let id = UUID()
    let avatar: String    // 이미지 이름
    let username: String
    let date: String      // "yyyy.MM.dd"
    let rating: Int       // 1...5
    let comment: String
}

// MARK: - 별점 뷰
struct StarRatingView: View {
    @Binding var rating: Int
    var maxRating = 5
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \ .self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

// MARK: - 리뷰 작성 팝업
struct ReviewInputView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 5
    @State private var comment: String = ""

    var onSubmit: (Review) -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("별점")
                    .font(.headline)
                StarRatingView(rating: $rating)

                Text("리뷰")
                    .font(.headline)
                TextEditor(text: $comment)
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )

                Spacer()
            }
            .padding()
            .navigationBarTitle("리뷰 남기기", displayMode: .inline)
            .navigationBarItems(
                leading: Button("취소") {
                    isPresented = false
                },
                trailing: Button("등록") {
                    let newReview = Review(
                        avatar: "avatar_placeholder",
                        username: "나의 닉네임",
                        date: DateFormatter.localizedString(
                            from: Date(),
                            dateStyle: .medium,
                            timeStyle: .none),
                        rating: rating,
                        comment: comment
                    )
                    onSubmit(newReview)
                    isPresented = false
                }
            )
            .background(Color.white)
        }
    }
}

// MARK: - 상세 화면 뷰
struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let imageName: String
    let title: String
    let description: String
    let locationName: String
    let locationAddress: String

    @State private var reviews: [Review] = [
        Review(avatar: "avatar1", username: "상상부기", date: "2014.12.21", rating: 5, comment: "너무 맛있어요 안성재 최고"),
        Review(avatar: "avatar2", username: "밥 먹는 부기", date: "2025.05.23", rating: 4, comment: "근사한 경험이었어요")
    ]
    @State private var showingReviewSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .clipped()

                    // 제목 및 설명
                    VStack(alignment: .leading, spacing: 12) {
                        Text(title)
                            .font(.title2).bold()
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    // 위치
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.black)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(locationName)
                                .font(.subheadline).bold()
                            Text(locationAddress)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // 리뷰 목록
                    VStack(alignment: .leading, spacing: 16) {
                        Text("리뷰")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(reviews) { review in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(review.avatar)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(review.username)
                                            .font(.subheadline).bold()
                                        Text(review.date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                StarRatingView(rating: .constant(review.rating))
                                Text(review.comment)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                    }

                    // 리뷰 작성 버튼
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
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            .background(Color.white)
            .sheet(isPresented: $showingReviewSheet) {
                ReviewInputView(isPresented: $showingReviewSheet) { newReview in
                    reviews.insert(newReview, at: 0)
                }
            }
        }
    }
}

// MARK: - 미리보기
struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(
            imageName: "place_sample",
            title: "모수",
            description: String(repeating: "안성재 셰프의 모수에서 한 끼 ", count: 4),
            locationName: "모수",
            locationAddress: "모수 주소"
        )
    }
}
