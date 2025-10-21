//
//  DogsListView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter
import ComposableArchitecture

struct DogsListView: View {
    @Bindable var store: StoreOf<DogsListFeature>
    @Environment(SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>.self) private var router
    private let navigationTitle = NavigationTitle.listOfDogs
    
    var body: some View {
        Group {
            if store.isLoading {
                loadingView
            } else {
                dogsListView
            }
        }
        .listStyle(.plain)
#if os(watchOS)
        .navigationTitle(navigationTitle.rawValue)
        .toolbarTitleDisplayMode(.large)
#endif
#if os(iOS)
        .inlineNavigationTitle(navigationTitle)
        .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolBarMenu
            }
        }
#endif
        .task {
            if store.shouldLoadData {
                // adding delay due to imitation of heavy request
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.store.send(.loadDogsList)
                }
            } else {
                store.send(.reloadData)
            }
            store.send(.onAppear)
        }
        .onChange(of: store.isLoading) { _, _ in
            withAnimation(.spring()) { }
        }
    }
    
    private var loadingView: some View {
        List {
            ForEach((1...20), id: \.self) { _ in
                LoadingDogRowView()
#if os(iOS)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
#endif
                    .frame(height: 60)
                    .onTapGesture {}
            }
        }
    }
    
    @ViewBuilder private var dogsListView: some View {
        if store.filteredDogs.count > 0 {
            List(store.filteredDogs) { dog in
                DogRowView(dog: dog, onTap: {
                    router.navigateTo(.dogDetails(dog))
                }, onFavoriteTapped: {
                    store.send(.removeFromFavorite(dog))
                })
#if os(iOS)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
#endif
            }
        } else {
            VStack {
                Spacer()
                Text("No results")
                    .font(.paperlogy(.medium, fontSize: 20))
                    .tint(Color.AppColors.black)
                Spacer()
            }
        }
    }
#if os(iOS)
    private var toolBarMenu: some View {
        Menu {
            ForEach(DogsListFilter.allCases, id: \.self) { option in
                Button {
                    store.send(.selectFilter(option))
                } label: {
                    Label(option.rawValue, systemImage: store.selectedFilter == option ? "checkmark" : "")
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .imageScale(.large)
                .tint(Color.AppColors.primary)
        }
    }
#endif
}

#Preview {
    NavigationStack {
        DogsListView(store: Store(initialState: DogsListFeature.State()) {
            DogsListFeature()
        })
        .environment(SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>())
    }
}
