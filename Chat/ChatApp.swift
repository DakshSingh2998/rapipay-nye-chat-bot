//
//  ChatApp.swift
//  Chat
//
//  Created by Daksh on 20/03/23.
//

import SwiftUI

@main
struct ChatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            /*
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
             */
            LoadingScreen()
        }
    }
}
