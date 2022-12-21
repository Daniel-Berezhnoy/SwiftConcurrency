//
//  TaskView.swift
//  SwiftConcurrency
//
//  Created by Daniel Berezhnoy on 12/20/22.
//

import SwiftUI

struct TaskView: View {
    
    @StateObject var viewModel = TaskViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.cyan.ignoresSafeArea().opacity(0.2)
            image
            button
        }
    }
    
    var image: some View {
        viewModel.image1
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .onDisappear {
                fetchImageTask?.cancel()
            }
    }
    
    var image2: some View {
        viewModel.image2
            .resizable()
            .scaledToFit()
            .frame(width: 250)
            .cornerRadius(20)
    }
    
    var button: some View {
        Button {
            fetchImageTask = Task {
                await viewModel.fetchImage1()
            }
//
//            Task {
//                print(Thread.current)
//                print(Task.basePriority)
//                await viewModel.fetchImage2()
//            }
//
//            Task(priority: .low) {
//                print("LOW: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .medium) {
//                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .high) {
//                print("HIGH: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .background) {
//                print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .utility) {
//                print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .userInitiated) {
//                print("USER INITIATED: \(Thread.current) : \(Task.currentPriority )")
//            }
            
        } label: {
            Label("New Image", systemImage: "photo")
                .padding(5)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .padding()
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

class TaskViewModel: ObservableObject {
    
    @Published var image1: Image = Image(systemName: "empty")
    @Published var image2: Image = Image(systemName: "swift")
    
    func fetchImage1() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        do {
            guard let url = URL(string: "https://picsum.photos/1200/2400") else { return }
            let (data, _ )  = try await  URLSession.shared.data(from: url)
            
            await MainActor.run {
                if let uiImage = UIImage(data: data) {
                    self.image1 = Image(uiImage: uiImage)
                    print("Got The Image!")
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/4000") else { return }
            let (data, _ )  = try await  URLSession.shared.data(from: url)
            
            await MainActor.run {
                if let uiImage = UIImage(data: data) {
                    self.image2 = Image(uiImage: uiImage)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
