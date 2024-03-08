//
//  ContentView.swift
//  API Calling
//
//  Created by Nicholas Papierniak on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var memes = [Item]()
    var body: some View {
        NavigationView {
            List (memes) { item in
                Link (destination: URL(string: item.url)!) {
                    Text (item.name)
                }
                .navigationTitle ("Epic Memes")
            }
            .task {
                await loadData ()
            }
        }
    }
    func loadData() async {
        if let url = URL(string: "https://api.imgflip.com/get_memes") {
            if let (data, _) = try? await URLSession.shared.data (from: url) {
                if let decodedResponse = try? JSONDecoder().decode (Entries.self, from: data) {
                    memes = decodedResponse.response.memes
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Item: Identifiable, Codable {
    var id = UUID()
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
struct Memes: Codable {
    var memes: [Item]
}
struct Entries: Codable {
    var response: Memes
    enum CodingKeys: String, CodingKey {
        case response = "data"
    }
}
