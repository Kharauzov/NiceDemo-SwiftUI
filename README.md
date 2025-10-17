## Overview
This project was built for demonstration purpose using SwiftUI. It doesn't have or provide any commercial usage. Auth flow only imitates user's authentication/actions.
App uses [Dog-api](https://dog.ceo/dog-api/) for backend. It is free and amazing 🐕

## What’s inside
App’s routing inside iOS version contains of 2 flows: 

* Auth: SignIn -> ForgotPassword 
* Dogs: DogsList -> DogDetails -> DogCard + DogGallery

Every screen built on **The Composable Architecture**, using AppRouter dependency for clean and manageble navigation.
Reducers were covered by unit tests as well.

**UPDATE**

Recently I completed full migration of architecture to TCA. Previous progress for MVVM architecture can be found at corresponding branch [feature/MVVM](https://github.com/Kharauzov/NiceDemo-SwiftUI/tree/feature/MVVM)

## Features
* Watch version with sync mechanism for auth state and favorite breeds
* Custom segmented control triggering animated sliding of inner screens
* Custom hero transition from gallery into card
* Unit Tests for business logic 
* Local storage for keeping favorite dog breeds
* Zooming dog photo
* Saving dog photo to gallery

## User Interfaces

<p align="left">
<img src="https://github.com/Kharauzov/NiceDemo-SwiftUI/blob/main/overview_with_watch.png" width="500px" height="1700px"/>
</p>

## Feedback
If you have any questions or suggestions - feel free to open an issue right inside this project.

## License
NiceDemo and all its classes are available under the MIT license. See the LICENSE file for more info.
