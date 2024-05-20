//
//  SourceModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

struct SourceModel: Codable {
    let id: String?
    let name: String?
}

extension SourceModel {
    func asDomain() -> Source {
        .init(id: id, name: name)
    }
}
