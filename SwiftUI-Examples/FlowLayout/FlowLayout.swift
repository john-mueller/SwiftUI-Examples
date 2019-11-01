import SwiftUI

struct FlowLayout: View {
    @ObservedObject var model: FlowLayoutModel

    var body: some View {
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
                }
                // Read width of top level view
            }.attachViewWidthPreferenceSetter()

            // This is the hidden view for calculating widths
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(self.model.words.indices, id: \.self) { (wordIndex: Int) in
                        Text(self.model.words[wordIndex])
                            .lineLimit(1)
                            .font(.title)
                            .border(Color.red)
                            // Read widths of hidden views
                            .attachWordWidthPreferenceSetter(index: wordIndex)
                    }
                    // Reflow if number or width of hidden views changes
                }.onPreferenceChange(WordWidthKey.self) { preferences in
                    self.model.widths = preferences.sorted(by: \.index).map { $0.width.rounded(.up) }
                    self.model.reflow()
                }
            }.opacity(0)
                // Force hidden views to set preferences on appear, to set initial widths
                .onAppear {
                    self.model.string = self.model.string
            }
            // Reflow if top level view width changes
        }.onPreferenceChange(ViewWidthKey.self) { preferences in
            self.model.viewWidth = min(preferences.first?.width ?? 0, UIScreen.main.bounds.width)
            self.model.reflow()
        }
    }
}
