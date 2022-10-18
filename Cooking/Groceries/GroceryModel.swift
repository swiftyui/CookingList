import Foundation
import CloudKit

class GroceryModel: ObservableObject {
    @Published var groceryList: [GroceryList] = []
    
    //save groceryList
    func saveGroceryList(groceryList: GroceryList) {
        //encode the items in the groceryList
        let encorder = JSONEncoder()
        let encodedArray = try! encorder.encode(groceryList.GroceryItems)
        
        let newRecord = CKRecord(recordType: "GroceryLists")
        newRecord.setValuesForKeys([
            "GroceryListID": UUID().uuidString,
            "GroceryListName" : groceryList.GroceryListName,
            "GroceryItems": encodedArray
        ])
        database.save(newRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("GroceryList Saved")
            }
            
        }
    }
    
    
    //update a record
    func modifyGroceryList(groceryList: GroceryList) {

        guard let recordID = groceryList.recordID else {
            //this is a new record save it
            saveGroceryList(groceryList: groceryList)
            return
        }
        DispatchQueue.main.async {
            database.fetch(withRecordID: recordID) { (record, error) in
                guard let record = record else { return }
                
                //encode the array
                let encoder = JSONEncoder()
                let encodedArray = try! encoder.encode(groceryList.GroceryItems)
                
                record.setValuesForKeys([
                    "GroceryListID": UUID().uuidString,
                    "GroceryListName" : groceryList.GroceryListName,
                    "GroceryItems": encodedArray
                ])
                database.save(record) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("GroceryList Saved")
                    }
                    
                }

            }
        }
    }
    
    //delete a record
    func deleteGroceryList(groceryList: GroceryList) {
        guard let recordID = groceryList.recordID else { return }
        DispatchQueue.main.async {
            database.delete(withRecordID: recordID) { (recordID, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print( "GroceryList deleted")
                
            }
        }
    }
    
    //fetch all records
    func getAllGroceryLists() {
        
        let query = CKQuery(recordType: "GroceryLists", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "GroceryListName", ascending: true)]
        
        
        //create the database operation and add it
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["GroceryListID", "GroceryListName", "GroceryItems"]
        operation.resultsLimit = 50
        database.add(operation)
        
        operation.recordMatchedBlock = { recordID, result in
            DispatchQueue.main.async {
                switch result {
                case .success(let record):
                    
                    //get the JSON array
                    let decorder = JSONDecoder()
                    var groceryList: GroceryList = GroceryList(GroceryListName: "", GroceryItems: [])
                    
                    groceryList.GroceryListName = record["GroceryListName"] as! String
                    groceryList.recordID = record.recordID
                    groceryList.id = record["GroceryListID"] as! String
                    
                    if(record["GroceryItems"] != nil)
                    {
                        let data: Data = record["GroceryItems"] as! Data
                        groceryList.GroceryItems = try! decorder.decode([GroceryItems].self, from: data)
                        
                    }
                    
                    
                    //only add if it doesn't exist already
                    if !self.groceryList.contains(where: {$0.recordID == groceryList.recordID})
                    {
                        self.groceryList.insert(groceryList, at: 0)
                    }
                    else
                    {
                        //update the item if found
                        if let row = self.groceryList.firstIndex(where: {$0.recordID == groceryList.recordID})
                        {
                            self.groceryList[row] = groceryList
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
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
