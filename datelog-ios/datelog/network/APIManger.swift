//
//  APIManger.swift
//  datelog
//
//  Created by 임혜정 on 6/18/25.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

actor APIManager {
    static let shared = APIManager()
    private init() {}
    
    private var baseURL = "http://localhost:8080"

    /// 회원가입 API
    func signUp(nickname: String,
                email: String,
                password: String,
                profileImageItem: PhotosPickerItem?) async throws {
        // 1. URL
        guard let url = URL(string: "http://localhost:8080/api/user") else {
            throw URLError(.badURL)
        }
        // 2. 요청 준비
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 3. 바디 조립
        var body = Data()
        func appendField(name: String, value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        appendField(name: "nickname", value: nickname)
        appendField(name: "email",    value: email)
        appendField(name: "password", value: password)

        if let item = profileImageItem,
           let imgData = try? await item.loadTransferable(type: Data.self) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"avatar.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imgData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        // 4. 전송 및 응답 처리
        let (data, response) = try await URLSession.shared.data(for: request)

        // 1) 먼저 response 를 HTTPURLResponse 로 캐스팅
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // 2) statusCode 체크
        guard (200..<300).contains(httpResponse.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "SignUpError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: msg]
            )
        }
    }
    
    // 로그인 API
    func login(email: String, password: String) async throws -> String {
        // 1. URL
        guard let url = URL(string: "http://localhost:8080/api/user/login") else {
          throw URLError(.badURL)
        }

        // 2. 요청 준비
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 3. 바디 조립
        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)

        // 4. 전송 & 응답
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
          throw URLError(.badServerResponse)
        }
        guard (200..<300).contains(http.statusCode) else {
          let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
          throw NSError(domain: "LoginError", code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: msg])
        }

        // 5. 디코딩
        let decoder = JSONDecoder()
        // 서버 응답 래핑 구조체
        struct ApiResponse<T: Codable>: Codable {
          let isSuccess: Bool
          let code: String
          let httpStatus: Int
          let message: String
          let data: T
          let timeStamp: String
        }
        // 실제 토큰만 담긴 데이터
        struct LoginData: Codable {
          let token: String
        }

        // 래핑된 전체 구조체를 디코딩
        let wrapper = try decoder.decode(ApiResponse<LoginData>.self, from: data)
        return wrapper.data.token
      }
    
    // 요청 만들기 함수
    private func makeRequest(path: String) throws -> URLRequest {
            guard let url = URL(string: baseURL + path) else {
                throw URLError(.badURL)
            }
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            // JWT 토큰이 UserDefaults 에 저장되어 있다고 가정
            if let token = UserDefaults.standard.string(forKey: "jwtToken") {
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return req
        }

        // 최근 방문 장소 조회 API
        func fetchRecentPlaces() async throws -> [PlaceItem] {
            let req = try makeRequest(path: "/api/place/recent")
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode(APIResponse<[PlaceItem]>.self, from: data)
            return decoded.data
        }
    
        // 리뷰 작성 API
        func createReview(placeId: String, content: String) async throws {
            guard let url = URL(string: "http://localhost:8080/api/review/\(placeId)") else {
                throw URLError(.badURL)
            }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "jwtToken") {
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            let body: [String: Any] = ["content": content]
            req.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (_, res) = try await URLSession.shared.data(for: req)
            guard let httpRes = res as? HTTPURLResponse, (200...299).contains(httpRes.statusCode) else {
                throw URLError(.badServerResponse)
        }
    }
        
        // 추천 장소 조회 API
        func fetchRecommendedPlaces() async throws -> [PlaceItem] {
            let req = try makeRequest(path: "/api/place/recommend")
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode(APIResponse<[PlaceItem]>.self, from: data)
            return decoded.data
        }
    
        // 장소 상세 조회 API
        func fetchPlaceDetail(id: String) async throws -> PlaceDetail {
            let url = URL(string: "http://localhost:8080/api/place/\(id)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PlaceDetailResponse.self, from: data)
            // PlaceDetailResponse에서 data 필드를 꺼내 반환
            if let detail = decoded.data {
                return detail
            } else {
                throw URLError(.badServerResponse)
            }
        }
    
        // 필터링 검색 API
        func fetchPlaces(tagKor: String?, keyword: String) async throws -> [PlaceItem] {
                var urlStr = "http://localhost:8080/api/place?"
                var query = [String]()
                if let tagKor = tagKor, tagKor != "전체", let tagEnum = tagEnumString(from: tagKor) {
                    query.append("tag=\(tagEnum)")
                }
                if !keyword.isEmpty {
                    query.append("keyword=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
                }
                urlStr += query.joined(separator: "&")
                    
                guard let url = URL(string: urlStr) else { throw URLError(.badURL) }
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(PlaceListResponse.self, from: data)
                return decoded.data
        }
        
        // 데이트로그 가져오기 API
        func fetchAllDateLogs() async throws -> [DateLogItem] {
            let req = try makeRequest(path: "/api/datelog/all")
            print(req)
            let (data, _) = try await URLSession.shared.data(for: req)
            let decoded = try JSONDecoder().decode(DateLogListResponse.self, from: data)
            print(decoded)
            return decoded.data
        }
    
        // 데이트로그 상세 조회
        func fetchDateLogDetail(datelogId: Int) async throws -> DateLogDetailRes {
            let req = try makeRequest(path: "/api/datelog/\(datelogId)")
            let (data, _) = try await URLSession.shared.data(for: req)
            let decoded = try JSONDecoder().decode(DateLogDetailResponse.self, from: data)
            return decoded.data
        }

    
        // 데이트로그 작성 API
        func createDateLog(imageData: Data?, name: String, date: String, location: String, title: String, diary: String) async throws {
            let boundary = UUID().uuidString
            var req = URLRequest(url: URL(string: "http://localhost:8080/api/datelog")!)
            req.httpMethod = "POST"
            req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "jwtToken") {
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        
            var body = Data()
        
            // 1. 이미지
            if let imageData = imageData {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        
            // 2. 텍스트 필드들
            let params: [(String, String)] = [
                ("name", name),
                ("date", date),
                ("location", location),
                ("title", title),
                ("diary", diary)
            ]
            for (key, value) in params {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            req.httpBody = body
        
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }
    }

            
func tagEnumString(from kor: String) -> String? {
    switch kor {
        case "로맨틱":      return "ROMANTIC"
        case "어드벤처":    return "ADVENTURE"
        case "힐링":        return "HEALING"
        case "집중":        return "FOCUS"
        case "문화·예술":   return "CULTURE_ART"
        case "액티비티":    return "ACTIVITY"
        default:            return nil
    }
}

        

// Data 편의 확장
private extension Data {
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) {
            append(d)
        }
    }
}

// 공통 API 응답 래퍼
struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let httpStatus: Int
    let message: String
    let data: T
}

// 개별 장소 아이템
struct PlaceItem: Identifiable, Codable {
    let id: Int
    let image: String       // URL 문자열
    let name: String
    let content: String

    // UI 용 식별자
    var uuid: UUID { UUID() }
    var title: String { name }
    var description: String { content }
    var imageURL: URL? { URL(string: image) }
}
