//
//  ErrorHandler.swift
//  GGV
//
//  Created by KimRin on 5/11/25.
//

import Foundation

// MARK: - Network-Level Errors
enum NetworkError: Error {
    case badURL
    case timeout
    case noConnection
    case invalidResponse
    case decodingFailed
}

// MARK: - Repository-Level Errors
enum RepositoryError: Error {
    case network(NetworkError)
    case noData
    case unknown
}

// MARK: - Centralized App Error
enum AppError: Error {
    case network(NetworkError)
    case repository(RepositoryError)
    case custom(message: String)
}

// MARK: - Error Handling Result
/// A container that describes what action to take after handling an error.
struct ErrorHandlingResult {
    let shouldRetry: Bool
    let fallbackData: Any?
    let userMessage: String?
}

// MARK: - Error Handling Strategy Protocol
/// A protocol for defining specific behavior in response to an AppError.
protocol ErrorHandlingStrategy {
    func handle(error: AppError) -> ErrorHandlingResult
}

// MARK: - Timeout Retry Strategy
/// A strategy that handles timeout errors by triggering a retry.
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

