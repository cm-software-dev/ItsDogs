//
//  DogImageView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 08/08/2025.
//

import SwiftUI

struct DogImageCardView: View
{
    let url: URL
    private var isRetry: Bool = false
    
    init(url: URL) {
        self.init(url: url, isRetry: false)
    }
    
    private init(url: URL, isRetry: Bool) {
        self.url = url
        self.isRetry = isRetry
    }
    
    var body: some View {
        AsyncImage(url: url) {
            phase in
            switch phase {
            case .empty:
                DogProgressView()
                    .controlSize(.regular)
                    .frame(width: 300, height: 200)
            case .success(let image):
                VStack() {
                    image
                        .resizable()
                        .aspectRatio(nil, contentMode: .fit)
                    HStack(){
                        Spacer()
                        ShareLink(item: image, preview: SharePreview("Share this dog!", image: image)) {
                            Label("", systemImage: "square.and.arrow.up")
                                .foregroundColor(.black)
                                .padding(.trailing, 16)
                                .padding(.bottom, 8)
                        }
                    }
                    
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 24.0))
                .padding()
                
                .shadow(radius: 8)
            case .failure(let error):
                if !isRetry && (error as? URLError)?.code == .cancelled {
                    DogImageCardView(url: url, isRetry: true)
                } else {
                    EmptyView()
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    DogImageCardView(url: URL(string:"https://images.dog.ceo/breeds/affenpinscher/n02110627_3144.jpg")!)
}
