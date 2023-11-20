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

    private var userAge: Int {
        Int(settingsViewModel.userAge) ?? 10
    }

    // MARK: - Body

    var body: some View {
        VStack {
            Spacer()
            
            wakeUpTimeRow()

            Divider()

            desiredAmountOfSleepRow()

            if userAge > 10 {
                Divider()

                coffeeIntakeRow()
            }

            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                nextButton()
                    
                Button {
                    if let url = URL(string: "https://developer.apple.com/machine-learning/core-ml/") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                } label: {
                    Label("Result will be calculated by Neural Network", systemImage: "network")
                        .font(.caption2)
                        .foregroundColor(themeManager.selectedTheme.accentColor.opacity(0.7))
                        .padding(.top, 3)
                }
                .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
            }
        }
        .alert(sleeptimeCalculatorViewModel.alertTitle, isPresented: $sleeptimeCalculatorViewModel.showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(sleeptimeCalculatorViewModel.alertMessage)
        }
        .onDisappear {
            sleeptimeCalculatorViewModel.reset()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func wakeUpTimeRow() -> some View {
        VStack {
            Text("When do you want to wake up?")
                .font(.headline)

            DatePicker(
                "",
                selection: $sleeptimeCalculatorViewModel.selectedWakeUpTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }

    @ViewBuilder func desiredAmountOfSleepRow() -> some View {
        VStack {
            Text("Desired amount of sleep")
                .font(.headline)

            Stepper(
                "\(sleeptimeCalculatorViewModel.sleepAmount.formatted()) hours",
                value: $sleeptimeCalculatorViewModel.sleepAmount,
                in: 4...12, 
                step: 0.5
            )
        }
    }

    @ViewBuilder func coffeeIntakeRow() -> some View {
        VStack {
            Text("Daily coffee intake")
                .font(.headline)

            HStack(spacing: 20) {
                ForEach(1..<7) { index in
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
                        .hCenter()
                }
            }
        }
        .hLeading()
    }

    @ViewBuilder func nextButton() -> some View {
        Button {
            let components = Calendar.current.dateComponents(
                [.hour, .minute],
                from: sleeptimeCalculatorViewModel.selectedWakeUpTime
            )

            let hour = components.hour ?? 0
            let minute = components.minute ?? 0

            if let output = NeuralManager.shared.calculateBedtime(
                hour: hour,
                minute: minute,
                sleepAmount: sleeptimeCalculatorViewModel.sleepAmount,
                coffeeAmount: self.userAge > 10 ? sleeptimeCalculatorViewModel.coffeeAmount : 0,
                userAge: self.userAge
            ) {
                sleeptimeCalculatorViewModel.alertTitle = "Sleeptime:"
                sleeptimeCalculatorViewModel.alertMessage = output
                sleeptimeCalculatorViewModel.showingAlert.toggle()
            }
        } label: {
            HStack {
                Label(
                    "Check",
                    systemImage: systemImages.checkmark
                )
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
