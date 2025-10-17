//
//  ForgotPasswordFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Testing
import ComposableArchitecture
@testable import NiceDemo_SwiftUI

@MainActor
struct ForgotPasswordFeatureTests {
    
    @Test
    func dismissTap() async {
        // given
        let store = TestStore(initialState: ForgotPasswordFeature.State()) {
            ForgotPasswordFeature()
        }
        
        // when
        await store.send(.dismissTap) {
            $0.shouldDismiss = true
        }
        
        // then
        #expect(store.state.shouldDismiss == true)
    }
    
    @Test
    func submitButtonTapWithValidEmail() async {
        // given
        let store = TestStore(initialState: ForgotPasswordFeature.State(email: "test@example.com")) {
            ForgotPasswordFeature()
        }
        
        // when
        await store.send(.submitButtonTap("test@example.com"))
        await store.receive(\.handleValidation) {
            $0.showSuccessAlert = true
        }
        
        // then
        #expect(store.state.showSuccessAlert == true)
        #expect(store.state.showErrorAlert == false)
    }
    
    @Test
    func submitButtonTapWithInvalidEmail() async {
        // given
        let store = TestStore(initialState: ForgotPasswordFeature.State(email: "invalid-email")) {
            ForgotPasswordFeature()
        }
        
        // when
        await store.send(.submitButtonTap("invalid-email"))
        await store.receive(\.handleValidation) {
            $0.validationError = Validator.ValidationError.emailFormatIsWrong
            $0.showErrorAlert = true
        }
        
        // then
        #expect(store.state.showErrorAlert == true)
        #expect(store.state.showSuccessAlert == false)
        #expect(store.state.validationError == Validator.ValidationError.emailFormatIsWrong)
    }
    
    @Test
    func submitButtonTapWithEmptyEmail() async {
        // given
        let store = TestStore(initialState: ForgotPasswordFeature.State(email: "")) {
            ForgotPasswordFeature()
        }
        
        // when
        await store.send(.submitButtonTap(""))
        await store.receive(\.handleValidation) {
            $0.validationError = Validator.ValidationError.valueIsEmpty("Email")
            $0.showErrorAlert = true
        }
        
        // then
        #expect(store.state.showErrorAlert == true)
        #expect(store.state.showSuccessAlert == false)
        #expect(store.state.validationError == Validator.ValidationError.valueIsEmpty("Email"))
    }
}
