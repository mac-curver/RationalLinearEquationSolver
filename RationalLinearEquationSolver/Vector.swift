////
//  DynamicTextFields
//  Vector
//
//  Created by LegoEsprit on 19.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI

@Observable final class Vector {
    var count: Int {
        vector.count
    }
    var vector: [Rational]
    
    init(value: Rational, count: Int) {
        vector = (0..<count).map { _ in
            value
        }
    }
    
    init(vector newVector: Vector) {
        vector = newVector.vector
    }
    
    init() {
        // Invalid entry
        vector = [Rational](repeating: Rational.invalid, count: ContentView.variables.count)
    }
    
    func addCount(backup: Vector) {
        vector.append(backup[count])
    }
    
    func deleteCount(backup: Vector) {
        if count > 1 {
            let lastIndex = count - 1
            backup[lastIndex] = vector[lastIndex]
            vector.remove(at: lastIndex)
        }
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
    
    
    func binding(at index: Int) -> Binding<Rational> {
        Rational.binding(
            get: {
                if index < self.count {
                    self.vector[index]
                } else {
                    Rational.invalid
                }
            },
            set: {
                if index < self.count {
                    self.vector[index] = $0
                }
            }
        )
    }
}

extension Vector: Codable {
    enum CodingKeys: String, CodingKey {
        case vector
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let vector = try container.decode([Rational].self, forKey: .vector)
        self.init()
        self.vector = vector
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vector, forKey: .vector)
    }
}
