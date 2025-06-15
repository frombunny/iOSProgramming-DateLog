//
//  BrowseView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//

import Foundation
import SwiftUI

// MARK: - 목업 데이터
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

let browseCategories: [Category] = [
    .init(name: "로맨틱"),
    .init(name: "어드벤처"),
    .init(name: "힐링"),
    .init(name: "집중"),
    .init(name: "문화·예술"),
    .init(name: "액티비티")
]

// MARK: - 장소
struct BrowsePlace: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let description: String
    let imageName: String   // Assets 에 넣어 둔 더미 이미지 이름
}

let browsePlaces: [BrowsePlace] = [
    // ── 로맨틱 ─────────────────────────────────────────
    .init(category: "로맨틱", title: "한강 야경 크루즈",
          description: "정류장 → 여의도 → 잠실 구간을 도는 70분 코스, 선상 라이브까지!",
          imageName: "romantic01"),
    .init(category: "로맨틱", title: "북촌 달빛 산책",
          description: "한옥 지붕 사이로 보름달 뜨는 밤, 전통 찻집에서 야간 티타임.",
          imageName: "romantic02"),

    // ── 어드벤처 ───────────────────────────────────────
    .init(category: "어드벤처", title: "실내 암벽 ‘클라이밍 팩토리’",
          description: "높이 15 m 리드벽과 80개 루트. 장비 대여 가능, 입문 강습 포함.",
          imageName: "adventure01"),
    .init(category: "어드벤처", title: "용평 리조트 집라인",
          description: "산 정상에서 내려오는 1.5 km 코스, 최고 시속 80 km 짜릿한 스릴!",
          imageName: "adventure02"),

    // ── 힐링 ─────────────────────────────────────────
    .init(category: "힐링", title: "성수 미술관 방문",
          description: "현대미술 전시와 루프톱 카페가 한 건물에. 조용히 작품 감상하기 좋음.",
          imageName: "healing01"),
    .init(category: "힐링", title: "지리산 둘레길 트레킹",
          description: "남원 – 산청 구간 12 km, 완만한 흙길 위 숲속 피톤치드 가득 코스.",
          imageName: "healing02"),
    .init(category: "힐링", title: "쿠킹 스튜디오 ‘소금 한 꼬집’",
          description: "커플 파스타 클래스·디저트 클래스 매주 진행, 재료·앞치마 제공.",
          imageName: "healing03"),

    // ── 집중(스터디) ───────────────────────────────────
    .init(category: "집중", title: "24h 무제한 스터디카페",
          description: "전 좌석 콘센트·개별 조명, 1인실 & 커플좌석, 무료 탄산·원두커피.",
          imageName: "focus01"),
    .init(category: "집중", title: "디지털 노마드 라운지",
          description: "아이패드 대여·화상회의 부스·폰 부스 완비, 조용히 코딩하기 좋음.",
          imageName: "focus02"),

    // ── 문화·예술 ────────────────────────────────────
    .init(category: "문화·예술", title: "뮤지컬 〈레베카〉",
          description: "충무아트센터 대극장, 화~일 19:30 · 주말 14:00/19:00.",
          imageName: "culture01"),
    .init(category: "문화·예술", title: "필름 사진관 포토데이트",
          description: "흑백 필름 1롤 촬영 + 인화 8컷 패키지, 빈티지 소품 무료 대여.",
          imageName: "culture02"),

    // ── 액티비티 ─────────────────────────────────────
    .init(category: "액티비티", title: "室內 서핑 ‘웨이브파크’",
          description: "인공 파도에서 45분 세션 서핑, 초보 강습 포함 장비 풀셋 제공.",
          imageName: "activity01"),
    .init(category: "액티비티", title: "실내 스카이다이빙",
          description: "바람 터널에서 떠오르는 플라잉 체험, VR 패키지 옵션 가능.",
          imageName: "activity02")
]


// MARK: - 카테고리 Chip
struct CategoryChip: View {
    var category: Category
    var isSelected: Bool

    var body: some View {
        Text(category.name)
            .font(.subheadline).bold()
            .padding(.vertical, 8).padding(.horizontal, 16)
            .background(isSelected ? Color.accentColor.opacity(0.15)
                                   : Color(.systemGray6))
            .foregroundColor(isSelected ? .accentColor : .primary)
            .clipShape(Capsule())
    }
}

// MARK: - 카드 행
struct PlaceRow: View {
    var place: BrowsePlace

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.category)
                    .font(.caption).foregroundColor(.secondary)
                Text(place.title)
                    .font(.system(size: 15, weight: .semibold))
                Text(place.description)
                    .font(.footnote).foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(place.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 80)
                .clipped()
                .cornerRadius(8)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 메인 Browse View
struct BrowseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var keyword = "검색어를 입력해주세요"
    @State private var selectedCategory: Category? = browseCategories[2] // “힐링”

    // 필터링 로직
    var filteredPlaces: [BrowsePlace] {
        browsePlaces.filter { place in
            (selectedCategory == nil || place.category == selectedCategory!.name) &&
            (keyword.isEmpty || place.title.contains(keyword) || place.description.contains(keyword))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 검색창
                    SearchBar(text: $keyword)

                    // 카테고리 Chip 목록
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(browseCategories) { cat in
                                CategoryChip(category: cat,
                                             isSelected: cat == selectedCategory)
                                    .onTapGesture { selectedCategory = cat }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // 리스트
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredPlaces) { place in
                            PlaceRow(place: place)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
            }
            .navigationTitle("데이트장소 찾아보기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                        }
        }
    }
}

// MARK: - 미리보기
#Preview("Browse") {
    BrowseView()
}
