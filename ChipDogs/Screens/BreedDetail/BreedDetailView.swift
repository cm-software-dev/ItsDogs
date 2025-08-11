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
        GridItem(.fixed(400), spacing: 10),
        GridItem(.fixed(400), spacing: 10),
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
        .background(Color.baseAppBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.title).fontAppDefaultBold(size: 28)
                        .padding()
                }
            }
        }
        .onAppear {
            //ensures fetch is called on iphone
            if viewModel.imageURLs.isEmpty {
                viewModel.fetchImages()
            }
        }
        .onChange(of: viewModel.title) {
            //ensures fetch called when displaying master/detail
            viewModel.fetchImages()
        }
        .alert("Error fetching the dogs images!", isPresented: $viewModel.fetchFailed) {
            Button("OK") {}
        }
    }
}


#Preview {
    BreedDetailView(breed: SelectedBreed(breedName: "terrier", subbreed: "border"))
}

