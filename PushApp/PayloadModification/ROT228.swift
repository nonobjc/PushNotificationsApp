//
//  ROT228.swift
//  PayloadModification
//
//  Created by Alexander on 19/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

struct ROT228 {
    static let shared = ROT228()
    
    private let upper = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let lower = Array("abcdefghijklmnopqrstuvwxyz")
    private var mapped = [Character: Character]()
    
    private init() {
        for i in 0 ..< 26 {
            let idx = (i + 228) % 26
            mapped[upper[i]] = upper[idx]
            mapped[lower[i]] = lower[idx]
        }
    }
    
    public func decrypt(_ str: String) -> String {
        return String(str.map { mapped[$0] ?? $0 })
    }
}
