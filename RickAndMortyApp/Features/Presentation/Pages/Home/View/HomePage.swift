//
//  HomePage.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 5/04/26.
//

import SwiftUI
import Observation

struct HomePage: View {
    
    @EnvironmentObject var router: Router
    @Bindable var viewModel: HomePageViewModel
    
    @State var showStatusBar = true
    @State var contentHasScrolled = false
    @State var showNav = false
    @State var showDetail: Bool = false
    @State var selectedCharacter: CharacterBusinessModel?
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            scrollView
        }
        .onChange(of: showDetail) {
            withAnimation {
                showNav.toggle()
                showStatusBar.toggle()
            }
        }
        .overlay(NavigationBarView(title: "Characters", contentHasScrolled: $contentHasScrolled))
        .statusBar(hidden: !showStatusBar)
        .onAppear {
            Task {
                await viewModel.loadCharacterList()
            }
        }
        .alert(isPresented: $showDetail) {
            
            Alert(title: Text("Important Messaje"),
                  message: Text(viewModel.viewError?.localizedDescription ?? "Unexpected error is happen"),
                  dismissButton: .default(Text("Go it!")))
            
        }.sheet(isPresented: $showDetail) {
            CharacterDetailPage(character: selectedCharacter)
        }
    }
    
    var scrollView: some View {
        ScrollView() {
            scrollDetectionView
            characterListView
                .padding(.vertical, 70)
                .padding(.horizontal, 50)
            
        }.coordinateSpace(.named("scroll"))
    }
    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                let estimatedContentheight = CGFloat(viewModel.characterList.count * 100)
                let threshold = 0.8 * estimatedContentheight
                
                if value <= -threshold {
                    Task {
                        await viewModel.loadCharacterList()
                    }
                }
                
                contentHasScrolled  = value < 0 //? true : false
                
            }
        }
    }
    var characterListView: some View {
        VStack(spacing: 16) {
            ForEach(Array(viewModel.characterList.enumerated()), id: \.offset) { index, businessModel in
                SectionRowView(section: SectionRowModel(businessModel: businessModel))
                    .onTapGesture {
                        selectedCharacter = businessModel
                        showDetail = true
                    }
                if index == viewModel.characterList.count - 1 {
                    Divider()
                    if viewModel.isLoading {
                        ProgressView("loading more characters...")
                            .accentColor(.white)
                    }
                } else {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(.horizontal, 20)
    }
}
