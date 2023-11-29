//
//  DownloadableImage.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import SwiftUI

struct DownloadableImage: View{
    let url: URL?
    var body: some View{
        AsyncImage(url: url) { phase in
                       switch phase {
                       case .empty:
                           ProgressView()
                       case .success(let image):
                           image
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                       case .failure:
                           Image(systemName: "photo")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                       @unknown default:
                           fatalError("Unknown case")
                       }
                   }
    }
    
}
#Preview {
    DownloadableImage(url: nil)
}
