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
        VStack {
            if let image = viewModel.image {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.orange)
                    .frame(width: 250)
                    .cornerRadius(20)
            }
            
            Button("Load Image") { viewModel.getImage() }
                .buttonStyle(.borderedProminent)
                .padding(30)
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image = Image(systemName: "swift")
    let loader = ImageLoader()
    
    func getImage() {
        loader.downloadWithEscaping { [weak self] image, error in
            DispatchQueue.main.async {
                if let image {
                    self?.image = Image(uiImage: image)
                }
            }
        }
    }
}

class ImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func downloadWithEscaping(cHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            let image = self.handleResponse(data: data, response: response)
            cHandler(image, error)
        }
        .resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            200 ... 300 ~= response.statusCode
                
        else { return nil }
        
        return image
    }
}
