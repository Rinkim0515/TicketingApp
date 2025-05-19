//
//  ErrorHandler.swift
//  GGV
//
//  Created by KimRin on 5/11/25.
// 추후 확장가능성 있음 

import Foundation


enum NetworkError: Error {
    case badURL
    case timeout
    case noConnection
    case invalidResponse
    case decodingFailed
}


enum RepositoryError: Error {
    case network(NetworkError)
    case noData
    case unknown
}


enum AppError: Error {
    case network(NetworkError)
    case repository(RepositoryError)
    case custom(message: String)
}


struct ErrorHandlingResult {
    let shouldRetry: Bool
    let fallbackData: Any?
    let userMessage: String?
}

protocol ErrorHandlingStrategy {
    func handle(error: AppError) -> ErrorHandlingResult
}


final class TimeoutRetryStrategy: ErrorHandlingStrategy {
    private let retryAction: () async -> Void

    init(retryAction: @escaping () async -> Void) {
        self.retryAction = retryAction
    }

    func handle(error: AppError) -> ErrorHandlingResult {
        // Retry logic is executed asynchronously
        Task {
            await retryAction()
        }

        return ErrorHandlingResult(
            shouldRetry: true,
            fallbackData: nil,
            userMessage: "요청이 지연되어 다시 시도하고 있습니다."
        )
    }
}

