//
//  SearchPageViewModelTest.swift
//  RickAndMortyAppTests
//
//  Created by Bladimir Salinas on 15/04/26.
//


import XCTest
@testable import RickAndMortyApp

//MARK: - Test

@MainActor
class SearchPageViewModelTest: XCTestCase {
    
    private var sut: SearchPageViewModel?
    private var sutFailure: SearchPageViewModel?
    
    override func setUp() {
        super.setUp()
        sut = SearchPageViewModel(useCase: DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceSuccess())))
        sutFailure = SearchPageViewModel(useCase: DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceFailure())))
    }
    
    override func tearDown() {
        sut = nil
        sutFailure = nil
        super.tearDown()//MARK: -
    }
    
}

//MARK: - Success Test

extension SearchPageViewModelTest {
    func testSuccessCaseSearchCharacter() async {
        await sut?.searchCharacter(by: "Rick", isFirstLoad: true)
        
        XCTAssertTrue(sut?.characterList.first?.id == 21)
    }
    
    func testSuccessCaseSearchCharacterEmptyName() async {
        await sut?.searchCharacter(by: "", isFirstLoad: true)
        
        XCTAssertTrue(sut?.characterList.isEmpty ?? false)
    }
}


//MARK: - Failure Test

extension SearchPageViewModelTest {
    func testFailureCase_LoadCharacterList() async {
        guard let sutFailure else { return }
        await sutFailure.searchCharacter(by: "Rick", isFirstLoad: true)
        XCTAssertTrue(sutFailure.characterList.isEmpty)
    }
}

