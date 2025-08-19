//
//  ZoomableDogImageCard.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import SwiftUI

struct ZoomableDogImageCard: View {
    var url: URL
    var image: Image
    @Namespace var namespace
    
    var body: some View {
            VStack() {
                if #available(iOS 18.0, *) {
                    NavigationLink() {
                        ZStack {
                            image
                                .resizable()
                                .aspectRatio(nil, contentMode: .fit)
                                .background(.clear)
                        }
                        .navigationTransition( .zoom(sourceID: "image-\(url.absoluteString)", in: namespace))
                    }
                    label : {
                        image
                            .resizable()
                            .aspectRatio(nil, contentMode: .fit)
                            
                    }
                    .matchedTransitionSource(id: "image-\(url.absoluteString)", in: namespace)
                    
                } else {
                    image
                        .resizable()
                        .aspectRatio(nil, contentMode: .fit)
                }
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
    }
}

#Preview {
    @Previewable @Namespace var namespace
    let image = Image("previewImage")
    
    ZoomableDogImageCard(url: URL(string:"https://images.dog.ceo/breeds/affenpinscher/n02110627_3144.jpg")!, image:image, namespace: _namespace)
}
