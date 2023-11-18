//
//  CustomTimePicker.swift
//

import SwiftUI
import Foundation

struct CustomTimePicker: View {

    // onDisappear: changetomin = false 

    @State var selectedDate: Date = .now

    @State var hour = 12
    @State var minutes = 0

    @State var changeToMin = false
    @State var symbol = "AM"

    @State var angle: Double = 0

    var body: some View {
        VStack {

            HStack {
                Spacer()

                HStack(spacing: 0) {
                    Text("\(hour)")
                        .font(.largeTitle)
                        .fontWeight(changeToMin ? .light : .bold)
                        .onTapGesture {
                            withAnimation {
                                self.angle = Double(self.hour * 30)

                                changeToMin = false
                            }
                        }

                    Text(":")
                        .font(.largeTitle)
                        .fontWeight(.light)

                    Text("\(minutes < 10 ? "0" : "")\(minutes)")
                        .font(.largeTitle)
                        .fontWeight(!changeToMin ? .light : .bold)
                        .onTapGesture {
                            withAnimation {
                                self.angle = Double(self.minutes * 6)

                                changeToMin = true
                            }
                        }
                }

                VStack(spacing: 8) {
                    Text("AM")
                        .font(.title2)
                        .fontWeight(symbol == "AM" ? .bold : .light)
                        .onTapGesture {
                            symbol = "AM"
                        }

                    Text("PM")
                        .font(.title2)
                        .fontWeight(symbol == "PM" ? .bold : .light)
                        .onTapGesture {
                            symbol = "PM"
                        }
                }
                .frame(width: 45)
            }
            .padding()
            .background(.ultraThinMaterial)

            TimePicker(angle: $angle, changeToMin: $changeToMin, hour: $hour, minutes: $minutes)

        }
        .frame(width: UIScreen.main.bounds.width - 120)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

#Preview {
    CustomTimePicker()
}


struct TimePicker: View {

    @Binding var angle: Double
    @Binding var changeToMin: Bool

    @Binding var hour: Int
    @Binding var minutes: Int

    var body: some View {
        GeometryReader { reader in
            let width = reader.frame(in: .global).width / 2

            ZStack {

                Circle()
                    .fill(.blue)
                    .frame(width: 40, height: 40)
                    .offset(x: width - 50)
                    .rotationEffect(.degrees(angle))
                    .gesture(
                        DragGesture()
                            .onChanged(onChanged)
                            .onEnded(onEnded)
                    )
                    .rotationEffect(.degrees(-90))

                ForEach(1...12, id: \.self) { index in
                    VStack {
                        Text("\(changeToMin ? index * 5 : index)")
                            .font(.title3)
                            .foregroundColor(.black)
                            .offset(y: -width + 50)
                            .rotationEffect(.degrees(Double(index) * 30))
                    }
                }

                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 2, height: 10 + width / 2)
                    }
                    .rotationEffect(.degrees(angle))

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        }
        .frame(height: 300)
    }

    func onChanged(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)

        let radians = atan2(vector.dy - 20, vector.dx - 20)

        var angle = radians * 180 / .pi

        if angle < 0 {
            angle = 360 + angle
        }

        if !changeToMin {
            let roundValue = 30 * Int(round(angle / 30))
            self.angle = Double(roundValue)
        } else {
            self.angle = angle
            let progress = self.angle / 360
            self.minutes = Int(progress * 60)
        }
    }

    func onEnded(value: DragGesture.Value) {
        if !changeToMin {
            self.hour = Int(self.angle / 30)

            withAnimation {
                self.angle = Double(self.minutes * 6)
                changeToMin = true
            }
        }
    }

}
