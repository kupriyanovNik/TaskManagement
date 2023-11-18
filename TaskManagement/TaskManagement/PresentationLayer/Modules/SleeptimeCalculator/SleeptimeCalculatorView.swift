//
//  SleeptimeCalculatorView.swift
//

import SwiftUI

struct SleeptimeCalculatorView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var sleeptimeCalculatorViewModel: SleeptimeCalculatorViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("When do you want to wake up?")
                    .font(.headline)

                DatePicker(
                    "",
                    selection: $sleeptimeCalculatorViewModel.wakeUp,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()


                Text("Desired amount of sleep")
                    .font(.headline)

                Stepper("\(sleeptimeCalculatorViewModel.sleepAmount.formatted()) hours", value: $sleeptimeCalculatorViewModel.sleepAmount, in: 4...12, step: 0.5)

                coffeeIntakeRow()
                    .alert(sleeptimeCalculatorViewModel.alertTitle, isPresented: $sleeptimeCalculatorViewModel.showingAlert) {
                        Button("OK") { }
                    } message: {
                        Text(sleeptimeCalculatorViewModel.alertMessage)
                    }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                checkButton()

                Label("Result calculated by Neural Network", systemImage: "network")
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .padding(.top, 3)
                    .onTapGesture {
                        if let url = URL(string: "https://developer.apple.com/machine-learning/core-ml/") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
            }
        }
    }

    // MARK: - View Builders

    @ViewBuilder func coffeeIntakeRow() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Daily coffee intake")
                .font(.headline)

            HStack(spacing: 20) {
                ForEach(1..<6) { index in
                    let isSelected = index <= sleeptimeCalculatorViewModel.coffeeAmount
                    let appendingString = isSelected ? ".fill" : ""

                    Image(systemName: (systemImages.cupOfCoffee + appendingString))
                        .resizable()
                        .scaledToFit()
                        .animation(
                            .smooth,
                            value: sleeptimeCalculatorViewModel.coffeeAmount
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(isSelected ? 1.2 : 1)
                        .animation(
                            .smooth(extraBounce: 0.7),
                            value: sleeptimeCalculatorViewModel.coffeeAmount
                        )
                        .onTapGesture {
                            if index == sleeptimeCalculatorViewModel.coffeeAmount {
                                sleeptimeCalculatorViewModel.coffeeAmount = 0
                            } else {
                                sleeptimeCalculatorViewModel.coffeeAmount = index
                            }
                        }
                }
            }
        }
        .hLeading()
    }

    @ViewBuilder func checkButton() -> some View {
        Button {
            if let output = NeuralManager.shared.calculateBedtime(
                wakeUpTime: sleeptimeCalculatorViewModel.wakeUp,
                sleepAmount: sleeptimeCalculatorViewModel.sleepAmount,
                coffeeAmount: sleeptimeCalculatorViewModel.coffeeAmount,
                userAge: Int(settingsViewModel.userAge) ?? 15
            ) {
                sleeptimeCalculatorViewModel.alertTitle = "HGDSA"
                sleeptimeCalculatorViewModel.alertMessage = output
                sleeptimeCalculatorViewModel.showingAlert.toggle()
            }
        } label: {
            HStack {
                Label("Check", systemImage: systemImages.checkmark)
            }
            .padding()
            .foregroundColor(.white)
            .hCenter()
            .background(themeManager.selectedTheme.pageTitleColor)
            .cornerRadius(10)
        }
        .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
        .padding(.horizontal)
    }

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
            }

            Text("Sleeptime")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }

}

#Preview {
    SleeptimeCalculatorView()
        .environmentObject(SleeptimeCalculatorViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeManager())
}
