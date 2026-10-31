////
//  RationalLinearEquationSolver
//  RationalLinearEquationSolverApp
//
//  Created by LegoEsprit on 20.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI

struct EmptyCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            EmptyView()
        }
        CommandGroup(replacing: .saveItem) {
            EmptyView()
        }
        CommandGroup(replacing: .printItem) {
            EmptyView()
        }
        CommandGroup(replacing: .undoRedo) {
            EmptyView()
        }
        CommandGroup(replacing: .pasteboard) {
            EmptyView()
        }
    }
}

/// Application menu entries for "About', 'Load' and 'save'
/// I had hard times to make Equation bindable and to avoid having multiple instances at the
/// same time making save and load from main menu not working properly.
@main
struct RationalLinearEquationSolverApp: App {
    

    var contentView: ContentView
    @State private var equation = Equation()
    
    init() {
        /*
        let uniqueState = WindowState()
        contentView = ContentView(model: uniqueState)
         */
        contentView = ContentView()
    }
    
    var body: some Scene {
        WindowGroup {
            contentView
        }
        /*
        //.commandsRemoved() // remove standard menu items!
        .commands {
            //MacMenuCommands(using: contentView)
        }
        
        // 2. Build your custom-sized window
        Window("About \(Bundle.main.appName)", id: "about-panel") {
            let credits = """
                     This app allows you to solve a set of linear
                     equations with given factional coefficients
                     precisely as long as numerator and
                     denominator stay within the Int range.
                     Id: \(Bundle.main.bundleId)
                     
                     Version \(Bundle.main.version) (Build \(Bundle.main.build))
                     \(Bundle.main.copyright)
                     """
            VStack(spacing: 12) {
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("\(Bundle.main.appName)").font(.headline)
                Text(credits).font(.subheadline)
            }
            .padding()
            .frame(minWidth: 450, minHeight: 300) // 👈 Set your custom width here
        }
        .windowResizability(.contentSize)
        .defaultLaunchBehavior(.suppressed)
         */

        
    }
}
