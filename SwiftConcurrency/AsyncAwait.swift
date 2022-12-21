//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Daniel Berezhnoy on 12/20/22.
//

import SwiftUI

struct AsyncAwait: View {
    @StateObject private var viewModel = AsyncAwaitViewModel()
    
    var body: some View {
        NavigationStack {
            list
            button
        }
        .refreshable { viewModel.array.removeAll() }
    }
    
    var list: some View {
        List(viewModel.array, id: \.self) { row in
            Text(row)
        }
        .navigationTitle("List")
    }
    
    var button: some View {
        Button {
            Task {
//                await viewModel.addAuthors()
            }
        } label: {
            Label("Add New Row", systemImage: "swift")
                .font(.headline)
                .padding(7)
        }
        .buttonStyle(.bordered)
        .tint(.cyan)
        .padding(.top)
    }
}

struct AsyncAwait_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait()
    }
}

class AsyncAwaitViewModel: ObservableObject {
    
    @Published var array: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter (deadline: .now() + 2) {
            self.array.append ("Title: \(Thread .current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global() .asyncAfter (deadline: .now () + 2) {
            let title2 = "Title 2: \(Thread .current)"
            
            DispatchQueue.main.async {
                self.array.append(title2)
                
                let title3 = "Title 3: \(Thread .current)"
                self.array.append(title3)
            }
        }
    }
    
//    func addAuthors() async {
//        let author1 = "Author 1: \(Thread.current)"
//        self.array.append(author1)
//
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
//        let author2 = "Author 2: \(Thread.current)"
//
//        await MainActor.run {
//            self.array.append(author2)
//
//            let author3 = "Author 3: \(Thread.current)"
//            array.append(author3 )
//        }
//    }
}
