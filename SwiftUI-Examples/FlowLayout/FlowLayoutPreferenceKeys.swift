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

extension View {
    // Used to read the width of top level view
    // When attached through a ZStack, the Rectangle expands as much as possible.
    // The VStack inside the ScrollView we attach to doesn't expand automatically,
    //   so we want the Rectangle to expand and fill the whole width
    func attachViewWidthPreferenceSetter() -> some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: ViewWidthKey.self,
                                value: [ViewWidth(index: 0, width: geometry.size.width)])
            }
            self
        }
    }

    // Used to read the widths of the hidden word views
    // When attached through .background(), the Rectangle expands to the size of the parent view
    // The Text view we attach to is already sized correctly, and we don't want the Rectangle to expand more
    func attachWordWidthPreferenceSetter(index: Int) -> some View {
        self
            .background(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .preference(key: WordWidthKey.self,
                                    value: [ViewWidth(index: index, width: geometry.size.width)])
                }
        )
    }
}
