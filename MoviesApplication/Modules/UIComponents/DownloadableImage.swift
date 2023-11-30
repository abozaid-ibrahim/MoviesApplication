//
//  DownloadableImage.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import SwiftUI

struct DownloadableImage: View {
    let url: URL?

    let width: CGFloat
    let height: CGFloat
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .accessibilityLabel("Failed to load header image")
            @unknown default:
                fatalError("An unrecoverable error occurred!")
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    DownloadableImage(url: nil, width: 0, height: 0)
}
