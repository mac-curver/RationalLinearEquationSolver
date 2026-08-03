////
//  RationalLinearEquationSolverTests
//  RationalLinearEquationSolverTests
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Testing
@testable import RationalLinearEquationSolver

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
