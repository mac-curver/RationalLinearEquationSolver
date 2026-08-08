## Rational Linear Equation Solver

This SwiftUI application solves a set of up to ten linear equations using either Cramer’s rule or Gaussian elimination. Coefficients can be entered as rational numbers with integer numerator and denominator.

### Description

Based on an Algol 68 exercise, the application was rewritten to compile using SwiftUI. As a beginner in SwiftUI, this was an excellent exercise to learn about various Swift and SwiftUI features. A key feature of the application is its use of integer fractional coefficients instead of real values. This is implemented using a class `Rational` with integer numerator and denominator. The original Algol 68 code used an arbitrary-length integer library which allowed for numerical precise calculations. For simplicity and to avoid displaying large integers in the text fields for coefficients, in this version 64-bit integers are used which still offers a high accuracy.

The conversion from Algol 68 to Swift was completed using Copilot. Copilot corrected some bugs in the original code but had difficulties recognizing the apostrophe-style used in my Algol 68 source to indicate the alternative bold character set used for the A68 keywords. Difficulties in the SwiftUI implementation were ultimately resolved using Xcode’s built-in Codex KI.

### Getting Started

#### Dependencies

* Mac OS Tahoe

#### Executing the Program

* Double-click the fractions icon. A 2 by 2 equation system will be displayed with the right-hand side set to 1. Enter any new value into the existing text fields to change any coefficient. The calculated new solution is displayed instantly.

Cramer’s rule is significantly slower than the Gaussian elimination method and is therefore not used for larger systems.

The coefficients are integer fractions such as 7/8 and can also be entered as 7:8. The coefficient matrix can be extended to a maximum of 10 x 10 by pressing the <Add row/column> button and reduced by pressing the <Delete row/column> button. An equation can be saved to disk using the <Save…> button or the file menu and retrieved using the <Load…> button or the appropriate menu item. The file is stored in JSON format and can be edited using any text editor.

## Help

If the solution only shows question marks, the equation is not solvable. This occurs for example when two or more equations are linearly dependent, which means that the determinant of the matrix is zero.

## Authors

Contributors names and contact information

LegoEsprit@kabelbw.de

## Version History

* 1.03
    * First published version

## Original version

https://github.com/mac-curver/RationalLinearEquationSolver?tab=readme-ov-file

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgements

* -
