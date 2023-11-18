//
//  SleeptimeCalculatorView.swift
//

import SwiftUI

struct SleeptimeCalculatorView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("When do you want to wake up?")
                    .font(.headline)

                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()


                Text("Desired amount of sleep")
                    .font(.headline)

                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.5)

                coffeeIntakeRow()
                    .alert(alertTitle, isPresented: $showingAlert) {
                        Button("OK") { }
                    } message: {
                        Text(alertMessage)
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
            Button {
                if let output = NeuralManager.shared.calculateBedtime(
                    wakeUpTime: wakeUp,
                    sleepAmount: sleepAmount,
                    coffeeAmount: coffeeAmount,
                    userAge: Int(settingsViewModel.userAge) ?? 15
                ) {
                    alertTitle = "HGDSA"
                    alertMessage = output
                    showingAlert.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: systemImages.checkmark)

                    Text("Check")
                }
                .padding()
                .foregroundColor(.white)
                .hCenter()
                .background(.black)
                .cornerRadius(10)
            }
            .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
            .padding(.horizontal)
        }
    }

    // MARK: - View Builders

    @ViewBuilder func coffeeIntakeRow() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Daily coffee intake")
                .font(.headline)

            HStack {
                ForEach(1..<6) { index in
                    let isSelected = index <= coffeeAmount
                    let appendingString = isSelected ? ".fill" : ""

                    Image(systemName: (systemImages.cupOfCoffee + appendingString))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .scaleEffect(isSelected ? 1.1 : 1)
                        .animation(.smooth, value: coffeeAmount)
                        .onTapGesture {
                            if index == coffeeAmount {
                                coffeeAmount = 0
                            } else {
                                coffeeAmount = index
                            }
                        }
                }
            }
        }
        .hLeading()
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
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeManager())
}
