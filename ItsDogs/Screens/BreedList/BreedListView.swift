//
//  BreedListView.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct BreedListView: View {
    
    @StateObject var viewModel: BreedListViewModel
    @State private var query = ""
    
    var destinationView: BreedDetailView?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
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
            NavigationStack {
                switch (horizontalSizeClass) {
                case .regular:
                    WelcomeDetailView(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                default:
                    EmptyView()
                }
            }
        }
        .task {
            await viewModel.fetchBreeds()
        }
        .alert("Error fetching dogs!", isPresented: $viewModel.fetchFailed) {
            Button("OK") {}
        }
        
        .searchable(text: $query)
        .task(id: query) {
            do {
                try await Task.sleep(for: .seconds(1))
                await viewModel.filterBreeds(term: query)
            }
            catch {}
        }
        .refreshable {
            await viewModel.fetchBreeds()
        }
    }
}

#Preview {
    let viewModel = BreedListViewModel(imageService: DogImageService(api: APIManager.shared), breedService: DogBreedService(api: APIManager.shared))
    BreedListView(viewModel: viewModel)
}
