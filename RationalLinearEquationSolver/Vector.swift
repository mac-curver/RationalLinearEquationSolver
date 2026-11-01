////
//  DynamicTextFields
//  Vector
//
//  Created by LegoEsprit on 19.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import os.log

final class Vector {
    var count: Int {
        vector.count
    }
    var vector: [Rational]
    
    init(value: Rational, count: Int) {
        Logger.login("", className: "Vector")
        vector = (0..<count).map { _ in
            value
        }
        Logger.logout("", className: "Vector")
    }
    
    init(vector newVector: Vector) {
        Logger.login("", className: "Vector")
        vector = newVector.vector
        Logger.logout("", className: "Vector")
    }
    
    init() {
        Logger.login("", className: "Vector")
        // Invalid entry
        //vector = [Rational](repeating: Rational.invalid, count: ContentView.variables.count)
        vector = [Rational](repeating: 1, count: 2)
        Logger.logout("", className: "Vector")
    }
    
    func addCount(backup: Vector) {
        Logger.login("", className: "Vector")
        vector.append(backup[count])
        Logger.logout("", className: "Vector")
    }
    
    func deleteCount(backup: Vector) {
        Logger.login("", className: "Vector")
        if count > 1 {
            let lastIndex = count - 1
            backup[lastIndex] = vector[lastIndex]
            vector.remove(at: lastIndex)
        }
        Logger.logout("", className: "Vector")

    }
    
    
    subscript(row: Int) -> Rational {
        get {
            return vector[row]
        }
        set {
            vector[row] = newValue
        }
    }
    
    func swapAt(_ i: Int, _ j: Int) {
        vector.swapAt(i, j)
    }
    
}

/// Vector must be Codable for save and load
extension Vector: Codable {
    enum CodingKeys: String, CodingKey {
        case vector
    }

    convenience init(from decoder: Decoder) throws {
        Logger.login("", className: "Vector")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let vector = try container.decode([Rational].self, forKey: .vector)
        self.init()
        self.vector = vector
        Logger.logout("", className: "Vector")
    }

    func encode(to encoder: Encoder) throws {
        Logger.login("", className: "Vector")
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vector, forKey: .vector)
        Logger.logout("", className: "Vector")
    }
}
