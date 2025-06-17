//
//  DateLogDetailView.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import SwiftUI

// MARK: - 데이트 로그 상세 모델
struct DateLogDetail: Identifiable {
    let id = UUID()
    let imageName: String       // 상단 이미지
    let title: String           // 제목
    let date: String            // yyyy.MM.dd
    let locationName: String    // 위치명
    let locationAddress: String // 상세 주소
    let courses: [DetailCourseItem]   // 데이트 코스 목록
    let memo: String            // 메모
}

// MARK: - 상세 코스 아이템
struct DetailCourseItem: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
}

// MARK: - 상세 화면 뷰
struct DateLogDetailView: View {
    let entry: DateLogDetail
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 상단 이미지
                Image(entry.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .clipped()

                // 제목 + 날짜
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.title)
                        .font(.title2).bold()
                    Text(entry.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // 위치 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("위치")
                        .font(.headline)
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.black)
                        }
                        .frame(width: 32, height: 32)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.locationName)
                                .font(.subheadline).bold()
                            Text(entry.locationAddress)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

                // 데이트 코스 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("데이트 코스")
                        .font(.headline)
                    ForEach(entry.courses) { course in
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                                Image(systemName: course.iconName)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 32, height: 32)

                            Text(course.title)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal)

                // 메모 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("메모")
                        .font(.headline)
                    Text(entry.memo)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)

                Spacer(minLength: 20)
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
    }
}

// MARK: - 미리보기
struct DateLogDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DateLogDetailView(
                entry: DateLogDetail(
                    imageName: "sample04",
                    title: "편안한 일상 데이트",
                    date: "2024.07.21",
                    locationName: "주 데이트 장소",
                    locationAddress: "데이트 위치",
                    courses: [
                        DetailCourseItem(iconName: "mappin.and.ellipse", title: "투썸 플레이스에서 커피 마시기"),
                        DetailCourseItem(iconName: "mappin.and.ellipse", title: "경의선 숲길 걷기"),
                        DetailCourseItem(iconName: "mappin.and.ellipse", title: "저녁 식사 장소")
                    ],
                    memo: "너무 좋아요"
                )
            )
        }
    }
}
