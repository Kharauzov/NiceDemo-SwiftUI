//
//  DogCardView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI

struct DogCardView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    var hero: Namespace.ID?
    @Namespace private var defaultNamespace
    private let mode: ViewMode
    private var selectedImageUrl: String?
    private var selectedImage: UIImage?
    private var shadowColor: Color {
        mode == .main ? Color.AppColors.primary.opacity(0.75) : .clear
    }
    var onClose: (() -> Void)?
    
    init(dog: Dog, mode: ViewMode, hero: Namespace.ID? = nil, selectedImage: UIImage? = nil, onClose: (() -> Void)? = nil) {
        self.mode = mode
        self.onClose = onClose
        self.hero = hero
        switch mode {
        case .fromGallery(let string):
            selectedImageUrl = string
        default: break
        }
        self.selectedImage = selectedImage
        let viewModel = ViewModel(dog: dog, networkService: DogsNetworkService())
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
            let cardHeight = mode == .main ? nil : screenHeight / 1.5
            ZStack {
                if mode != .main {
                    shadowDismissButton
                }
                VStack {
                    imageView
                    Spacer()
                    if mode == .main {
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
        .onAppear {
            switch mode {
            case .main:
                viewModel.loadRandomImage()
            case .fromGallery(let url):
                if let selectedImage {
                    viewModel.loadedImage = selectedImage
                } else {
                    viewModel.loadImage(url: url)
                }
            }
        }
        .alert("Image saved to gallery!", isPresented: $viewModel.showSaveConfirmAlert) {
            Button("Okay", role: .cancel) { }
        }
        .alert("Can't save image to gallery. Access denied.", isPresented: $viewModel.showDeniedGalleryAlert) {
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
                    if let image = viewModel.loadedImage {
                        Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .scaleEffect(scale)
                                .offset(offset)
                                .gesture(
                                    SimultaneousGesture(
                                    MagnifyGesture()
                                        .onChanged { value in
                                            scale = max(lastScale * value.magnification, 1)
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            offset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                                        }
                                        .onEnded { _ in
                                            lastOffset = offset
                                        }
                                    )
                                )
                                .animation(.easeInOut(duration: 0.3), value: scale)
                                .animation(.easeInOut(duration: 0.3), value: offset)
                    } else {
                        if viewModel.loading {
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
        .matchedGeometryEffect(id: DogDetailsView.AnimationGeometryEffect.cardImage(selectedImageUrl ?? "").effectId, in: hero ?? defaultNamespace)
        .padding(.bottom, GridLayout.commonSpace)
        .onTapGesture(count: 2, perform: {
            resetImagePositionAndScale()
        })
    }
    
    @ViewBuilder private var subbreedsView: some View {
        if let subbreeds = viewModel.dog.subbreeds, subbreeds.count > 0 {
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
                id: DogDetailsView.AnimationGeometryEffect.cardContainer(selectedImageUrl ?? "").effectId,
                in: hero ?? defaultNamespace
            )
    }
    
    private var nextImageButton: some View {
        HStack(spacing: GridLayout.doubleRegularSpace) {
            if mode == .main {
                Button(action: {
                    resetImagePositionAndScale()
                    viewModel.loadRandomImage()
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
                viewModel.saveImageToGallery()
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
            id: DogDetailsView.AnimationGeometryEffect.cardControls(selectedImageUrl ?? "").effectId,
            in: hero ?? defaultNamespace
        )
    }
    
    private func resetImagePositionAndScale() {
        offset = .zero
        lastOffset = offset
        scale = 1
        lastScale = scale
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
    DogCardView(dog: Dog(breed: "affenpinscher", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false), mode: .fromGallery("https://images.dog.ceo/breeds/hound-blood/n02088466_6901.jpg"))
}

#Preview {
    DogCardView(dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false), mode: .main)
}
