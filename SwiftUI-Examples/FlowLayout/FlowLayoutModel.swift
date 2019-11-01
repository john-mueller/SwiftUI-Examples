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
    // This is really only @Published to guarantee display after first reflow
    @Published var flowedWords: [[String]] = []

    // Containers to store words array and widths of word views
    var words: [String] = []
    var widths: [CGFloat] = []
    var viewWidth: CGFloat = 0

    // Spacing between word views
    let spacing: CGFloat = 10

    init(string: String) {
        self.string = string
    }
}

extension FlowLayoutModel {
    func reflow() {
        guard words.count > 0 else { flowedWords = []; return }

        guard self.widths.count > 0 else {
            flowedWords = [words]
            return
        }

        // Get indices of words array where we need to break to stay in top level view width
        var breakIndices: [Int] = []
        var lineWidth: CGFloat = self.widths[0]
        for (index, width) in self.widths.dropFirst().enumerated() {
            if lineWidth + width + spacing < viewWidth {
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
