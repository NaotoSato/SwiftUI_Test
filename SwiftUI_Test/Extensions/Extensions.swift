//
//  Extensions.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/07.
//

import Foundation

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

