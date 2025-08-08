//
//  DogsListView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter

struct DogsListView: View {
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State var viewModel: ViewModel
    @Environment(SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>.self) private var router
    private var navigationTitle: String {
        "List of dogs"
    }
    var filteredDogs: [Dog] {
        viewModel.getDogs(filterOption: selectedFilter, searchText: searchText)
    }
    
    init(_ networkService: DogsListNetwork = DogsNetworkService(), favoriteStorage: DogsListFavoriteStorage = FavoriteDogBreedsStorage()) {
        let viewModel = ViewModel(networkService: networkService, favoriteStorage: favoriteStorage)
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.loading {
                loadingView
            } else {
                dogsListView
            }
        }
        .listStyle(.plain)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolBarMenu
            }
        }
        .task {
            if viewModel.shouldLoadData {
                viewModel.shouldLoadData.toggle()
                // adding delay due to imitation of heavy request
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.viewModel.loadData()
                }
            } else {
                viewModel.reloadData()
            }
        }
    }
    
    private var loadingView: some View {
        List {
            ForEach((1...10), id: \.self) { _ in
                LoadingDogRowView()
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .frame(height: 60)
                    .onTapGesture {}
            }
        }
    }
    
    private var dogsListView: some View {
        List(filteredDogs) { dog in
            DogRowView(dog: dog, onTap: {
                router.navigateTo(.dogDetails(dog))
            }, onFavoriteTapped: {
                viewModel.removeFromFavorite(dog)
            })
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
    }
    
    private var toolBarMenu: some View {
        Menu {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Button {
                    selectedFilter = option
                } label: {
                    Label(option.rawValue, systemImage: selectedFilter == option ? "checkmark" : "")
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .imageScale(.large)
                .tint(Color.AppColors.primary)
        }
    }
}

extension DogsListView {
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case favorite = "Favorite"
    }
}

#Preview {
    NavigationStack {
        DogsListView()
            .environment(SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>())
    }
}
