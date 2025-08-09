//
//  DogDetailsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI

struct DogDetailsView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
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
        .padding(EdgeInsets(top: GridLayout.fourthRegularSpace, leading: GridLayout.doubleRegularSpace, bottom: GridLayout.fourthRegularSpace, trailing: GridLayout.doubleRegularSpace))
        .shadow(color: Color.AppColors.primary.opacity(0.75), radius: 15, x: 0, y: 5)
        .onAppear {
            viewModel.loadRandomImage()
        }
        .alert("Image saved to gallery!", isPresented: $viewModel.showSaveConfirmAlert) {
            Button("Okay", role: .cancel) { }
        }
    }
    
    private var imageView: some View {
        VStack {
            Rectangle()
                .overlay {
                    if let image = viewModel.loadedImage {
                        Image(uiImage: image)
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
    
    private var nextImageButton: some View {
        HStack(spacing: GridLayout.doubleRegularSpace) {
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
    }
    
    private func resetImagePositionAndScale() {
        offset = .zero
        lastOffset = offset
        scale = 1
        lastScale = scale
    }
}


#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false))
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: [], isFavorite: false))
    }
}
