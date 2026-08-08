////
//  RationalLinearEquationSolver
//  ContentView
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import UniformTypeIdentifiers




/// View for the main window
struct ContentView: View {
    
    /// Creates the alphabetic lowercase letters from "a"..."z"
     
    static var variables: [String] {
        (10...35).map { String($0, radix: 36) }
    }
    /*
    /// Max 10 variables for the equation
    static let variables = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
     */
    
    /// Quadratic coefficient max for the homogenous equation
    @State var matrix = Matrix(count: 2)
    
    /// Vector of the inhomogeneous solution
    @State var inhomogeneous = Vector(value: Rational(1), count: 2)
    
    /// Two backup storages to remember settings
    @State private var matrixBackup = Matrix(count: variables.count)
    @State private var inhomogeneousBackup = Vector(value: Rational(1), count: variables.count)
    
    /// Used to show error alert
    @State private var showAlert = false
    
    /// Called from outside
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

    
    /// Main view body
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack {
                VStack {
                    Form{
                        /// Plot the equation
                        ForEach(0..<matrix.count, id: \.self) { row in
                            
                            HStack {
                                /// Plot the equation matrix 1st column without "+" sign
                                MatrixElement(value: matrix.binding(row: row, column: 0), variable: ContentView.variables[0], format: .rational
                                )
                                .frame(width: 120)
                                /// Plot the equation matrix remaining columns with sign
                                ForEach(1..<matrix.count, id: \.self) { column in
                                    MatrixElement(value: matrix.binding(row: row, column: column), variable: ContentView.variables[column], format: .signedRational
                                    )
                                    .frame(width: 120)
                                }
                                /// Plot the last column with the inhomogeneous values
                                Text(" = ")
                                TextField("", value: inhomogeneous.binding(at: row), format: .rational)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width:80)
                            }
                        }
                    }
                    /// Plot the solution using Cramers method
                    if matrix.count < Matrix.MaxCramer {
                        Text("===== Cramer \(matrix.elapsedCramer) s =======")
                        let solution = matrix.solveCramer(inhomogeneous)
                        ForEach(0..<matrix.count, id: \.self) { row in
                            Text("\(ContentView.variables[row]) \t= \t\(solution[row].description)")
                        }
                    }
                    /// Plot the solution using Gauss elimination method
                    Text("===== Gauss \(matrix.elapsedGauss) s =======")
                    let solution = matrix.solveGaussianExact(inhomogeneous)
                    ForEach(0..<matrix.count, id: \.self) { row in
                        Text("\(ContentView.variables[row]) \t= \t\(solution[row].description)")
                    }
                    
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            /// Add 4 buttons for add, delete, load and save
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
        .defaultScrollAnchor(.top)
    }
}

#Preview {
    ContentView()
}
