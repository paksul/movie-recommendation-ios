//
//  EditRatingsView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 29.03.21.
//

import SwiftUI

struct EditRatingsView: View {
    var recommendationViewModel: RecommendationViewModel
    
    var body: some View {
        List {
            ForEach(Array(recommendationViewModel.ratings.keys), id: \.self) { (element) in
                let movie = recommendationViewModel.getMovie(fromId: Int64(element)!)
                Text(movie?.name ?? "No name")
            }
        }
    }
}

struct EditRatingsView_Previews: PreviewProvider {
    static var previews: some View {
        EditRatingsView(recommendationViewModel: RecommendationViewModel())
    }
}
