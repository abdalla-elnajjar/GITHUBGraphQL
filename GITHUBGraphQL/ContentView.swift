//
//  ContentView.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//
import SwiftUI

struct ContentView: View {
    @State private var responseData: [String: Any]?
    @State private var error: Error?
    
    var body: some View {
        VStack {
            Button("Fetch Data") {
                fetchData()
            }
            
            if let responseData = responseData {
                Text("Response: \(dictionaryToString(responseData))")
                    .multilineTextAlignment(.center)
            }
            
            if let error = error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    func fetchData() {
        let endpoint = URL(string: "https://api.github.com/graphql")!
        let query = """
            query {
                repository(owner: "a-elnajjar", name: "Painless-icon-generation-for-iOS-apps") {
                    name
                    description
                    stargazers {
                        totalCount
                    }
                }
            }
        """

        let token = "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"
        
        sendGraphQLRequest(url: endpoint, query: query, token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dataDict = json as? [String: Any],
                       let data = dataDict["data"] as? [String: Any] {
                        self.responseData = data
                    }
                case .failure(let error):
                    self.error = error
                }
            }
        }
        
        
    }
    
    func dictionaryToString(_ dictionary: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
