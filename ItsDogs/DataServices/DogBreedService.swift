//
//  DogBreedService.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//

struct DogBreedService: DogBreedServiceProtocol {
    
    private var api: APIManagerProtocol
    
    init(api: APIManagerProtocol) {
        self.api = api
    }
    
    func fetchBreedList() async throws -> [Breed] {
        do {
            let response: BreedListResponse = try await api.getData(from: .fetchBreeds)
            guard response.status == .success else {
                throw DogError.fetchError("Failed to fetch dog breeds!")
            }
            return response.message.map({Breed(breedName: $0, subbreeds: $1)})
                .sorted(by: {$0.breedName < $1.breedName})
        }
        catch {
            print("Error in DogBreedService.fetchBreedList \(error.localizedDescription)")
            throw DogError.fetchError("Error fetching dog breeds!")
        }
    }
}

protocol DogBreedServiceProtocol {
    func fetchBreedList() async throws -> [Breed]
}
