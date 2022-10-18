import Foundation
import CloudKit
import UIKit

class RecipeModel: ObservableObject {
    
    @Published var recipeList: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var saved: Bool = false
    
    //update a record
    func modifyRecipe(item: Recipe) {
        
        guard let recordID = item.recordID else {
            //this is a new record save it
            saveRecipe(recipe: item)
            return
        }
        

        DispatchQueue.main.async {
            database.fetch(withRecordID: recordID) { (record, error) in
                guard let record = record else { return }
                
                //Encode the array
                let encoder = JSONEncoder()
                let encodedArray = try! encoder.encode(item.items)
                
                //get the image as an asset
                guard
                    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(item.image.description),
                    let data = item.image.jpegData(compressionQuality: 1.0) else { return }
                
                do{
                    try data.write(to: url)
                } catch let error {
                    print(error.localizedDescription)
                }
                let asset = CKAsset(fileURL: url)
                
                record.setValuesForKeys([
                    "id": item.id,
                    "name": item.name,
                    "description": item.description,
                    "items": encodedArray,
                    "image": asset,
                    "isFavorite": item.isFavorite
                ])
                database.save(record) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("Item Saved")
                        
                    }

                }
            }
        }
    }
    
    func deleteRecipe(item: Recipe)
    {
        //delete the item from the database
        guard let recordID = item.recordID else { return }

        DispatchQueue.main.async {
            database.delete(withRecordID: recordID ) { (recordID, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("item deleted")
                self.recipeList.removeAll( where: {$0.recordID == recordID})
            }
        }
    }
    

    
    //saving data to iCloud
    func saveRecipe(recipe: Recipe) {
        self.saved = false
        
        //encode the array
        let encoder = JSONEncoder()
        let encodedArray = try! encoder.encode(recipe.items)
        
        //save the image
        guard
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(recipe.image.description),
            let data = recipe.image.jpegData(compressionQuality: 1.0) else { return }
        
        do{
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
        let asset = CKAsset(fileURL: url)
        
        let newRecord = CKRecord(recordType: "Recipe")
        newRecord.setValuesForKeys([
            "id": UUID().uuidString,
            "name": recipe.name,
            "description": recipe.description,
            "items": encodedArray,
            "image": asset,
            "isFavorite": recipe.isFavorite
        ])
        database.save(newRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Item Saved")
                self.saved = false
                self.recipeList.insert(recipe, at: 0)
            }

        }
    }
    
    
    //get all the recipes
    func getAllRecipes() {
        
        //create a Query to get all the recipes stored in the DB
        let query = CKQuery(recordType: "Recipe", predicate: NSPredicate(value:true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //create the database operation and add it
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["id", "name", "description", "items", "image", "isFavorite"]
        operation.resultsLimit = 50
        database.add(operation)
        
        //handle each matching record
        operation.recordMatchedBlock = { recordID, result in
            DispatchQueue.main.async {
                switch result {
                case .success(let record):
                    
                    //get the JSON array
                    let decoder = JSONDecoder()
                    let data: Data = record["items"] as! Data
                    
                    //get the image
                    let imageAsset = record["image"] as? CKAsset
                    let imageURL = imageAsset?.fileURL
                    var uiImage = UIImage()
                    if (imageURL != nil)
                    {
                        let imageData = try? Data(contentsOf: imageURL.unsafelyUnwrapped)
                        uiImage = UIImage(data: imageData.unsafelyUnwrapped).unsafelyUnwrapped
                    } else {
                        uiImage = UIImage(named: "Photo1").unsafelyUnwrapped
                    }
                    
                    let recipe: Recipe = Recipe(id: record["id"] as! String,
                                                recordID: record.recordID,
                                                name: record["name"] as! String,
                                                description: record["description"] as! String,
                                                items: try! decoder.decode([RecipeItem].self, from: data),
                                                image: uiImage,
                                                isFavorite: record["isFavorite"])

                    //only add the record if it doesn't already exist
                    if !self.recipeList.contains(where: { $0.recordID == recipe.recordID })
                    {
                        self.recipeList.insert(recipe, at: 0)
                    }
                    else {
                        //update the item if found
                        if let row = self.recipeList.firstIndex(where: {$0.recordID == recipe.recordID})
                        {
                            self.recipeList[row] = recipe
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        //handle when the block is done loading
        operation.queryResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Block done loading")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
