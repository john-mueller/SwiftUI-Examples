import SwiftUI

struct FlowLayout: View {
    @ObservedObject var model: FlowLayoutModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // This is the displayed view
                ScrollView {
                    VStack {
                        ForEach(self.model.flowedWords.indices, id: \.self) { (lineIndex: Int) in
                            HStack(spacing: self.model.spacing) {
                                ForEach(self.model.flowedWords[lineIndex].indices, id: \.self) { (wordIndex: Int) in
                                    Text(self.model.flowedWords[lineIndex][wordIndex])
                                        .lineLimit(1)
                                        .font(.title)
                                        .border(Color.red)
                                }
                            }
                        }
                        // Read width of top level view
                    }.preference(key: ViewWidthKey.self,
                                 value: [ViewWidth(index: 0, width: geometry.size.width)])
                }

                // This is the hidden view for calculating widths
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(self.model.words.indices, id: \.self) { (wordIndex: Int) in
                            Text(self.model.words[wordIndex])
                                .lineLimit(1)
                                .font(.title)
                                .border(Color.red)
                                // Read widths of hidden views
                                .background(WordWidthPreferenceSetter(index: wordIndex))
                        }
                        // Reflow if number or width of hidden views changes
                    }.onPreferenceChange(WordWidthKey.self) { preferences in
                        self.model.reflow(in: geometry, with: preferences)
                    }
                }.opacity(0)
                // Reflow if top level view width changes
            }.onPreferenceChange(ViewWidthKey.self) { _ in
                self.model.reflow(in: geometry)
            }
        }
    }
}
