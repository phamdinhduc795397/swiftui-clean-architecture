//
//  ErrorResponseModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

struct ErrorResponseModel: Codable {
    let status, code, message: String
}
