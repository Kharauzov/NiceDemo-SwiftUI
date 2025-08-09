//
//  DogDetailsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI
import Photos
import UIKit

struct DogDetailsView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showSaveConfirmAlert = false
    private var loadedImage: Image?
    
    init(dog: Dog) {
        let viewModel = ViewModel(dog: dog, networkService: DogsNetworkService(), favoriteStorage: FavoriteDogBreedsStorage())
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            imageView
            Spacer()
            subbreedsView
            nextImageButton
        }
        .navigationTitle(viewModel.dog.breed.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.handleFavoriteButtonTap()
                } label: {
                    Image(viewModel.favoriteButtonImageName)
                        .renderingMode(.template)
                        .tint(Color.AppColors.primary)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.AppColors.primary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.AppColors.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(EdgeInsets(top: GridLayout.trippleRegularSpace, leading: GridLayout.doubleRegularSpace, bottom: GridLayout.trippleRegularSpace, trailing: GridLayout.doubleRegularSpace))
        .shadow(color: Color.AppColors.primary.opacity(0.75), radius: 15, x: 0, y: 5)
        .onAppear {
            viewModel.loadRandomImage()
        }
        .alert("Image saved to gallery!", isPresented: $showSaveConfirmAlert) {
            Button("Okay", role: .cancel) { }
        }
    }
    
    private var imageView: some View {
        VStack {
            Rectangle()
                .overlay {
                    AsyncImage(url: URL(string: viewModel.randomDogImageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill() // ensures the image fills container
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
                    } placeholder: {
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
        .padding(.bottom, GridLayout.commonSpace)
        .onTapGesture(count: 2, perform: {
            resetImagePositionAndScale()
        })
    }
    
    private var subbreedsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.dog.subbreeds ?? [], id: \.self) { breed in
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
        }
        .padding(.bottom, 20)
    }
    
    private var nextImageButton: some View {
        HStack(spacing: GridLayout.commonSpace) {
            Button(action: {
                resetImagePositionAndScale()
                viewModel.loadRandomImage()
            }) {
                Text("Next")
                    .font(.paperlogy(.semibold, fontSize: 22))
                    .foregroundColor(Color.AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.AppColors.primary)
                    .cornerRadius(10)
            }
            Button(action: {
                resetImagePositionAndScale()
//                saveImageToGallery(<#T##image: UIImage##UIImage#>)
            }) {
                Text("Save")
                    .font(.paperlogy(.semibold, fontSize: 22))
                    .foregroundColor(Color.AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.AppColors.primary)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func resetImagePositionAndScale() {
        offset = .zero
        lastOffset = offset
        scale = 1
        lastScale = scale
    }
    
    private func saveImageToGallery(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}


#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false))
    }
}
