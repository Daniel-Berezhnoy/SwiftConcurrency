//
//  DoCatchTryThrows.swift
//  SwiftConcurrency
//
//  Created by Daniel Berezhnoy on 12/20/22.
//

import SwiftUI

// do-catch
// try
// throws

struct DoCatchTryThrows: View {
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                textBlock
            }
            .navigationTitle("DoCatchTryThrows")
        }
    }
    
    var textBlock: some View {
        Text(viewModel.text)
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .frame(width: 300, height: 300)
            .background(Color.cyan.gradient)
            .cornerRadius(20)
            .padding(.top, 120)
            .onTapGesture { viewModel.fetchTitle() }
    }
}

struct DoCatchTryThrows_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrows()
    }
}


class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text = "Starting Text"
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
//        let response = manager.getTitle1()
//
//        if let newTitle = response.title {
//            text = newTitle
//        } else if let error = response.error {
//            text = error.localizedDescription
//        }
        
//        let result = manager.getTitle2()
//
//        switch result {
//            case .success(let newTitle):
//                text = newTitle
//            case .failure(let error):
//                text = error.localizedDescription
//        }
        
//        do { text = try manager.getTitle3() }
//        catch { text = error.localizedDescription }
        
        do {
            
            let newTitle = try? manager.getTitle3()
            if let newTitle { text = newTitle }
            
            let finalTitle = try manager.getTitle4()
            text = finalTitle
            
        } catch {
            text = error.localizedDescription
            
        }
    }
}

class DoCatchTryThrowsDataManager {
    
    var isActive = true
    
    func getTitle1() -> (title: String?, error: Error?) {
        isActive ? ("New Text!!!", nil) : (nil, URLError(.badURL))
    }
    
    func getTitle2() -> Result <String, Error> {
        if isActive {
            return .success("New Text!!!")
        } else {
            return .failure(URLError(.badURL ))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "New Text!!!"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL Text!!!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
