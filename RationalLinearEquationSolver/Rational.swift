////
//  DynamicTextFields
//  Rationals
//
//  Created by LegoEsprit on 18.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import Foundation
import SwiftUI
import RegexBuilder

/// Struct for fractions as num, den, where num and den are Int
struct Rational: Equatable {
    var num: Int
    var den: Int
    var approx: Double {
        return Double(num) / Double(den)
    }
    /// One, zero and invalid elements as static
    static let one = Rational(1)
    static let zero = Rational(0)
    static let invalid = Rational(1, 0)
    
    /// Constructor
    /// - Parameters:
    ///   - num: Numerator
    ///   - den: Denominator
    ///   Creates an shortened rational with positive denominator
    init(_ num: Int, _ den: Int) {
        let g = Rational.gcd(num, den)
        let sign = (den < 0) ? -1 : 1
        self.num = sign * num / g
        self.den = sign * den / g
        if self.den < 0 {
            print("negative denominator not allowed")
        }
    }
    
    /// Constructor
    /// - Parameter num: Numerator
    /// Creates an integer rational
    init(_ num: Int) {
        self.num = num
        self.den = 1
    }
    
    /// Greatest common divisor
    /// - Parameters:
    ///   - a: Int A parameter
    ///   - b: Int B parameter
    /// - Returns: greatest common divisor using Euklid
    static func gcd(_ a: Int, _ b: Int) -> Int {
        var x = abs(a)
        var y = abs(b)
        while y != 0 {
            let t = x % y
            x = y
            y = t
        }
        return x == 0 ? 1 : x
    }

}

/// Prsenting the Rational as String
extension Rational: CustomStringConvertible {
    
    var description: String {
        guard den != 0 else { return "?" }
        return den == 1 ? "\(num)" : "\(num)/\(den)"
    }
    
    /// Format the Rational as StrIng
    /// - Parameter signed: Must be true to display "+" sign
    /// - Returns: String description of the Rational like +7/8
    func formatted(signed: Bool) -> String {
        guard den != 0 else { return "?" }
        if signed {
            let numerator = num >= 0 ? "+\(num)" : "-\(abs(num))"
            return den == 1 ? numerator : "\(numerator)/\(den)"
        }
        else {
            return den == 1 ? "\(num)" : "\(num)/\(den)"
        }
    }

}

// 1. Create the Custom FormatStyle
struct RationalFormatStyle: ParseableFormatStyle {
    typealias FormatInput = Rational
    typealias FormatOutput = String
    
    // Conformance to ParseableFormatStyle provides the parser for TextFields
    var parseStrategy = RationalParseStrategy()
    
    // Formats the Rational struct into a String (e.g., 3/4)
    func format(_ value: Rational) -> String {
        return value.formatted(signed: false)
    }
}

// 1. Create the Custom FormatStyle
struct SignedRationalFormatStyle: ParseableFormatStyle {
    typealias FormatInput = Rational
    typealias FormatOutput = String
    
    // Conformance to ParseableFormatStyle provides the parser for TextFields
    var parseStrategy = RationalParseStrategy()

    // Formats the Rational struct into a String (e.g., 3/4)
    func format(_ value: Rational) -> String {
        return value.formatted(signed: true)
    }
}


// 2. Create the Parse Strategy for Text Fields
struct RationalParseStrategy: ParseStrategy {
    typealias ParseInput = String
    typealias ParseOutput = Rational
    
    /// Parse using split (currently not used)
    /// - Parameter value: String to parse for a rational
    /// - Returns: Rational
    func parse2(_ value: String) -> Rational {
        let components = value.split(separator: "/")
        let num = Int(components[0].trimmingCharacters(in: .whitespaces)) ?? 0
        switch components.count {
            case 1:
                return Rational(num, 1)
            case 2:
                let den = Int(components[1].trimmingCharacters(in: .whitespaces)) ?? 1
                return Rational(num, den)
            default:
                return Rational(0, 1)
        }
    }
    
    /// Parse using Regexbuilder
    /// - Parameter value: String to parse for a rational
    /// - Returns: Rational
    func parse(_ value: String) -> Rational {
        let signRegex = ZeroOrMore(CharacterClass.anyOf("+-"))
        let signedIntRegex = Capture {
            signRegex
            OneOrMore(.digit)
        }
        let fractionRe = Regex {
            signedIntRegex
            Optionally {
                ChoiceOf {
                    ":"
                    "/"
                }
                signedIntRegex
            }
        }
        if let match = value.prefixMatch(of: fractionRe) {
            let (_, numStr, denStr) = match.output
            let num = Int(numStr) ?? 0
            let den = Int(denStr ?? "1") ?? 1
            return Rational(num, den)
        }
        else {
            return Rational(0, 1)
        }
    }
}

// 3. Extend FormatStyle for clean dot-syntax usage
extension FormatStyle where Self == RationalFormatStyle {
    static var rational: RationalFormatStyle {
        RationalFormatStyle()
    }
    static var signedRational: SignedRationalFormatStyle {
        SignedRationalFormatStyle()
    }
}

/// Algebraic rules for Rational
extension Rational {
    static func +(lhs: Rational, rhs: Rational) -> Rational {
        let n = lhs.num * rhs.den + rhs.num * lhs.den
        let d = lhs.den * rhs.den
        return Rational(n, d)
    }

    static prefix func +(x: Rational) -> Rational {
        return x
    }

    static func -(lhs: Rational, rhs: Rational) -> Rational {
        let n = lhs.num * rhs.den - rhs.num * lhs.den
        let d = lhs.den * rhs.den
        return Rational(n, d)
    }

    static prefix func -(x: Rational) -> Rational {
        return Rational(-x.num, x.den)
    }

    static func *(lhs: Rational, rhs: Rational) -> Rational {
        let n = lhs.num * rhs.num
        let d = lhs.den * rhs.den
        return Rational(n, d)
    }

    static func *(lhs: Int, rhs: Rational) -> Rational {
        return Rational(lhs * rhs.num, rhs.den)
    }

    static func *(lhs: Rational, rhs: Int) -> Rational {
        return Rational(lhs.num * rhs, lhs.den)
    }

    static func /(lhs: Rational, rhs: Rational) -> Rational {
        precondition(rhs.num != 0, "Division by zero rational")
        let n = lhs.num * rhs.den
        let d = lhs.den * rhs.num
        return Rational(n, d)
    }

}

/// Swiftui extensions to set and get the bound value
extension Rational {

    static func binding(
        get: @escaping () -> Rational,
        set: @escaping (Rational) -> Void
    ) -> Binding<Rational> {
        Binding(
            get: get,
            set: set
        )
    }
    
}

/// Rational must be Codable for save and load (Methods are added automatically)
extension Rational: Codable {

}



