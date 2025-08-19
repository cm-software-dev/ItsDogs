//
//  WelcomeDetailView.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import SwiftUI

struct WelcomeDetailView: View {
    
    @ObservedObject var viewModel: BreedListViewModel
    
    var body: some View {
        VStack {
            VStack{
                Text("Welcome to ItsDogs!")
                    .fontAppDefaultBold(size: 28)
                    .padding()
                Text("Choose a breed from the list to view some dogs.").fontAppDefault(size: 18)
            }
            
            if let url = viewModel.welcomeImageURL {
                DogImageCardView(url: url)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .padding()
        .background(Color.baseAppBackground)
        .task {
            await viewModel.fetchWelcomeImage()
        }
    }
}

#Preview {
    WelcomeDetailView(viewModel: BreedListViewModel(imageService: DogImageService(api: APIManager.shared), breedService: DogBreedService(api: APIManager.shared)))
}
