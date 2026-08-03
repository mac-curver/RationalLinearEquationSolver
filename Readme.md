# Rational linear equation solver

This small app written in Swiftui solves a set of up to 10 linear equations using Cramers rule or Gaussian elimination. As coefficients any rationals with integer numerator and denominator can be entered. 

## Description

Based on an exercise written in Algol 68 I rewrote the program to compile using SwiftUI. I am new to SwiftUI and its a good method to learn about plenty of Swift and SwiftUI features.  

## Getting Started

### Dependencies

* Mac OS Tahoe

### Executing program

* Double click onto the fractions icon. A 2 by 2 equation system will be shown with the right side set to 1. Enter any new value into the existing text fields to change a coefficient. The calculated new solution is displayed instantly. Be aware, that Cramers rule executes much slower than the Gauss elimination method. Therefore Cramers solution is not being used for larger systems.


## Help

In case the solution only shows question marks, the equation is not solvable. This is the case, when 2 or more equations are linearly dependent. That also means that the determinant of the matrix is 0. 


## Authors

Contributors names and contact info

LegoEsprit LegoEsprit@kabelbw.de


## Version History

* 1.2
    * First published version

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [GIT](https://github.com/)
