//
//  FirebaseImage.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseStorage

class ImageLoader: ObservableObject {
    @Published var data: Data?

    func loadImage(url: String) {
        let imageRef = Storage.storage().reference().child(url)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

struct FBURLImage: View {
    @ObservedObject var imageLoader: ImageLoader

    init(url: String) {
        imageLoader = ImageLoader()
        imageLoader.loadImage(url: url)
    }

    var body: some View {
        Image(uiImage:
            (imageLoader.data.flatMap(UIImage.init) ?? UIImage(systemName: "tortoise.fill")!))
    }
}
