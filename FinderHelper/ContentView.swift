//
//  ContentView.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button {
            let home = URL(fileURLWithPath: "/Users/kyle")
    //        let home = URL(fileURLWithPath: NSHomeDirectory())
//            FIFinderSyncController.default().directoryURLs = [home]
    //        NSWorkspace.shared.open(home)
//            NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
            
            let path = #"/Applications/Visual Studio Code.app"#
            let app = URL(fileURLWithPath: path)
            
            let config = NSWorkspace.OpenConfiguration()
            config.promptsUserIfNeeded = true
            NSWorkspace.shared.open([home], withApplicationAt: app, configuration: config) { app, error in
            }
//            let path = NSString.path(withComponents: [NSHomeDirectory(), "a.txt"])
//            print(path)
//            let url1 = URL(string: path)!
//            let url2 = URL(fileURLWithPath: path)
//            print(url1)
//            print(url2)
//            NSWorkspace.shared.open(url2)
//            let url = URL(fileURLWithPath: "/Users/kyle")
//            let path = #"/Applications/Visual Studio Code.app"#
//            let app = URL(fileURLWithPath: path)
            
//            let config = NSWorkspace.OpenConfiguration()
//            NSWorkspace.shared.open([url], withApplicationAt: app, configuration: config) { _, _ in
//            }
            
            
        } label: {
            Text("Hello, world!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
