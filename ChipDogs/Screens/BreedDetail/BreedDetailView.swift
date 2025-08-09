//
//  BreedDetailView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Combine

struct BreedDetailView: View {
    
    @ObservedObject var viewModel: BreedDetailViewModel
    
    init(breed: SelectedBreed) {
        viewModel = BreedDetailViewModel(breed: breed, api: DogAPI())
    }
    
    let compactLayout = [
        GridItem(),
    ]
    
    let regularLayout =  [
        GridItem(.adaptive(minimum: 400, maximum: 400), spacing: 10),
        GridItem(.adaptive(minimum: 400, maximum: 400), spacing: 10),
    ]
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ScrollView(.vertical){
            LazyVGrid(columns:  horizontalSizeClass == .compact ? compactLayout : regularLayout){
                ForEach(viewModel.imageURLs, id: \.self){
                    url in
                    DogImageCardView(url: url)
                        
                }
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            //ensures fetch is called on iphone
            viewModel.fetchImages()
        }
        .onChange(of: viewModel.title) {
            //ensures fetch called when displaying master/detail
            viewModel.fetchImages()
        }
    }
}


#Preview {
    BreedDetailView(breed: SelectedBreed(breedName: "terrier", subbreed: "border"))
}

