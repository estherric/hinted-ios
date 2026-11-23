
import Foundation

// handles requests to the Channel3 clothing API
class ClothingAPIService {

    private let apiURL = "https://api.trychannel3.com/v1/search"

    // search for clothing products
    func searchClothing(query: String, apiKey: String) async throws -> [ClothingProduct] {

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
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // decode the JSON response
        let result = try JSONDecoder().decode(ClothingSearchResponse.self, from: data)

        return result.products
    }
}

// response body sent to Channel3
struct ClothingSearchRequest: Codable {
    let query: String
    let limit: Int
}

// response containing the clothing products
struct ClothingSearchResponse: Codable {
    let products: [ClothingProduct]
    let nextPageToken: String?

    enum CodingKeys: String, CodingKey {
        case products
        case nextPageToken = "next_page_token"
    }
}

