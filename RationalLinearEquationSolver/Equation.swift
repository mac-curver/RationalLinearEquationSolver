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
import Combine
import os.log

/// Observable and codable class to store and retrieve matrix and inhomogeneous part
//@Observable
final class Equation: Codable, ObservableObject {
    
    var name: String
    var inhomogeneous: Vector
    var matrix: Matrix
    
    //let objectWillChange: ObservableObjectPublisher

    // Explicitly setting the strings with "_" is required to make the class observable
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case inhomogeneous = "inhomogeneous"
        case matrix = "matrix"
    }

    
    init()  {
        Logger.login("", className: "Equation")
        self.name = "Solver"
        self.inhomogeneous = Vector(value: Rational(1), count: 2)
        self.matrix = Matrix(count: 2)
        Logger.logout("", className: "Equation")
    }

    
    required init(from decoder: Decoder) throws {
        Logger.login("", className: "Equation")
        self.name = "Solver"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey:          .name)
        self.inhomogeneous = try container.decode(Vector.self, forKey: .inhomogeneous)
        self.matrix = try container.decode(Matrix.self, forKey:        .matrix)
        Logger.logout("", className: "Equation")
   }
    
    /// Init with matrix and vector
    /// - Parameters:
    ///   - A: square matrix
    ///   - b: inhomogeneous part
    init(A: Matrix, b: Vector) {
        Logger.login("", className: "Equation")
        self.name = "Solver"
        self.matrix = A
        self.inhomogeneous = b
        Logger.logout("", className: "Equation")
   }
    
    /// Init using file open dialog
    /// - Parameter title: Some text to be displayed
    convenience init(text message: String) {
        Logger.login("", className: "Equation")
        self.init()
        load(text: message)
        Logger.logout("", className: "Equation")
    }
    
    /// Add 1 dim to the equation
    /// - Parameter contentView: Used for backup
    /// We need to actively send a notification to update the view
    func addCount(contentView: ContentView) {
        matrix.addCount(backup: contentView.matrixBackup)
        inhomogeneous.addCount(backup: contentView.inhomogeneousBackup)
        objectWillChange.send()
        printMatrix(title: "addCount")
    }
    
    /// Delete 1 dim from the equation
    /// - Parameter contentView: Used for backup
    /// We need to actively send a notification to update the view
    func deleteCount(contentView: ContentView) {
        matrix.deleteCount(backup: contentView.matrixBackup)
        inhomogeneous.deleteCount(backup: contentView.inhomogeneousBackup)
        objectWillChange.send()
        printMatrix(title: "deleteCount")
    }
    
    /// Loads equation from disk as JSON
    /// - Parameter message: Open panel message
    func load(text message: String) {
        Logger.login("", className: "Equation")
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
                objectWillChange.send()
                printMatrix(title: "Load")
            } catch {
                print("\(error) Error during load")
            }
        }
        Logger.logout("", className: "Equation")
    }

   
    
    /// store  matrix and inhomogeneous part
    /// - Parameters:
    func save(text message: String) {
        Logger.login("", className: "Equation")
        printMatrix(title: "Save")
        Task {
            let savePanel = NSSavePanel()
            savePanel.title = "Save as JSON"
            //savePanel.prompt = "<prompt>"
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
                    print("\(error) during save")
                }
            }
        }
        Logger.logout("", className: "Equation")
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
