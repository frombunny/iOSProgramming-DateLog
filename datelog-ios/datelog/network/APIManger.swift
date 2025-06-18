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
