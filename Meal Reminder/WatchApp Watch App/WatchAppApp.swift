//
//  WatchAppApp.swift
//  WatchApp Watch App
//
//   Created by Mashael Alharbi on 18/06/1444 AH.
//

import SwiftUI

@main
struct WatchApp_Watch_AppApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
