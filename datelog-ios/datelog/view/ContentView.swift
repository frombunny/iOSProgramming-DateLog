//
//  ContentView.swift
//  datelog
//
//  Created by 임혜정 on 6/15/25.
// 메인 화면

import SwiftUI

// MARK: - 모델 & 목업 데이터
struct Place: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String   // Assets.xcassets 에 넣은 임시 이미지 이름
}

// MARK: - 뷰
struct ContentView: View {
  var body: some View {
    NavigationStack {
      TabView {
        HomeView()
          .tabItem { Label("홈",   systemImage: "house.fill") }

        BrowseView()
          .tabItem { Label("찾아보기", systemImage: "magnifyingglass") }

          DateLogView()
          .tabItem { Label("데이트로그", systemImage: "calendar") }
      }
      // 공통 툴바 / 타이틀
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Date:Log").font(.headline)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct HomeView: View {
    @State private var recommended: [PlaceItem] = []
    @State private var recent: [PlaceItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    @State private var keyword: String = ""

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) { // spacing 넉넉히
                    Text("오늘의 데이트 추천")
                        .font(.system(size: 26, weight: .semibold))
                        .padding(.top, 8)

                    SearchBar(text: $keyword)
                        .padding(.bottom, 8)

                    Group {
                        Text("당신을 위한 추천")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        if isLoading && recommended.isEmpty {
                            ProgressView().frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) { // 카드 간 간격 여유 있게
                                    ForEach(recommended) { place in
                                        NavigationLink {
                                            PlaceDetailView(
                                                imageName: place.image,
                                                title: place.title,
                                                description: place.description,
                                                locationName: place.title,
                                                locationAddress: ""
                                            )
                                        } label: {
                                            PlaceCard(
                                                title: place.title,
                                                description: place.description,
                                                imageURL: place.imageURL
                                            )
                                            .frame(width: 184, height: 213) // 카드 크기 고정
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }

                    Group {
                        Text("최근 방문 데이트 장소")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        if isLoading && recent.isEmpty {
                            ProgressView().frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) { // 여기서 가로 스크롤로 변경!
                                HStack(spacing: 16) {
                                    ForEach(recent) { place in
                                        NavigationLink {
                                            PlaceDetailView(
                                                imageName: place.image,
                                                title: place.title,
                                                description: place.description,
                                                locationName: place.title,
                                                locationAddress: ""
                                            )
                                        } label: {
                                            PlaceCard(
                                                title: place.title,
                                                description: place.description,
                                                imageURL: place.imageURL
                                            )
                                            .frame(width: 184, height: 213) // 동일하게 고정
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12) // 전체 좌우 마진
                .padding(.bottom, 80)
                .alert("데이터 로드 실패", isPresented: Binding<Bool>(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )) {
                    Button("확인", role: .cancel) { errorMessage = nil }
                } message: {
                    Text(errorMessage ?? "")
                }
                .task {
                    await loadPlaces()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Date:Log").font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "magnifyingglass")
                }
            }
        }

    private func loadPlaces() async {
        isLoading = true
        do {
            async let rec = APIManager.shared.fetchRecommendedPlaces()
            async let recnt = APIManager.shared.fetchRecentPlaces()
            let (r1, r2) = try await (rec, recnt)
            recommended = r1
            recent      = r2
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
        isLoading = false
    }

    // MARK: - PlaceCard 재사용 가능한 뷰
    struct PlaceCard: View {
        let title: String
        let description: String
        let imageURL: URL?

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.1)
                        case .success(let img):
                            img.resizable().scaledToFill()
                        case .failure:
                            Color.red
                        @unknown default: EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 128)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.1)
                        .frame(maxWidth: .infinity, maxHeight: 128)
                        .cornerRadius(8)
                }

                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)

                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
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
    }
}

// MARK: - 미리보기
#Preview {
    ContentView()
}
