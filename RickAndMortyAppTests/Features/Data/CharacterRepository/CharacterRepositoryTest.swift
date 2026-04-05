//
//  CharacterRepositoryTest.swift
//  RickAndMortyAppTests
//
//  Created by Bladimir Salinas on 28/03/26.
//

import XCTest
@testable import RickAndMortyApp

//MARK: - Test

@MainActor
class CharacterRepositoryTest: XCTestCase {
    
    var sut: CharacterRepository?
    var sutFailure: CharacterRepository?
    
    override func setUp() {
        super.setUp()
        sut = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceSuccess())
        sutFailure = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceFailure())
    }
    
    override func tearDown() {
        sut = nil
        sutFailure = nil
        super.tearDown()
    }
    
}

//MARK: - Success Test

extension CharacterRepositoryTest {
    func testSuccessCase_getCharacterList() async {
        do {
            let response = try await sut?.getCharacterList(pageNumber: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch {
            
                XCTFail("Unexpected error: \(error)")
            
        }
    }
    
    func testSuccessCase_SearchCharacter() async {
        do {
            let response = try await sut?.searchCharacter(by: "Rick", and: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch {
            XCTFail("Always receive a response and not throw an error")
        }
    }
}


//MARK: - Failure Test

extension CharacterRepositoryTest {
    func testFailureCase_getCharacterList() async {
        do {
            let _ = try await sutFailure?.getCharacterList(pageNumber: nil)
            
            XCTFail("Unexpected error")
        } catch {
            
            
        }
    }
    
    func testFailureCase_getCharacterListError() async {
        let sut: CharacterRepository = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceParseErrorFailure())
        do {
            let _ = try await sut.getCharacterList(pageNumber: nil)
            XCTFail("this test should throw an error")
        } catch {
            if error is AppError {
                XCTAssertEqual(error.localizedDescription, AppError.parseError.localizedDescription)
            } else {
                XCTFail("This test should throw an parde error")
            }
        }
    }
    
    func testFailureCase_SearchCharacter() async {
        do {
            let _ = try await sutFailure?.searchCharacter(by: "Rick", and: nil)
            XCTFail("This test should throw an error")
        } catch {
            
        }
    }
    
}
