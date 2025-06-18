//
//  BrowseView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
//
// 데이트장소 검색 화면

import Foundation
import SwiftUI

// MARK: - 목업 데이터
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

let browseCategories: [Category] = [
    .init(name: "전체"),
    .init(name: "로맨틱"),
    .init(name: "어드벤처"),
    .init(name: "힐링"),
    .init(name: "집중"),
    .init(name: "문화·예술"),
    .init(name: "액티비티")
]

// MARK: - 장소
struct PlaceListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let httpStatus: Int
    let message: String
    let data: [PlaceItem]
    let timeStamp: String
}

struct BrowsePlace: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let description: String
    let imageName: String   // Assets 에 넣어 둔 더미 이미지 이름
}

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
            VStack(alignment: .leading, spacing: 10) {
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
    @State private var keyword: String = ""
    @State private var selectedCategory: Category? = browseCategories[0] // "전체" 기본
    @State private var places: [PlaceItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 검색창
                    SearchBar(text: $keyword)
                        .onChange(of: keyword) { _ in fetchPlaces() }

                    // 카테고리 Chip
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(browseCategories) { cat in
                                CategoryChip(category: cat,
                                             isSelected: cat == selectedCategory)
                                    .onTapGesture {
                                        selectedCategory = cat
                                        fetchPlaces()
                                    }
                            }
                        }.padding(.vertical, 4)
                    }

                    // 리스트
                    if isLoading {
                        ProgressView().frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(places) { place in
                                PlaceRowV2(place: place)
                                Divider()
                            }
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
            .alert("데이터 로드 실패", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("확인", role: .cancel) { errorMessage = nil }
            }
            .task { fetchPlaces() }
        }
    }

    func fetchPlaces() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                places = try await APIManager.shared.fetchPlaces(
                    tagKor: selectedCategory?.name,
                    keyword: keyword
                )
            } catch {
                errorMessage = error.localizedDescription
                places = []
            }
            isLoading = false
        }
    }
}

// 서버 PlaceItem 대응 Row
struct PlaceRowV2: View {
    let place: PlaceItem
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(place.content)
                    .font(.footnote).foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            if let url = place.imageURL {
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
                .frame(width: 120, height: 80)
                .clipped()
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("키워드를 검색해보세요", text: $text)
                .textInputAutocapitalization(.never)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.top, 10)
    }
}


// MARK: - 미리보기
#Preview("Browse") {
    BrowseView()
}
