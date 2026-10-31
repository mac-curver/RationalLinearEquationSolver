////
//  RationalLinearEquationSolver
//  MacMenuCommands
//
//  Created by LegoEsprit on 30.10.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import Observation



struct MacMenuCommands: Commands {
    
    @Environment(\.openWindow) private var openWindow

    var contentView:ContentView
    //@Bindable var equation:Equation
    
    init(using contentView: ContentView) {
        self.contentView = contentView
        //self.equation = contentView.equation
    }

    var body: some Commands {
        /*
        CommandGroup(after: .newItem) {
            Button("Load...", systemImage: "arrow.up.forward.square") {
                contentView.equation.load(text: ContentView.loadMessage)
                contentView.showAlert = contentView.equation.matrix.count < 1
            }
            .keyboardShortcut("O")
            
            Button("Save...", systemImage: "square.and.arrow.down") {
                contentView.showAlert = true
                contentView.equation.save(text: ContentView.saveMessage)
            }
            .keyboardShortcut("S")
        }
         */
        CommandGroup(replacing: .appInfo) {
            Button("About \(Bundle.main.appName)...") {
                openWindow(id: "about-panel")
            }
        }

        
        /*
        CommandMenu("Actions") {
            Button("Run", systemImage: "play.fill") {
                print("run")
            }
            .keyboardShortcut("R")
            
            
            Button("Stop", systemImage: "stop.fill") {
                print("stop")
            }
            .keyboardShortcut(".")
        }
         */

    }
}

