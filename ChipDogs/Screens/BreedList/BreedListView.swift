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
                            Text(viewModel.title).font(.custom("Futura", size: 28)).bold()
                                .padding()
                        }
                    }
                }
            }
            
        }
        detail: {
            WelcomeDetailView(url: $viewModel.welcomeImageURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewModel.fetchWelcomeImage()
                }
        }
        .onAppear {
            viewModel.fetchBreeds()
        }
        .alert("Error fetching dogs!", isPresented: $viewModel.fetchFailed) {
            Button("OK") {}
        }
        
        .searchable(text: $viewModel.searchTerm)
        .refreshable {
            viewModel.fetchBreeds()
        }
    }
}

struct WelcomeDetailView: View {
    
    @Binding var url: URL?
    
    var body: some View {
        VStack {
            VStack{
                Text("Welcome to ChipDogs!")
                    .font(.custom("Futura", size: 28))
                    .bold()
                    .padding()
                Text("Choose a breed from the list to view some dogs.").font(.custom("Futura", size: 18))
            }
            
            if let url = url {
                DogImageCardView(url: url)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .padding()
        .background(Color.baseAppBackground)
        
    }
}

#Preview {
    BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
}
