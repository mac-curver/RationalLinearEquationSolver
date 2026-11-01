////
//  RationalLinearEquationSolver
//  TextView
//
//  Created by LegoEsprit on 31.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import os.log


/// Matrix cell to display Rational followed by variable
struct MatrixElement<Format: ParseableFormatStyle>: View
       where Format.FormatInput == Rational
     , Format.FormatOutput == String
{
    let matrix: Binding<Rational>
    let text: String
    let format: Format
    init(
          value matrix: Binding<Rational>
        , variable text: String
        , format: Format
    ) {
        Logger.login("", className: "MatrixElement")
        self.matrix = matrix
        self.text = text
        self.format = format
        Logger.logout("", className: "MatrixElement")
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
