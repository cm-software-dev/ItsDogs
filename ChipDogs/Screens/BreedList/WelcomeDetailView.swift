//
//  WelcomeDetailView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import SwiftUI

struct WelcomeDetailView: View {
    
    @Binding var url: URL?
    
    var body: some View {
        VStack {
            VStack{
                Text("Welcome to ChipDogs!")
                    .fontAppDefaultBold(size: 28)
                    .padding()
                Text("Choose a breed from the list to view some dogs.").fontAppDefault(size: 18)
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
    @Previewable @State var url = URL(string: "https://images.dog.ceo/breeds/affenpinscher/n02110627_3144.jpg")
    WelcomeDetailView(url: $url)
}
