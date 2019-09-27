import SwiftUI

struct FlowLayoutDemo: View {
    @ObservedObject var model = FlowLayoutModel(string: .gettysburgShort)
    @State private var padding: CGFloat = 0

    var body: some View {
        VStack {
            // Textfield to test dynamically entering text
            TextField("Enter some text", text: $model.string)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            // Buttons to load empty, short, and long texts into model
            HStack(spacing: 25) {
                Button("Clear") { self.model.string = ""}
                .padding(5).overlay(Capsule().stroke(Color.blue))
                Button("Short text") { self.model.string = .gettysburgShort}
                .padding(5).overlay(Capsule().stroke(Color.blue))
                Button("Long text") { self.model.string = .gettysburg}
                .padding(5).overlay(Capsule().stroke(Color.blue))
            }
            // Slider changes width of FlowLayout view
            Slider(value: $padding, in: 0...100, step: 1)
            HStack(spacing: 0) {
                Rectangle().fill(Color.blue.opacity(0.3)).frame(width: padding)
                FlowLayout(model: model)
                Rectangle().fill(Color.blue.opacity(0.3)).frame(width: padding)
            }
        }
        .padding()
    }
}
