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


private var topBanner: some View {
    HStack(alignment: .center, spacing: 12) {
        Image(systemName: "sparkles")
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(Color.pink)
        VStack(alignment: .leading, spacing: 2) {
            Text("“함께 떠날 준비 되셨나요?”")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Text("데이트의 설렘을 더해주는 오늘의 추천")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity)
    .background(
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Color.pink.opacity(0.15))
    )
    .padding(.horizontal, 2)
    .padding(.top, 10)
}



// MARK: - 뷰
struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAddSheet = false
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem { Label("홈", systemImage: "house.fill") }
                BrowseView()
                    .tabItem { Label("찾아보기", systemImage: "magnifyingglass") }
                DateLogView()
                    .tabItem { Label("데이트로그", systemImage: "calendar") }
            }
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                ToolbarItem(placement: .principal) {
                    Text("Date:Log")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                            AddDateLogView(isPresented: $showAddSheet) {
                            }
                        }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct HomeView: View {
    @State private var recommended: [PlaceItem] = []
    @State private var recent: [PlaceItem] = []         // ← 최근 방문 State 추가
    @State private var isLoading = false
    @State private var errorMessage: String?

    @State private var selectedPlace: PlaceDetail?
    @State private var isDetailLoading = false
    @State private var isShowingDetail = false
    @State private var detailError: String?

    var body: some View {
        NavigationStack {
            ZStack {
                mainScroll
                if isDetailLoading { loadingOverlay }
            }
            .background(detailNavigation)
            .alert("데이터 로드 실패", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("확인", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
            .task { await loadPlaces() }
        }
    }

    private var mainScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                topBanner
                Text("오늘의 데이트 추천")
                    .font(.system(size: 26, weight: .semibold))
                    .padding(.top, 8)

                Text("당신을 위한 추천")
                    .font(.headline)
                    .padding(.horizontal, 4)

                if isLoading && recommended.isEmpty {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    recommendScroll
                }

                Text("최근 방문 데이트 장소")
                    .font(.headline)
                    .padding(.horizontal, 4)

                if isLoading && recent.isEmpty {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    recentScroll
                }
            }
            .padding(.horizontal, 12)
        }
    }

    // 추천 리스트 가로 스크롤
    private var recommendScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recommended) { place in
                    Button {
                        Task { await loadPlaceDetail(id: String(describing: place.id)) }
                    } label: {
                        PlaceCard(
                            title: place.title,
                            description: place.description,
                            imageURL: place.imageURL
                        )
                        .frame(width: 184, height: 213)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // 최근 방문 리스트 가로 스크롤
    private var recentScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recent) { place in
                    Button {
                        Task { await loadPlaceDetail(id: String(describing: place.id)) }
                    } label: {
                        PlaceCard(
                            title: place.title,
                            description: place.description,
                            imageURL: place.imageURL
                        )
                        .frame(width: 184, height: 213)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.08).ignoresSafeArea()
            ProgressView("불러오는 중...")
                .padding()
                .background(Color.white)
                .cornerRadius(12)
        }
    }

    private var detailNavigation: some View {
        NavigationLink(
            destination: selectedPlace.map { PlaceDetailView(place: $0) },
            isActive: $isShowingDetail,
            label: { EmptyView() }
        )
    }

    // 데이터 로딩 함수 (추천, 최근 둘 다 로드)
    func loadPlaces() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let rec = APIManager.shared.fetchRecommendedPlaces()
            async let recnt = APIManager.shared.fetchRecentPlaces()
            let (r1, r2) = try await (rec, recnt)
            recommended = r1
            recent = r2
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadPlaceDetail(id: String) async {
        isDetailLoading = true
        defer { isDetailLoading = false }
        do {
            selectedPlace = try await APIManager.shared.fetchPlaceDetail(id: id)
            isShowingDetail = true
        } catch {
            detailError = error.localizedDescription
            errorMessage = "상세 정보 로딩 실패: \(error.localizedDescription)"
        }
    }
}


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
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 128)
                .clipped()
                .cornerRadius(8)
            } else {
                Color.gray.opacity(0.1)
                    .frame(height: 128)
                    .cornerRadius(8)
            }
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
            Text(description)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


// MARK: - 미리보기
#Preview {
    ContentView()
}
