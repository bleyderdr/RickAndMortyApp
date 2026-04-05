//
//  CharacterUseCaseTest.swift
//  RickAndMortyAppTests
//
//  Created by Bladimir Salinas on 30/03/26.
//
import XCTest
@testable import RickAndMortyApp


//MARK: - Test

@MainActor
class CharacterUseCaseTest: XCTestCase {
    
    var sut: CharacterUseCase?
    var sutFailure: CharacterUseCase?
    
    override func setUp() {
        super.setUp()
        sut = DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceSuccess()))
        sutFailure = DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceFailure()))
    }
    
    override func tearDown() {
        sut = nil
        sutFailure = nil
        super.tearDown()//MARK: -
    }
    
}

//MARK: - Success Test

extension CharacterUseCaseTest {
    func testSuccessCase_getCharacterList() async {
        
        do {
            let response = try await sut?.getCharacterList(pageNumber: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch  {
            XCTFail("Alwais receiv a response and not throw an error")
        }
        
    }
    
    func testSuccessCase_SearchCharacter() async {
        do {
            let response = try await sut?.searchCharacter(by: "Rick", and: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch  {
            XCTFail("Alwais receive a response and not throw an error")
        }
    }
}


//MARK: - Failure Test

extension CharacterUseCaseTest {
    
    func testFailureCase_getCharacterList() async {
        do {
            let _ = try await sutFailure?.getCharacterList(pageNumber: nil)
            XCTFail("Should throw an error")
        } catch {
             
        }
    }
    
    func testFailureCase_SearchCharacter() async {
        do {
            let _ = try await sutFailure?.searchCharacter(by: "Rick", and: nil)
            XCTFail("Should throw an error")
        } catch {
            
        }
    }
    
}

