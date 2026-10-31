////
//  RationalLinearEquationSolver
//  Equation
//
//  Changed by LegoEsprit on 31.10.26 to make class Observable
//  Created by LegoEsprit on 21.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Cocoa
import UniformTypeIdentifiers

/// Observable and codable class to store and retrieve matrix and inhomogeneous part
@Observable
final class Equation: Codable {
    var name: String
    var inhomogeneous: Vector
    var matrix: Matrix
    
    // Explicitly setting the strings with "_" is required to make it observable
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _inhomogeneous = "inhomogeneous"
        case _matrix = "matrix"
    }

    
    init()  {
        self.name = "Solver"
        self.inhomogeneous = Vector(value: Rational(1), count: 2)
        self.matrix = Matrix(count: 2)
    }

    
    required init(from decoder: Decoder) throws {
        self.name = "Solver"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: ._name)
        self.inhomogeneous = try container.decode(Vector.self, forKey: ._inhomogeneous)
        self.matrix = try container.decode(Matrix.self, forKey: ._matrix)
    }
    
    /// Init with matrix and vector
    /// - Parameters:
    ///   - A: square matrix
    ///   - b: inhomogeneous part
    init(A: Matrix, b: Vector) {
        self.name = "Solver"
        self.matrix = A
        self.inhomogeneous = b
    }
    
    /// Init using file open dialog
    /// - Parameter title: Some text to be displayed
    convenience init(text message: String) {
        self.init()
        load(text: message)
    }
    
    func load(text message: String) {
        let openPanel = NSOpenPanel()
        openPanel.title = "<Title>"
        //openPanel.prompt = "<prompt>"
        openPanel.message = message
        //openPanel.nameFieldLabel = "<nameFieldLabel>"
        //openPanel.nameFieldStringValue = "<nameFieldStringLabel>"
        openPanel.showsTagField = true
        openPanel.allowedContentTypes = [.json, .plainText]
        if openPanel.runModal() == .OK, let url = openPanel.url {
            do {
                let data = try Data(contentsOf: url)
                let equation = try JSONDecoder().decode(Equation.self, from: data)
                matrix = equation.matrix
                inhomogeneous = equation.inhomogeneous
                printMatrix(title: "Load")
            } catch {
                print(error)//"Error during read")
            }
        }
    }

   
    
    /// store  matrix and inhomogeneous part
    /// - Parameters:
    func save(text message: String) {
        printMatrix(title: "Save")
        Task {
            let savePanel = NSSavePanel()
            savePanel.title = "<Title>"
            savePanel.prompt = "<prompt>"
            savePanel.message = message
            savePanel.nameFieldLabel = "<nameFieldLabel>"
            savePanel.showsTagField = true

            savePanel.nameFieldStringValue = "Untitled"
            savePanel.allowedContentTypes = [.json, .plainText]
            if await savePanel.begin() == .OK, let url = savePanel.url {
                do {
                    let data = try JSONEncoder().encode(self)
                    try data.write(to: url)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func printMatrix(title: String) {
        print(title)
        for v in 0..<matrix.count {
            let lastH = matrix.count-1
            for h in 0..<lastH {
                print("\(matrix[v, h])", terminator: "\t, ")
            }
            print("\(matrix[v, lastH])\t= \(inhomogeneous[v])")
        }
    }


}
