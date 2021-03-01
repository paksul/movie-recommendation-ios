//
//  RateView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.02.21.
//

import SwiftUI

struct StarsView: View {
    
    var recommendationViewModel: RecommendationViewModel
    @Binding var rating: Int?
    var max: Int = 5
    
    var body: some View {
            HStack {
                ForEach(1..<(max + 1), id: \.self) { index in
                    Image(systemName: self.starType(index: index))
                        .foregroundColor(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
                        .aspectRatio(contentMode: .fit)
                        .padding(7)
                        .onTapGesture {
                            self.rating = index
                            self.recommendationViewModel.rateCurrentMovie(rating: index)
                    }
                }
            }
        }

        private func starType(index: Int) -> String {
            
            if let rating = self.rating {
                return index <= rating ? "star.fill" : "star"
            } else {
                return "star"
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    struct RateView_Previews: PreviewProvider {
        static var previews: some View {
            StarsView(recommendationViewModel: RecommendationViewModel(), rating: Binding.constant(0), max: 5)
        }
    }
