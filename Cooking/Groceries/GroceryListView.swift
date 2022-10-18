import SwiftUI
import CloudKit
import Foundation

struct GroceryListView: View {
    //variables
    @EnvironmentObject var groceryModel: GroceryModel
    @Binding var groceryList: GroceryList
    @Binding var searchString: String
    
    var body: some View {
        
        VStack {
            
            HStack{
                Button(role:.none, action:{
                    let newItem: GroceryItems = GroceryItems(name: "", quantity: 1, type: "units")
                    let lastIndex = $groceryList.GroceryItems.wrappedValue.endIndex
                    $groceryList.GroceryItems.wrappedValue.insert(newItem, at: lastIndex)
                    print("added")
                })
                { Label("Add new item", systemImage: "plus.circle")}.padding()
                
                Spacer()
                
                Button(role:.none, action:{
                    groceryModel.modifyGroceryList(groceryList: groceryList)
                    print("saved")
                })
                { Label("Save List", systemImage: "doc.fill.badge.plus")}.padding()
            }
            
            
            List {
                ForEach($groceryList.GroceryItems.filter{ self.searchString.isEmpty ? true : $0.name.wrappedValue.lowercased().contains(searchString.lowercased())}) { list in
                    GroceryRow(groceryItem: list)
                        .swipeActions(content: {
                            //delete the item
                            Button(role:.destructive, action:{ $groceryList.GroceryItems.wrappedValue.removeAll(where: {$0.id == list.id })})
                            { Label("Delete", systemImage: "trash")}
                        })
                }
                .refreshable{groceryModel.getAllGroceryLists()}
            }
        }
        .onAppear{

        }
        
    }
}
