//
//  MainView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 15.02.21.
//

import SwiftUI

struct MainView: View {
    var recommendationViewModel: RecommendationViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(
                    destination: RatingView(recommendationViewModel: recommendationViewModel, rating: 0, maxRating: 5).scaledToFit(),
                    label: {
                        Text("Rate movies")
                            .fontWeight(.semibold)
                            .font(.title)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
                    .cornerRadius(40)
                
                
                NavigationLink(
                    destination: RecommendationView(recommendationViewModel: recommendationViewModel, recommendedMovies: [Movie]()).scaledToFit(),
                    label: {
                        Text("Recommend me movie")
                            .fontWeight(.semibold)
                            .font(.title)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
                    .cornerRadius(40)
                
                NavigationLink(
                    destination: EditRatingsView(recommendationViewModel: recommendationViewModel).scaledToFit(),
                    label: {
                        Text("Edit ratings")
                            .fontWeight(.semibold)
                            .font(.title)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
                    .cornerRadius(40)
            }
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(recommendationViewModel: RecommendationViewModel())
    }
}
