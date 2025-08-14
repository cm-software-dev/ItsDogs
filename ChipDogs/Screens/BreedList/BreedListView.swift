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
                .listRowBackground(Color.white)
                .background(Color.baseAppBackground)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(viewModel.title).fontAppDefaultBold(size: 28)
                                .padding()
                        }
                    }
                }
            }
            
        }
        detail: {
            WelcomeDetailView(url: $viewModel.welcomeImageURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task {
                    await viewModel.fetchWelcomeImage()
                }
        }
        .task {
            await viewModel.fetchBreeds()
        }
        .alert("Error fetching dogs!", isPresented: $viewModel.fetchFailed) {
            Button("OK") {}
        }
        
        .searchable(text: $viewModel.searchTerm)
        .refreshable {
            await viewModel.fetchBreeds()
        }
    }
}



#Preview {
    BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
}
