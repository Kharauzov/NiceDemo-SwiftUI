//
//  DogsListFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.10.2025.
//

import ComposableArchitecture

@Reducer
struct DogsListFeature {
    @Dependency(\.dogsListNetwork) var networkService
    @Dependency(\.dogsListFavoriteStorage) var favoriteStorage
    @Dependency(\.favoriteBreedsSyncService) var favoriteBreedsSyncService
    
    enum CancelID {
        case loadDogsList
        case favoriteBreedsUpdates
    }
    
    @ObservableState
    struct State: Equatable {
        var dogs = [Dog]()
        var isLoading = true
        var shouldLoadData = true
        var searchText = ""
        var selectedFilter: DogsListFilter = .all
        
        var filteredDogs: [Dog] {
            getFilteredDogs(dogs, filterOption: selectedFilter, searchText: searchText)
        }
        
        private func getFilteredDogs(_ dogs: [Dog], filterOption: DogsListFilter, searchText: String) -> [Dog] {
            let sortedDogs: [Dog] = filterOption == .all ? dogs : dogs.filter { $0.isFavorite }
            if searchText.isEmpty {
                return sortedDogs
            }
            return sortedDogs.filter {
                $0.breed.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadDogsList
        case handleFetchedDogsList(Result<GetAllDogsServerResponse, Error>)
        case reloadData
        case removeFromFavorite(Dog)
        case selectFilter(DogsListFilter)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return .run { send in
                    for await _ in favoriteBreedsSyncService.favoriteBreedsUpdateFromPeer {
                        await send(.reloadData)
                    }
                }
                .cancellable(id: CancelID.favoriteBreedsUpdates, cancelInFlight: true)
            case .loadDogsList:
                state.shouldLoadData = false
                state.isLoading = true
                return .run { send in
                    let response = try await networkService.getDogs()
                    await send(.handleFetchedDogsList(.success(response)))
                } catch: { error, send in
                    await send(.handleFetchedDogsList(.failure(error)))
                }
                    .cancellable(id: CancelID.loadDogsList, cancelInFlight: true)
            case .handleFetchedDogsList(.success(let response)):
                handleFetchedData(&state, fetchedDogs: response.formattedData)
                return .none
            case .handleFetchedDogsList(.failure):
                state.isLoading = false
                // handle error if needed
                return .none
            case .reloadData:
                handleFetchedData(&state, fetchedDogs: state.dogs)
                return .none
            case .removeFromFavorite(let dog):
                favoriteStorage.removeFromFavorite(dog)
                favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
                return .send(.reloadData)
            case .selectFilter(let filter):
                state.selectedFilter = filter
                return .none
            }
        }
    }
    
    private func handleFetchedData(_ state: inout DogsListFeature.State, fetchedDogs: [Dog]?) {
        var formattedDogs = [Dog]()
        if let data = fetchedDogs {
            data.forEach { dog in
                let isFavorite = favoriteStorage.favoriteDogBreeds.contains(dog.breed)
                formattedDogs.append(Dog(breed: dog.breed, subbreeds: dog.subbreeds, isFavorite: isFavorite))
            }
            state.dogs = formattedDogs
        } else {
            state.dogs = []
        }
        state.isLoading = false
    }
}
