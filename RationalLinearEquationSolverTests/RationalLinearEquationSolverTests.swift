////
//  RationalLinearEquationSolverTests
//  RationalLinearEquationSolverTests
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Testing
import Foundation

@testable import RationalLinearEquationSolver

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

}
