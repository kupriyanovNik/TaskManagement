//
//  RegistrationView.swift
//

import SwiftUI

struct RegistrationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var settingsViewModel: SettingsViewModel

    @Binding var showNextView: Bool

    @State var isExpanded: Bool = false
    @State var startTyping: Bool = false
    @State var showText: Bool = false

    @FocusState private var isFocusedUsername: Bool
    @FocusState private var isFocusedUserAge: Bool

    // MARK: - Internal Properties

    var dismissAction: () -> ()

    // MARK: - Private Properties

    private let screenSize = UIScreen.main.bounds
    private let strings = Localizable.Onboarding.self

    private var canShowPreviousView: Bool {
        !isFocusedUsername && !isFocusedUserAge
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReaderView(
                isExpanded: $isExpanded,
                startTyping: $startTyping,
                showText: $showText,
                color: .white,
                text: "Далее",
                showNextView: $showNextView,
                canShowPreviousView: canShowPreviousView
            ) {
                isFocusedUsername = false
                isFocusedUserAge = false 
            }

            VStack(spacing: 16) {
                Spacer()

                CustomTextField(
                    inputText: $settingsViewModel.userName,
                    isFocused: _isFocusedUsername,
                    placeHolder: strings.username,
                    strokeColor: .black,
                    shouldExpandVertically: false
                )
                .onTapContinueEditing()

                CustomTextField(
                    inputText: $settingsViewModel.userAge,
                    isFocused: _isFocusedUserAge,
                    placeHolder: strings.userage,
                    strokeColor: .black,
                    shouldExpandVertically: false
                )
                .keyboardType(.numberPad)
                .onTapContinueEditing()

                Spacer()

                Button {
                    dismissAction()
                } label: {
                    Text(strings.login)
                        .padding()
                        .foregroundColor(.white)
                        .hCenter()
                        .background(.black)
                        .cornerRadius(10)
                }
                .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
            .offset(x: isExpanded ? 0 : screenSize.width)
            .opacity(isExpanded ? 1 : 0)
        }
        .animation(.smooth, value: showNextView)
        .ignoresSafeArea()
    }
}

#Preview {
    RegistrationView(
        settingsViewModel: .init(),
        showNextView: .constant(false)
    ) {}
}
