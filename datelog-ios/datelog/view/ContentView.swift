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

let sampleRecommended: [Place] = [
    .init(title: "한강 뷰 카페", description: "탁 트인 강변 야경을 보며 커피 한 잔", imageName: "sample01"),
    .init(title: "북촌 한옥길", description: "조용한 골목 산책 후 전통찻집", imageName: "sample02"),
    .init(title: "야외 재즈 공연", description: "감성 충만 라이브 재즈 나이트", imageName: "sample03")
]

let sampleVisited: [Place] = [
    .init(title: "서울숲 피크닉", description: "도심 속 잔디밭에서 간단히 브런치", imageName: "sample04"),
    .init(title: "롯데타워 전망대", description: "서울 야경을 한눈에 담다", imageName: "sample05"),
    .init(title: "양재 꽃 시장", description: "향긋한 꽃길 데이트", imageName: "sample06"),
    .init(title: "남산 케이블카", description: "서울 시티라이트 파노라마", imageName: "sample07")
]

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
    // 검색어 바인딩
    @State private var keyword: String = ""
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 페이지 타이틀
                    Text("오늘의 데이트 추천")
                        .font(.system(size: 26, weight: .semibold))
                        .padding(.top, 4)
                    
                    // 검색창
                    SearchBar(text: $keyword)
                    
                    // 추천 섹션
                    Text("당신을 위한 추천")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleRecommended) { place in
                                NavigationLink {
                                    // 여기에 PlaceDetailView 초기화
                                    PlaceDetailView(
                                        imageName: place.imageName,
                                        title: place.title,
                                        description: place.description,
                                        locationName: place.title,           // 임시로 제목을 위치명으로
                                        locationAddress: "서울시 어딘가"
                                    )
                                } label: {
                                    PlaceCard(place: place)
                                        .frame(width: 184, height: 213)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // 최근 방문 섹션
                    Text("최근 방문 데이트 장소")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    LazyVGrid(
                        columns: Array(repeating: .init(.flexible(), spacing: 8), count: 2),
                        spacing: 12
                    ) {
                        ForEach(sampleVisited) { place in
                            NavigationLink {
                                PlaceDetailView(
                                    imageName: place.imageName,
                                    title: place.title,
                                    description: place.description,
                                    locationName: place.title,
                                    locationAddress: "서울시 어딘가"
                                )
                            } label: {
                                PlaceCard(place: place)
                                    .frame(height: 213)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
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
    
    // MARK: - 서브뷰
    struct PlaceCard: View {
        let place: Place
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Image(place.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 128)
                    .clipped()
                    .cornerRadius(8)
                
                Text(place.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                
                Text(place.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
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
