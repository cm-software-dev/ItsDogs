//
//  DogBreedServiceTests.swift
//  ItsDogsTests
//
//  Created by Calum Maclellan on 14/08/2025.
//
@testable import ItsDogs
import XCTest

final class DogBreedServiceTests: XCTestCase {
    
    var service: DogBreedService!
    var api: MockAPIManager<BreedListResponse>!
    
    var testBreedList = [
        "hound": ["blood", "sleepy", "dozey"],
        "sausage": []
    ]
    
    
    override func setUpWithError() throws {
        api = MockAPIManager<BreedListResponse>()
        service = DogBreedService(api: api)
    }

    func testFetchBreedsCallsAPIAndParsesResponse() async {
        do {
            let breedResponse = BreedListResponse(message: testBreedList, status: .success)
            api.response = breedResponse
            let response = try await service.fetchBreedList()
            
            let expectedsSausageArray: [String] = []
            XCTAssertEqual(api.getDataCallCounter, 1)
            XCTAssertEqual(2, response.count)
            XCTAssertEqual(testBreedList["hound"]?.first, response.first?.subbreeds.first)
            XCTAssertEqual(expectedsSausageArray, response[1].subbreeds)

        }
        catch {
            XCTFail()
        }
    }

    func testFetchBreedsThrowsDogErrorIfResponseIsNotSuccess() async {
        do {
            let breedResponse = BreedListResponse(message: [:], status: .error)
            api.response = breedResponse
            let _ = try await service.fetchBreedList()

        }
        catch let dogError as DogError {
            XCTAssertEqual(api.getDataCallCounter, 1)
        }
        catch {
            XCTFail()
        }
    }
    

}
