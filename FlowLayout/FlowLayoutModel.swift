import SwiftUI

class FlowLayoutModel: ObservableObject {

    // Main data storage; when modified, split into array and store
    @Published var string: String
        { didSet {
            words = string.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            if string.isEmpty { flowedWords = [] }
        }
    }
    // Derived data storage used to layout view on multiple lines
    // This is really only @Published to guarentee display after first reflow
    @Published var flowedWords: [[String]] = []

    // Containers to store words array and widths of word views
    var words: [String] = []
    var widths: [CGFloat] = []

    // Spacing between word views
    let spacing: CGFloat = 10

    // This splits initial string into array and poplates widths array ahead of first layout
    init(string: String) {
        self.string = string
        words = string.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        widths = Array(repeating: 0, count: words.count)
    }
}

extension FlowLayoutModel {
    func reflow(in geometry: GeometryProxy, with preferences: [ViewWidth]? = nil) {

        guard words.count > 0 else { flowedWords = []; return }

        let widths: [CGFloat]
        if let preferences = preferences {
            // If number or length of word views changed, use and store new word view widths
            widths = preferences.sorted(by: \.index).map { $0.width.rounded(.up) }
            self.widths = widths
        } else {
            // If top level view with changed, use saved word view widths
            widths = self.widths
        }

        // Get indices of words array where we need to break to stay in top level view width
        var breakIndices: [Int] = []
        var lineWidth: CGFloat = widths[0]
        for (index, width) in widths.dropFirst().enumerated() {
            if lineWidth + width + spacing < geometry.size.width {
                lineWidth += width + spacing
            } else {
                breakIndices.append(index + 1) // + 1 because of the .dropFirst() above
                lineWidth = width
            }
        }

        // Generate flowedWords using breakIndicies
        if breakIndices.isEmpty {
            flowedWords = [words]
        } else {
            flowedWords = breakIndices.indices.map { index in
                let lowerBound = index == 0 ? 0 : breakIndices[index - 1]
                let upperBound = breakIndices[index]
                let range = lowerBound..<upperBound
                return Array(words[range])
            }
            flowedWords.append(Array(words[breakIndices.last!..<words.count]))
        }
    }
}

// From https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/
// Just a convenient way to sort a collection by key path
extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
