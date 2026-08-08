////
//  DynamicTextFields
//  Matrix
//
//  Created by LegoEsprit on 19.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI

@Observable final class Matrix {
    var count: Int {
        matrix.count
    }
    
    var matrix: [[Rational]] = []
    var elapsedCramer: Double = 0.0
    var elapsedGauss: Double = 0.0

    init(count: Int) {
        matrix = (0..<count).map { i in
            (0..<count).map { j in
                i == j ? Rational.one : Rational.zero
                //Rational(10*j+i+1)
            }
        }
    }
    
    private init(matrix newMatrix: Matrix) {
        matrix = newMatrix.matrix
    }
    
    private init(twoDim newMatrix: [[Rational]]) {
        matrix = newMatrix
    }

    func addCount(backup: Matrix) {
        for row in 0..<matrix.count {
            matrix[row].append(backup[row, count] )
        }
        let row = self.count
        matrix.append(Array(backup.matrix[row][0...row]))
    }
    
    func deleteCount(backup: Matrix) {
        if count > 1 {
            let lastRowIndex = count-1
            for row in 0...lastRowIndex {
                backup[row, lastRowIndex] = self[row, lastRowIndex]
                matrix[row].remove(at: lastRowIndex)
            }
            for column in 0..<lastRowIndex {
                backup[lastRowIndex, column] = self[lastRowIndex, column]
            }
 
            matrix.remove(at: lastRowIndex)
        }
        //print(matrix)
    }

    subscript(row: Int, column: Int) -> Rational {
        get {
            return matrix[row][column]
        }
        set {
            matrix[row][column] = newValue
        }
    }

    func binding(row: Int, column: Int) -> Binding<Rational> {
        Rational.binding(
            get: {
                if row < self.count && column < self.count {
                    return self[row, column]
                } else {
                    return Rational.invalid
                }
            },
            set: {
                if row < self.count && column < self.count {
                    self[row, column] = $0
                }
            }
        )
    }
    
    private static func minor(of A: Matrix, removingRow r: Int, removingCol c: Int) -> Matrix {
        var m: [[Rational]] = []
        for i in 0..<A.count {
            if i == r { continue }
            var row: [Rational] = []
            for j in 0..<A.count {
                if j == c { continue }
                row.append(A[i, j])
            }
            m.append(row)
        }
        return Matrix(twoDim: m)
    }

    private static func determinant(_ A: Matrix) -> Rational {
        let n = A.count

        if n == 1 {
            return A[0, 0]
        }

        var result = Rational(0, 1)
        for j in 0..<n {
            let sign = j % 2 == 0 ? 1 : -1
            let cofactor = sign * A[0, j] * determinant(minor(of: A, removingRow: 0, removingCol: j))
            result = result + cofactor
        }
        return result
    }

    var det: Rational {
        Matrix.determinant(self)
    }
}

/// MARK: - Cramer's rule solver
extension Matrix {
    static var MaxCramer = 7
    
    /// Build matrix for Cramers solution
    /// - Parameters:
    ///   - A: Original matrix
    ///   - column: Replacement column
    ///   - index: column index
    /// - Returns: Matrix where the column at index is replaced by vector
    func insertColumn(_ A: Matrix, column: Vector, at index: Int) -> Matrix {
        let B = Matrix(matrix: A) // must be a deep copy!
        for i in 0..<A.count {
            B[i, index] = column[i]
        }
        return B
    }
    
    /// Solve linear equation system using Cramers solution
    /// - Parameter b: Inhomogeneous vector
    /// - Returns: Solution of the linear equation system as vector
    func solveCramer(_ b: Vector) -> Vector {
        let startTime = Date().timeIntervalSince1970
        let n = count
        guard matrix.allSatisfy({ $0.count == n }), b.count == n else {
            return Vector()
        }
        
        let detA = det
        if detA.num == 0 {
            return Vector() // singular system
        }
        let x = Vector(value: Rational(0), count:n)
        for i in 0..<n {
            let Ai = insertColumn(self, column: b, at: i)
            let detAi = Ai.det
            x[i] = detAi / detA
        }
        elapsedCramer=Date().timeIntervalSince1970-startTime
        return x
    }
    
}

/// MARK: - Gauss solver
extension Matrix {
    
    /// Swap two matrix elements
    /// - Parameters:
    ///   - i: First index fow the swap
    ///   - j: Second index
    func swapAt(_ i: Int, _ j: Int) {
        matrix.swapAt(i, j)
    }
    
    /// Gauss elimination to solve a linear equation system
    /// - Parameter b: Inhomogeneous vector
    /// - Returns: Solution of the linear equation system as vector
    func solveGaussianExact(_ b: Vector) -> Vector {
        let startTime = Date().timeIntervalSince1970
        let n = count
        guard matrix.allSatisfy({ $0.count == n }), b.count == n else {
            return Vector()
        }

        let M = Matrix(matrix: self) // must be a deep copy?

        let rhs = Vector(vector: b)

        // Forward elimination
        for k in 0..<n {
            // Find pivot row with non-zero entry in column k
            var pivot = k
            while pivot < n && M[pivot, k].num == 0 {
                pivot += 1
            }
            if pivot == n {
                return Vector() // singular system
            }
            if pivot != k {
                M.swapAt(k, pivot)
                rhs.swapAt(k, pivot)
            }

            let pivotVal = M[k, k]

            // Eliminate below
            for i in (k+1)..<n {
                let factor = M[i, k] / pivotVal
                for j in k..<n {
                    M[i, j] = M[i, j] - factor * M[k, j]
                }
                rhs[i] = rhs[i] - factor * rhs[k]
            }
        }

        // Back substitution
        let x = Vector(value: Rational(0), count:n)

        for i in stride(from: n - 1, through: 0, by: -1) {
            var sum = rhs[i]
            for j in (i+1)..<n {
                sum = sum - M[i, j] * x[j]
            }
            x[i] = sum / M[i, i]
        }
        elapsedGauss=Date().timeIntervalSince1970-startTime

        return x
    }

}

/// Extension to make Matrix codable
extension Matrix: Codable {
    enum CodingKeys: String, CodingKey {
        case matrix
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let matrix = try container.decode([[Rational]].self, forKey: .matrix)
        self.init(count: matrix.count)
        self.matrix = matrix
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(matrix, forKey: .matrix)
    }

}
