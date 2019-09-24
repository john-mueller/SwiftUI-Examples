import SwiftUI

struct VSliderDemo: View {
    @ObservedObject var model = VSliderDemoModel()

    var body: some View {
        VStack {
            HStack {
                GeometryReader { geometry in
                    VStack{
                        HStack {
                            Text("Range")
                                .frame(width: geometry.size.width * 0.4)
                            Picker(selection: self.$model.selectedRange, label: Text("Range")) {
                                Text("0...1").tag(0)
                                Text("-3...17").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        HStack {
                            Text("Step")
                                .frame(width: geometry.size.width * 0.4)
                            Picker("Step", selection: self.$model.selectedStep) {
                                Text("None").tag(0)
                                Text("5").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                }
                VStack {
                    Text(String(format: "%2.2f", model.sliderValue as Double))
                        .font(Font.body.monospacedDigit())
                    VSlider(value: $model.sliderValue,
                            in: model.initialRange,
                            step: model.initialStep,
                            onEditingChanged: { print($0 ? "Moving Slider" : "Stopped moving Slider") })
                }
            }
            .frame(height: 200)
            Slider(value: $model.sliderValue,
                   in: model.initialRange,
                   step: model.initialStep ?? 0.0001,
                   onEditingChanged: { print($0 ? "Moving Slider" : "Stopped moving Slider") })

            Spacer()

            HStack {
                ForEach(model.levels.indices, id: \.self) { index in
                    VStack {
                        Text(String(format: "%1.1f", self.model.levels[index] as Double))
                            .font(Font.body.monospacedDigit())
                        VSlider(value: self.$model.levels[index], in: 0...11)
                    }
                }
            }

        }.padding()
    }
}

class VSliderDemoModel: ObservableObject {
    @Published var sliderValue: Double = 0
    @Published var selectedRange: Int = 0 {
        willSet {
            if newValue == 0 {
                sliderValue = max(min(sliderValue, 1), 0)
                selectedStep = 0
            }
        }
    }
    @Published var selectedStep: Int = 0 {
        willSet {
            if newValue == 1 {
                selectedRange = 1
            }
        }
    }
    @Published var levels: [Double] = Array(repeating: 0, count: 6)

    var initialRange: ClosedRange<Double> {
        if selectedRange == 0 {
            return 0...1
        } else {
            return -3...17
        }
    }

    var initialStep: Double.Stride? {
        if selectedStep == 0 {
            return nil
        } else {
            return 5
        }
    }
}
