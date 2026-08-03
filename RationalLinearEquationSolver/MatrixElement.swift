////
//  RationalLinearEquationSolver
//  TextView
//
//  Created by LegoEsprit on 31.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI

struct MatrixElement<Format: ParseableFormatStyle>: View where Format.FormatInput == Rational, Format.FormatOutput == String {
    let matrix: Binding<Rational>
    let text: String
    let format: Format
    init(
          value matrix: Binding<Rational>
        , variable text: String
        , format: Format
    ) {
        //self.row = row
        //self.column = column
        self.matrix = matrix
        self.text = text
        self.format = format
    }
    
    
    var body: some View {
        HStack {
            TextField("", value: matrix, format: format)
                .multilineTextAlignment(.trailing)
                .frame(width:80)
            Text(text);
        }
    }
}

#Preview {
    MatrixElement(value: .constant(Rational(1, 1)), variable: "w", format: .signedRational)
        .frame(width: 200)
}
