//
//  SignInFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 04.10.2025.
//

import Testing
import ComposableArchitecture
@testable import NiceDemo_SwiftUI

@MainActor
struct SignInFeatureTests {
    // Shared dependencies
    let userCredentialsStorage = MockUserCredentialsUpdating()
    let connectivityService = MockPhoneSignInConnectivityService()
    
    @Test("Trying to sign in with empty credentials")
    func signButtonTapWithEmptyCredentials() async {
        // given
        let store = TestStore(initialState: SignInFeature.State()) {
            SignInFeature()
        } withDependencies: {
            $0.userCredentialsUpdateStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
        }
        // when
        await store.send(.signButtonTap)
        // then
        await store.receive(\.handleValidation) {
            $0.validationError = Validator.ValidationError.valueIsEmpty("Email")
            $0.showErrorAlert = true
        }
        #expect(connectivityService.sendAuthCalled == 0)
        #expect(connectivityService.flag == nil)
        #expect(userCredentialsStorage.isUserAuthenticated == false)
    }
    
    @Test("Trying to sign in with wrong password")
    func signButtonTapWithWrongPassword() async {
        // given
        let store = TestStore(initialState: SignInFeature.State(email: "wrong@example.com", password: "1111")) {
            SignInFeature()
        } withDependencies: {
            $0.userCredentialsUpdateStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
        }
        // when
        await store.send(.signButtonTap)
        // then
        await store.receive(\.handleValidation) {
            $0.validationError = Validator.ValidationError.passwordLengthIsWrong
            $0.showErrorAlert = true
        }
        #expect(connectivityService.sendAuthCalled == 0)
        #expect(connectivityService.flag == nil)
        #expect(userCredentialsStorage.isUserAuthenticated == false)
    }
    
    @Test("Trying to sign in with wrong email")
    func signButtonTapWithWrongEmail() async {
        // given
        let store = TestStore(initialState: SignInFeature.State(email: "wrong@example", password: "11111111")) {
            SignInFeature()
        } withDependencies: {
            $0.userCredentialsUpdateStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
        }
        // when
        await store.send(.signButtonTap)
        // then
        await store.receive(\.handleValidation) {
            $0.validationError = Validator.ValidationError.emailFormatIsWrong
            $0.showErrorAlert = true
        }
        #expect(connectivityService.sendAuthCalled == 0)
        #expect(connectivityService.flag == nil)
        #expect(userCredentialsStorage.isUserAuthenticated == false)
    }
    
    @Test("Trying to sign in with correct credentials")
    func signButtonTapWithCorrectCredentials() async {
        // given
        let store = TestStore(initialState: SignInFeature.State(email: "correct@example.com", password: "11111111")) {
            SignInFeature()
        } withDependencies: {
            $0.userCredentialsUpdateStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
        }
        // when
        await store.send(.signButtonTap)
        // then
        await store.receive(\.handleValidation)
        await store.receive(\.successfulSignIn) {
            $0.shouldDismissKeyboard = true
            $0.shouldShowDogsList = true
        }
        #expect(connectivityService.sendAuthCalled == 1)
        #expect(connectivityService.flag == true)
        #expect(userCredentialsStorage.isUserAuthenticated == true)
    }
    
    @Test("Tapping of forgotPassword button")
    func forgotPasswordButtonTap() async {
        // given
        let store = TestStore(initialState: SignInFeature.State()) {
            SignInFeature()
        } withDependencies: {
            $0.userCredentialsUpdateStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
        }
        // when
        await store.send(.forgotPasswordButtonTap) {
            $0.shouldDismissKeyboard = true
            $0.shouldShowForgotPassword = true
        }
        // then
        #expect(connectivityService.sendAuthCalled == 0)
        #expect(connectivityService.flag == nil)
        #expect(userCredentialsStorage.isUserAuthenticated == false)
    }
}
