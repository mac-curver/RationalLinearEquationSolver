////
//  RationalLinearEquationSolver
//  MacMenuCommands
//
//  Created by LegoEsprit on 30.10.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI

struct MacMenuCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    @FocusedObject private var equation: Equation?

    var body: some Commands {
        
        CommandGroup(after: .newItem) {
            Button("Load...", systemImage: "arrow.up.forward.square") {
                equation?.load(text: ContentView.loadMessage)
            }
            .keyboardShortcut("O")
            .disabled(equation == nil)
            
            Button("Save...", systemImage: "square.and.arrow.down") {
                equation?.save(text: ContentView.saveMessage)
            }
            .keyboardShortcut("S")
            .disabled(equation == nil)
            .disabled(equation == nil)
            .disabled(equation == nil)
        }
         
        CommandGroup(replacing: .appInfo) {
            Button("About \(Bundle.main.appName)...") {
                openWindow(id: "about-panel")
            }
        }

        //CommandMenu("Actions") {
        //    Button("Run", systemImage: "play.fill") {
        //        print("run")
        //    }
        //    .keyboardShortcut("R")
        //
        //
        //    Button("Stop", systemImage: "stop.fill") {
        //        print("stop")
        //    }
        //    .keyboardShortcut(".")
        //}

    }
}


