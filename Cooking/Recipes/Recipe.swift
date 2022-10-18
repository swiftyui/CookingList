import Foundation
import CloudKit
import UIKit


struct Recipe: Identifiable {
    var id: String = UUID().uuidString
    var recordID: CKRecord.ID?
    var name: String
    var description: String
    var items: [RecipeItem]
    var image: UIImage = (UIImage(named: "Food1") ?? UIImage())
    var isFavorite: Bool?
    
}

struct RecipeItem: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: String
    var type: String
}


