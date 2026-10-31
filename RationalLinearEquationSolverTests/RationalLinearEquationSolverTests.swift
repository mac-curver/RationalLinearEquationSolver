////
//  RationalLinearEquationSolverTests
//  RationalLinearEquationSolverTests
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Testing
import Foundation

//@testable import RationalLinearEquationSolver

/// Test routine to store files
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

struct RationalLinearEquationSolverTests {
    
    @Test func save() async throws {
        let eq = Equation()
        eq.matrix = Matrix(count: 2)
        eq.inhomogeneous = Vector(value: 1, count: 2)
        for v in 0...1 {
            for h in 0...1 {
                eq.matrix[h, v] = Rational(v*10+h)
            }
        }
        //eq.save(A: <#T##Matrix#>, b: <#T##Vector#>)
    }


    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
        var letters: [String] {
            (10...35).map { String($0, radix: 36) }
        }
        for i in [0...25] {
            print(letters[i])
        }
    }
    

    @Test func comparisons() async throws {
        #expect(Rational(1, 3) < 1)
        #expect(Rational(4, 3) > 1)
        #expect(Rational(1, 3) < 1.0)
        #expect(Rational(4, 3) > 1.0)
        #expect(Rational(3, 3) >= 1)
        #expect(Rational(1, 3) < 0.3333333333334)
        #expect(Rational(1, 3) > 0.3333333333333)
        let t = Rational(1000000000000000+1, 1000000000000000)
        let u = Rational(1000000000000000, 1000000000000000+1)
        #expect(t > u)
        #expect(!(u > t))
        for i in 1...15 {
            let d = pow(10.0, Double(i))
            let a = Int(d) // (d as NSDecimalNumber).doubleValue)
            print("\(i) \(a)")
            #expect(Rational(a+1, a) > Rational(a, a+1))
        }
        #expect(true)
    }


}
