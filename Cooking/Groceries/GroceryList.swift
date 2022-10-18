import Foundation
import CloudKit
import UIKit

struct GroceryList: Identifiable {
    var id: String = UUID().uuidString
    var recordID: CKRecord.ID?
    var GroceryListName: String
    var GroceryItems: [GroceryItems]
    var addToList: Bool = false
}

struct GroceryItems: Identifiable , Codable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: Int
    var type: String
}

