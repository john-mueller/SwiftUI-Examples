import SwiftUI

struct VSliderDemo: View {
    @ObservedObject var model = VSliderDemoModel()

    var body: some View {
        VStack {
            HStack {
                VStack{
                    Picker(selection: $model.selectedRange, label: Text("Range")) {
                    Text("0...1").tag(0)
                    Text("-3...17").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                    Picker(selection: $model.selectedStep, label: Text("Step")) {
                    Text("None").tag(0)
                    Text("5").tag(1)
                }
                    .pickerStyle(SegmentedPickerStyle())
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
        }.padding([.leading, .trailing])
    }
}

class VSliderDemoModel: ObservableObject {
    private var lock = false

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
