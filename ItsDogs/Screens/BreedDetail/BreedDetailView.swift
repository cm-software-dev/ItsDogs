//
//  BreedDetailView.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Combine

struct BreedDetailView: View {
    
    @ObservedObject var viewModel: BreedDetailViewModel
    
    init(breed: SelectedBreed) {
        viewModel = BreedDetailViewModel(breed: breed, imageService: DogImageService(api: APIManager.shared))
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
        .refreshable {
            Task {
                await viewModel.fetchImages()
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
        .task {
            //ensures fetch is called on iphone
           if viewModel.imageURLs.isEmpty {
                await viewModel.fetchImages()
            }
        }
        .onChange(of: viewModel.title) {
            //ensures fetch called when displaying master/detail
            Task {
                await viewModel.fetchImages()
            }
        }
        .alert("Error fetching the dogs images!", isPresented: $viewModel.fetchFailed) {
            Button("OK") {}
        }
    }
}


#Preview {
    BreedDetailView(breed: SelectedBreed(breedName: "terrier", subbreed: "border"))
}

