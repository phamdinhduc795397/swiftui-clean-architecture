//
//  NetworkError.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

enum NetworkError: LocalizedError, Error {
    case badRequest(error: ErrorResponseModel)  // 400
    case unauthorized(error: ErrorResponseModel) // 401
    case invalidResponse
    case unknown
}
