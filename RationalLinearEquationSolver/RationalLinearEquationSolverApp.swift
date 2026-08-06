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
@main
struct RationalLinearEquationSolverApp: App {
    @Environment(\.openWindow) private var openWindow
    
    var contentView = ContentView()
    

    var body: some Scene {
        WindowGroup {
            contentView
        }
        .commandsRemoved() // remove standard menu items!
        .commands {
            CommandGroup(after: .newItem) {
                Button("Load...", systemImage: "arrow.up.forward.square") {
                    contentView.load()
                }
                .keyboardShortcut("O")
                
                Button("Save...", systemImage: "square.and.arrow.down") {
                    Equation.save(A: contentView.matrix, b:contentView.inhomogeneous)
                }
                .keyboardShortcut("S")
            }
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    // Open the "about" window
                    openWindow(id: "about")
                }, label: {
                    Text("About \(BundleInfo.appName)…")
                })
            }
            
        }
        
        //// Note the id "about" here
        WindowGroup("About \(BundleInfo.appName)…", id: "about") {
            AboutView()
        }
        .defaultSize(width: 350, height: 200)
        
    }
}
