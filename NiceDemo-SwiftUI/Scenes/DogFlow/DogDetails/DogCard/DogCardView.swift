//
//  DogCardView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct DogCardView: View {
    @Environment(\.dismiss) private var dismiss
    var hero: Namespace.ID?
    @Namespace private var defaultNamespace
    private var shadowColor: Color {
        store.mode == .main ? Color.AppColors.primary.opacity(0.75) : .clear
    }
    var onClose: (() -> Void)?

    @Bindable var store: StoreOf<DogCardFeature>

    init(store: StoreOf<DogCardFeature>, hero: Namespace.ID? = nil, onClose: (() -> Void)? = nil) {
        _store = Bindable(wrappedValue: store)
        self.hero = hero
        self.onClose = onClose
    }

    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let cardHeight = store.mode == .main ? nil : screenHeight / 1.5
        ZStack {
            if store.mode != .main {
                shadowDismissButton
            }
            VStack {
                imageView
                Spacer()
                if store.mode == .main {
                    subbreedsView
                }
                nextImageButton
            }
            .frame(height: cardHeight)
            .background(cardContainerView)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: shadowColor, radius: 8, x: 0, y: 0)
            .padding(edgeInsets)
        }
        .task {
            await store.send(.onAppear).finish()
        }
        .alert("Image saved to gallery!", isPresented: $store.showSaveConfirmAlert) {
            Button("Okay", role: .cancel) { }
        }
        .alert("Can't save image to gallery. Access denied.", isPresented: $store.showDeniedGalleryAlert) {
            Button("Okay", role: .cancel) { }
        }
    }

    private var shadowDismissButton: some View {
        VStack {
            Button {
                onClose?()
            } label: {
                Rectangle()
                    .fill(Color.AppColors.black.opacity(0.7))
            }
        }
        .buttonStyle(.plain)
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.horizontal)
        .edgesIgnoringSafeArea(.vertical)
    }

    private var imageView: some View {
        VStack {
            Rectangle()
                .overlay {
                    if let imageData = store.loadedImageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(store.scale)
                            .offset(store.offset)
                            .gesture(
                                SimultaneousGesture(
                                    MagnifyGesture()
                                        .onChanged { value in
                                            let newScale = max(store.lastScale * value.magnification, 1)
                                            store.send(.scaleChanged(newScale))
                                        }
                                        .onEnded { _ in
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                _ = store.send(.scaleEnded)
                                            }
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            let newOffset = CGSize(
                                                width: store.lastOffset.width + value.translation.width,
                                                height: store.lastOffset.height + value.translation.height
                                            )
                                            store.send(.offsetChanged(newOffset))
                                        }
                                        .onEnded { _ in
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                _ = store.send(.offsetEnded)
                                            }
                                        }
                                )
                            )
                    } else {
                        if store.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.large)
                                .tint(Color.AppColors.white)
                        }
                    }
                }
                .foregroundStyle(Color.AppColors.primary.opacity(0.5))
                .clipShape(.rect(
                    topLeadingRadius: 14,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 14
                ))
        }
        // photoTile itself (a source to morph to)
        .matchedGeometryEffect(
            id: DogDetailsView.AnimationGeometryEffect.cardImage(store.selectedImageUrl ?? "").effectId,
            in: hero ?? defaultNamespace
        )
        .padding(.bottom, GridLayout.commonSpace)
        .onTapGesture(count: 2, perform: {
            resetImagePositionAndScale()
        })
    }

    @ViewBuilder private var subbreedsView: some View {
        if let subbreeds = store.dog.subbreeds, subbreeds.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(subbreeds, id: \.self) { breed in
                        Text(breed)
                            .font(.paperlogy(.semibold, fontSize: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.AppColors.black, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        } else {
            Text("No subbreeds")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }

    private var cardContainerView: some View {
        // whole card container (a source to morph to)
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.AppColors.white)
            .matchedGeometryEffect(
                id: DogDetailsView.AnimationGeometryEffect.cardContainer(store.selectedImageUrl ?? "").effectId,
                in: hero ?? defaultNamespace
            )
    }

    private var nextImageButton: some View {
        HStack(spacing: GridLayout.doubleRegularSpace) {
            if store.mode == .main {
                Button(action: {
                    resetImagePositionAndScale()
                    store.send(.loadRandomImage)
                }) {
                    Text("Next")
                        .font(.paperlogy(.semibold, fontSize: 22))
                        .foregroundColor(Color.AppColors.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.AppColors.primary)
                        .cornerRadius(10)
                }
            }
            Button(action: {
                resetImagePositionAndScale()
                store.send(.saveTapped)
            }) {
                Text("Save")
                    .font(.paperlogy(.semibold, fontSize: 22))
                    .foregroundColor(Color.AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.AppColors.primary)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        // bottom button (morphs from placeholder in grid)
        .matchedGeometryEffect(
            id: DogDetailsView.AnimationGeometryEffect.cardControls(store.selectedImageUrl ?? "").effectId,
            in: hero ?? defaultNamespace
        )
    }

    private func resetImagePositionAndScale() {
        withAnimation(.easeInOut(duration: 0.3)) {
            _ = store.send(.resetImagePositionAndScale)
        }
    }
}

extension DogCardView {
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: GridLayout.doubleRegularSpace,
                   leading: GridLayout.doubleRegularSpace,
                   bottom: GridLayout.fourthRegularSpace,
                   trailing: GridLayout.doubleRegularSpace)
    }

    enum ViewMode: Equatable {
        case main
        case fromGallery(String)
    }
}

#Preview {
    DogCardView(
        store: Store(initialState: DogCardFeature.State(
            dog: Dog(breed: "affenpinscher", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false),
            mode: .fromGallery("https://images.dog.ceo/breeds/hound-blood/n02088466_6901.jpg"),
            isLoading: true,
            loadedImageData: nil,
            showSaveConfirmAlert: false,
            showDeniedGalleryAlert: false,
            selectedImageUrl: "https://images.dog.ceo/breeds/hound-blood/n02088466_6901.jpg"
        )) {
            DogCardFeature()
        }
    )
}

#Preview {
    DogCardView(
        store: Store(initialState: DogCardFeature.State(
            dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false),
            mode: .main
        )) {
            DogCardFeature()
        }
    )
}

