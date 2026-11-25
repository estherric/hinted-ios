
import Foundation

// MARK: - Clothing API Service

// handles requests to the Channel3 clothing API
class ClothingAPIService {

    private let apiURL = "https://api.trychannel3.com/v1/search"

    // search for clothing products
    func searchClothing(query: String, apiKey: String) async throws -> [ClothingProduct] {

        // converts the api address into a URL
        guard let url = URL(string: apiURL) else {
            throw URLError(.badURL)
        }

        // create the API request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        // create the JSON request body
        let body = ClothingSearchRequest(query: query, limit: 10)
        request.httpBody = try JSONEncoder().encode(body)

        // send the request
        let (data, response) = try await URLSession.shared.data(for: request)

        // check if the request succeeded
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // verify the API responded successfully.
        guard (200...299).contains(httpResponse.statusCode) else {

            // print the HTTP status code to identify the problem
            print("Channel3 HTTP status: \(httpResponse.statusCode)")

            // print the server response to help with debugging.
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Channel3 API error: \(errorMessage)")

            throw URLError(.badServerResponse)
        }

        // decode the JSON response
        let result = try JSONDecoder().decode(
            ClothingSearchResponse.self,
            from: data
        )

        // return the products to the Explore screen
        return result.products
    }
}

// MARK: - API Request Model

// response body sent to Channel3
struct ClothingSearchRequest: Codable {
    let query: String
    let limit: Int
}

// MARK: - API Response Model

// response containing the clothing products
struct ClothingSearchResponse: Codable {
    let products: [ClothingProduct]
    let nextPageToken: String?

    // maps the API's key to Swift's property
    enum CodingKeys: String, CodingKey {
        case products
        case nextPageToken = "next_page_token"
    }
}
