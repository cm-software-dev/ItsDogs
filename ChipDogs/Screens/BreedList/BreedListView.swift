//
//  BreedListView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct BreedListView: View {
    
    @StateObject var viewModel: BreedListViewModel
   
    var destinationView: BreedDetailView?
    
    var body: some View {
        
        NavigationSplitView {
            NavigationStack {
                List(viewModel.breedList, id: \.self){
                    breed in
                    BreedRow(breed: breed)
                }
            }
            
        }
        detail: {
            WelcomeDetailView(url: $viewModel.welcomeImageURL)
                .onAppear {
                    viewModel.fetchWelcomeImage()
                }
        }
        .onAppear {
            viewModel.fetchBreeds()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .searchable(text: $viewModel.searchTerm)
    }
}

struct WelcomeDetailView: View {
    
    @Binding var url: URL?
    
    var body: some View {
        VStack {
            Text("Welcome to ChipDogs!")
                    .font(.headline)
                    .padding()
            Text("Choose a breed from the list to view some dogs.")
           
                if let url = url {
                    DogImageCardView(url: url)
                        .padding()
                }
        }
    }
}

#Preview {
    BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
}
