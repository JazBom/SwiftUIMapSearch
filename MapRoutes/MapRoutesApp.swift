//
//  MapRoutesApp.swift
//  MapRoutes
//
//  Created by Jessica Bommer on 22/10/21.
//

import SwiftUI

@main
struct MapRoutesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
