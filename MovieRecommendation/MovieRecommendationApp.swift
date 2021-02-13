//
//  MovieRecommendationApp.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import SwiftUI

@main
struct MovieRecommendationApp: App {
    var body: some Scene {
        WindowGroup {
            MovieRecommendationView(viewModel: Movies())
        }
    }
}
