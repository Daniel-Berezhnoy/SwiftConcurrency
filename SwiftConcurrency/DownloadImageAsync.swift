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
            image
            button
        }
    }
    
    var image: some View {
        ZStack {
            if let image = viewModel.image {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.orange)
                    .frame(width: 250)
                    .cornerRadius(20)
            }
        }
    }
    
    var button: some View {
        Button {
            Task {
                await viewModel.getImage()
            }
        } label: {
            Label("Load Image", systemImage: "photo")
                .padding(5)
                .font(.headline)
        }
        .buttonStyle(.bordered)
        .tint(.orange)
        .padding(.top, 30)
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: Image? = Image(systemName: "swift")
    let loader = ImageLoader()
    
    func getImage() async {
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                if let image {
//                    self?.image = Image(uiImage: image)
//                }
//            }
//        }
        
        let image = try? await loader.downloadWithAsync()
        self.image = Image(uiImage: image ?? UIImage(systemName: "swift")!)
    }
}

class ImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            200 ... 300 ~= response.statusCode
                
        else { return nil }
        
        return image
    }
    
    func downloadWithEscaping(handler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            handler(image, error)
        }
        .resume()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    } 
}
