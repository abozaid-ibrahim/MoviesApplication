//
//  RandomAccessCollectionExtension.swift
//  MoviesApplication
//
//  Created by abuzeid on 30.11.23.
//

import Foundation
// Extension to check if the item is the last one in the list
extension RandomAccessCollection where Self: BidirectionalCollection, Self.Index == Self.Indices.Element {
    func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard let firstIndex = firstIndex(where: { ($0 as? Item)?.id == item.id }) else {
            return false
        }
        return firstIndex == index(before: endIndex)
    }
}
