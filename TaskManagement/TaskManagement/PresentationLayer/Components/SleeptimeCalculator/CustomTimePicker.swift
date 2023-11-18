//
//  CustomTimePicker.swift
//

import SwiftUI
import Foundation

struct CustomTimePicker: View {

    @Binding var hour: Int
    @Binding var minutes: Int

    @State var changeToMin = false

    @State var angle: Double = 0

    var body: some View {
        VStack {

            HStack {
                Spacer()

                HStack(spacing: 0) {
                    Text("\(hour < 10 ? "0" : "")\(hour)")
                        .font(.largeTitle)
                        .fontWeight(changeToMin ? .light : .bold)
                        .animation(.none, value: changeToMin)
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
                        .animation(.none, value: changeToMin)
                        .onTapGesture {
                            withAnimation {
                                self.angle = Double(self.minutes * 6)

                                changeToMin = true
                            }
                        }
                }
            }
            .padding()
            .background(.ultraThinMaterial)

            GeometryReader { reader in
                let width = reader.frame(in: .global).width / 2

                ZStack {

                    ForEach(1...12, id: \.self) { index in
                        VStack {
                            Text("\(changeToMin ? index * 5 : index)")
                                .font(.title3)
                                .foregroundColor(.black)
                                .offset(y: -width + 50)
                                .rotationEffect(.degrees(Double(index) * 30))
                                .onTapGesture {
                                    withAnimation {
                                        if !changeToMin {
                                            self.hour = index
                                        } else {
                                            self.minutes = index * 5
                                        }

                                        self.angle = Double(self.minutes * 6)
                                        self.changeToMin = true
                                    }
                                }
                        }
                    }

                    Circle()
                        .fill(.blue.opacity(0.5))
                        .frame(width: 40, height: 40)
                        .offset(x: width - 50)
                        .rotationEffect(.degrees(angle))
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged(onChanged)
                                .onEnded(onEnded)
                        )
                        .rotationEffect(.degrees(-90))

                    Circle()
                        .fill(.blue)
                        .frame(width: 10, height: 10)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.blue.opacity(0.4))
                                .frame(width: 2, height: width / 2)
                        }
                        .rotationEffect(.degrees(angle))

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            }
            .frame(height: 300)

        }
        .frame(width: UIScreen.main.bounds.width - 120)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .onAppear {
            self.angle = Double(self.hour * 30)
        }
    }

    func onChanged(value: DragGesture.Value) {
        let radians = atan2(value.location.y - 20, value.location.x - 20)

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

