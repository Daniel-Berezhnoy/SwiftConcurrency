//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by Daniel Berezhnoy on 12/20/22.
//

import SwiftUI

struct DownloadImageAsync: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.orange.gradient)
                    .frame(width: 250)
            }
        }
        .onAppear {
            viewModel.getImage()
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: Image? = nil
    
    func getImage() {
        image = Image(systemName: "swift")
    }
}
