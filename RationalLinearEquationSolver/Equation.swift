////
//  RationalLinearEquationSolver
//  Equation
//
//  Created by LegoEsprit on 21.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Cocoa
import UniformTypeIdentifiers

/// codable class to store and retrieve matrix and inhomogeneous part
class Equation: Codable {
    var name: String
    var inhomogeneous: Vector
    var matrix: Matrix

    enum CodingKeys: String, CodingKey {
        case name
        case inhomogeneous
        case matrix
    }
    
    
    init(matrix: Matrix
        , inhomogeneous: Vector
    )  {
        self.name = "Solver"
        self.inhomogeneous = inhomogeneous
        self.matrix = matrix
    }
    
    required init(from decoder: Decoder) throws {
        self.name = "Solver"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.inhomogeneous = try container.decode(Vector.self, forKey: .inhomogeneous)
        self.matrix = try container.decode(Matrix.self, forKey: .matrix)
    }

    
    /// store  matrix and inhomogeneous part
    /// - Parameters:
    ///   - A: square matrix
    ///   - b: inhomogeneous part
    static func save(A: Matrix, b: Vector) {
        Task {
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = "Untitled"
            savePanel.allowedContentTypes = [.json, .plainText]
            if await savePanel.begin() == .OK, let url = savePanel.url {
                do {
                    let document = Equation(matrix: A, inhomogeneous: b)
                    let data = try JSONEncoder().encode(document)
                    try data.write(to: url)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    /// retrieve matrix and inhomogeneous part
    /// - Returns: tuple with
    ///   - A: square matrix
    ///   - b: inhomogeneous part
    static func load() -> (Matrix, Vector) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.json, .plainText]
        if openPanel.runModal() == .OK, let url = openPanel.url {
            do {
                let data = try Data(contentsOf: url)
                let equation = try JSONDecoder().decode(Equation.self, from: data)
                return (equation.matrix, equation.inhomogeneous)
            } catch {
                print(error)//"Error during read")
            }
        }
        return (Matrix(count: 0), Vector())

    }
    
    

}
