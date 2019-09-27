// Inspired by https://swiftui-lab.com/communicating-with-the-view-tree-part-1/

import SwiftUI

// Index is place in words array, width is size of hidden word view
struct ViewWidth: Equatable {
    let index: Int
    let width: CGFloat
}

// Set on top level view
struct ViewWidthKey: PreferenceKey {
    typealias Value = [ViewWidth]

    static var defaultValue: [ViewWidth] = []

    static func reduce(value: inout [ViewWidth], nextValue: () -> [ViewWidth]) {
        value.append(contentsOf: nextValue())
    }
}

// Set on hidden word views
struct WordWidthKey: PreferenceKey {
    typealias Value = [ViewWidth]

    static var defaultValue: [ViewWidth] = []

    static func reduce(value: inout [ViewWidth], nextValue: () -> [ViewWidth]) {
        value.append(contentsOf: nextValue())
    }
}

// Used to set a background on hidden word views and read their widths
struct WordWidthPreferenceSetter: View {
    let index: Int

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: WordWidthKey.self,
                            value: [ViewWidth(index: self.index, width: geometry.size.width)])
        }
    }
}
