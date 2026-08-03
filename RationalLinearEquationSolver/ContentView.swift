////
//  RationalLinearEquationSolver
//  ContentView
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import UniformTypeIdentifiers

func makeFilesThatUserCanAccessOutsideThisApp() {
    guard let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError()
    }
    let contents = "Some text..."
    let mySOFileNameA = "MySOFileA.txt"
    let mySOFileNameB = "MySOFileB.txt"
    let mySOFolderUrl = docFolder.appendingPathComponent("MySOFolder")

    do {
        // write one file at the top level:
        try contents.write(to: docFolder.appendingPathComponent(mySOFileNameA), atomically: true, encoding: .utf8)
        // write two files into the subdirectory (after first creating the subdirectory if necessary):
        try FileManager.default.createDirectory(at: mySOFolderUrl, withIntermediateDirectories: true, attributes: nil)
        try contents.write(to: mySOFolderUrl.appendingPathComponent(mySOFileNameA), atomically: true, encoding: .utf8)
        try contents.write(to: mySOFolderUrl.appendingPathComponent(mySOFileNameB), atomically: true, encoding: .utf8)
    }
    catch {
        fatalError(error.localizedDescription)
    }
}


struct ContentView: View {
    /// Creates the alphabetic lowercase letters from "a"..."z"
    var letters: [String] {
        (10...35).map { String($0, radix: 36) }
    }
    static let variables = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]

    @State var matrix = Matrix(count: 2)
    @State var inhomogeneous = Vector(value: Rational(1), count: 2)
    
    @State private var inhomogeneousBackup = Vector(value: Rational(1), count: variables.count)
    @State private var matrixBackup = Matrix(count: variables.count)
    @State private var showAlert = false
    
    func load() {
        var newMatrix = Matrix(count: 0)
        var newVector = Vector()
        (newMatrix, newVector) = Equation.load()
        if newMatrix.count > 0 {
            matrix = newMatrix
            inhomogeneous = newVector
        }
        else {
            showAlert = true
        }
    }
    

    var body: some View {
        VStack {
            VStack {
                Form{
                    ForEach(0..<matrix.count, id: \.self) { row in
                        
                        HStack {
                            MatrixElement(value: matrix.binding(row: row, column: 0), variable: ContentView.variables[0], format: .rational
                            )
                            ForEach(1..<matrix.count, id: \.self) { column in
                                MatrixElement(value: matrix.binding(row: row, column: column), variable: ContentView.variables[column], format: .signedRational
                                )
                            }
                            Text(" = ")
                            TextField("", value: inhomogeneous.binding(at: row), format: .rational)
                                .multilineTextAlignment(.trailing)
                                .frame(width:80)
                        }
                    }
                }
                if matrix.count < Matrix.MaxCramer {
                    Text("===== Cramer \(matrix.elapsedCramer) s =======")
                    ForEach(0..<matrix.count, id: \.self) { row in
                        let solution = matrix.solveCramer(inhomogeneous)
                        Text("\(ContentView.variables[row]) \t= \t\(solution[row].description)")
                    }
                }
                
                Text("===== Gauss \(matrix.elapsedGauss) s =======")
                ForEach(0..<matrix.count, id: \.self) { row in
                    let solution = matrix.solveGaussianExact(inhomogeneous)
                    Text("\(ContentView.variables[row]) \t= \t\(solution[row].description)")
                }
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem() {
                Button(action:{
                    matrix.addCount(backup: matrixBackup)
                    inhomogeneous.addCount(backup: inhomogeneousBackup)
                }) {
                    Text("Add row/column")
                }
                .disabled(matrix.count>=ContentView.variables.count)
            }
            ToolbarItem() {
                Button(action:{
                    matrix.deleteCount(backup: matrixBackup)
                    inhomogeneous.deleteCount(backup: inhomogeneousBackup)
                }) {
                    Text("Delete row/column")
                }
                .disabled(matrix.count<=1)
            }
            ToolbarItem() {
                Button(action:{
                    load() 
                }) {
                    Text("Load...")
                }
                .frame(width: 120)
            }
            ToolbarItem() {
                Button(action:{
                    Equation.save(A: matrix, b:inhomogeneous)

                }) {
                    Text("Save...")
                }
                .frame(width: 120)
            }

        }
        .alert("File reading error", isPresented: $showAlert) {
            
        } message: {
            Text("Could not read the file")
        }
        
    }
}

#Preview {
    ContentView()
}
