////
//  RationalLinearEquationSolver
//  AboutView
//
//  Created by LegoEsprit on 25.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import AppKit

class BundleInfo {
    static var appName: String {
        infoDir?["CFBundleExecutable"] as? String ?? "..."
    }
    
    static var bundleId: String {
        infoDir?["CFBundleIdentifier"] as? String ?? "..."
    }
    
    static var bundleVersion: String {
        infoDir?["CFBundleVersion"] as? String ?? "..."
    }

    static var infoDir: [String : Any]? {
        let a = Bundle.main.infoDictionary
        return a
    }

}

struct AboutView: View {
    @State private var isShowingDialog = false
    var body: some View {
        VStack {
            HStack {
                Image(nsImage: NSImage(named: "Flask") ?? NSImage())
                    .resizable()
                    .frame(width: 32, height: 32)
                Image(nsImage: NSImage(named: NSImage.applicationIconName) ?? NSImage())
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(BundleInfo.appName)
            }
            Text(BundleInfo.bundleId).frame(width: 280)
            Text(BundleInfo.bundleVersion)
        }
        .frame(width: 350, height: 120)
    }
}

#Preview {
    AboutView()
}
