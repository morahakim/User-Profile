//
//  UserProfileApp.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import SwiftUI

@main
struct UserProfileApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(presenter: HomeDependency.shared.makeHomePresenter())
        }
    }
}
