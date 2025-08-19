//
//  DogImageServiceTests.swift
//  ItsDogsTests
//
//  Created by Calum Maclellan on 14/08/2025.
//
@testable import ItsDogs
import XCTest

final class DogImageServiceTests: XCTestCase {

    
    var service: DogImageService!
    var imageApi: MockAPIManager<ImageResponse>!
    var singleImageApi: MockAPIManager<SingleImageResponse>!
    
    let testURLstrings =  ["https://images.dog.ceo/breeds/weimaraner/n02092339_114.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4271.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4346.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_512.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_5978.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6269.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6401.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6752.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_7918.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_93.jpg"]
    
    override func setUpWithError() throws {
        imageApi = MockAPIManager()
        singleImageApi = MockAPIManager()
        service = DogImageService(api: imageApi)
    }


    func testFetchImageWithBreedOnlyCallsAPIManagerAndReturnsImageURLs() async throws {
        
        imageApi.response = ImageResponse(message: testURLstrings, status: .success)
        
        let expectedBreed = "dalmation"
        do {
            let urls = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed)
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            XCTAssertEqual(testURLstrings.count, urls.count)
            XCTAssertEqual(testURLstrings.first, urls.first?.absoluteString)
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchImageWithBreedOnlyThrowsWhenAPIReturnsError() async throws {
        
        imageApi.response = ImageResponse(message: [], status: .error)
        
        let expectedBreed = "dalmation"
        do {
            let _ = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed)
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog images!", message)
            }
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchImageWithBreedOnlyThrowsWhenAPIThrowsError() async throws {
        
        imageApi.response = nil
        
        let expectedBreed = "dalmation"
        do {
            let _ = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed)
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog images!", message)
            }
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchImageWithSubbreedCallsAPIManagerAndReturnsImageURLs() async throws {
        
        imageApi.response = ImageResponse(message: testURLstrings, status: .success)
        
        let expectedBreed = "terrier"
        let expectedSubbreed = "border"
        do {
            let urls = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed, subbreed: expectedSubbreed)
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/\(expectedSubbreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            XCTAssertEqual(testURLstrings.count, urls.count)
            XCTAssertEqual(testURLstrings.first, urls.first?.absoluteString)
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchImageWithSubbreedThrowsWhenAPIReturnsError() async throws {
        
        imageApi.response = ImageResponse(message: [], status: .error)
        
        let expectedBreed = "terrirt"
        let expectedSubbreed = "border"
        do {
            let _ = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed, subbreed: expectedSubbreed)
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/\(expectedSubbreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog images!", message)
            }
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchImageWithSubbreedThrowsWhenAPIThrowsError() async throws {
        
        imageApi.response = nil
        
        let expectedBreed = "terrier"
        let expecteSubbreed = "border"
        do {
            let _ = try await service.fetchDogImages(numberOfImages: 10, breed: expectedBreed, subbreed: expecteSubbreed)
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, imageApi.getDataCallCounter)
            XCTAssertEqual("/api/breed/\(expectedBreed)/\(expecteSubbreed)/images/random/\(10)", imageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog images!", message)
            }
        }
        catch {
            XCTFail()
        }
    }
    
    func testFetchSingleImageCallsAPIManagerAndReturnsImageURL() async throws {
        
        let expectedURL = "https://images.dog.ceo/breeds/weimaraner/n02092339_6269.jpg"
        singleImageApi.response = SingleImageResponse(message: expectedURL, status: .success)
        service = DogImageService(api: singleImageApi)
        
        do {
            let url = try await service.fetchSingleRandomDogImage()
            XCTAssertEqual(1, singleImageApi.getDataCallCounter)
            XCTAssertEqual("/api/breeds/image/random", singleImageApi.endpointPassed?.path)
            XCTAssertEqual(expectedURL, url.absoluteString)
        }
        catch {
            XCTFail()
        }
    }
    
    func testSingleImageThrowsWhenAPIReturnsError() async throws {
        
        singleImageApi.response = SingleImageResponse(message: "", status: .error)
        service = DogImageService(api: singleImageApi)
        
        do {
            let _ = try await service.fetchSingleRandomDogImage()
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, singleImageApi.getDataCallCounter)
            XCTAssertEqual("/api/breeds/image/random", singleImageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog image!", message)
            }
        }
        catch {
            XCTFail()
        }
    }
    
    func testSingleImageThrowsWhenAPIThrowsError() async throws {
        
        singleImageApi.response = nil
        service = DogImageService(api: singleImageApi)
        
        do {
            let _ = try await service.fetchSingleRandomDogImage()
        }
        catch let dogError as DogError {
            XCTAssertEqual(1, singleImageApi.getDataCallCounter)
            XCTAssertEqual("/api/breeds/image/random", singleImageApi.endpointPassed?.path)
            switch(dogError) {
            case .fetchError(let message):
                XCTAssertEqual("Error fetching dog image!", message)
            }
        }
        catch {
            XCTFail()
        }
    }

  

}
