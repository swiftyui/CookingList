import SwiftUI

struct GroceryListsListView: View {
    @State var addRecipeItems: [RecipeItem]?
    @EnvironmentObject var groceryModel: GroceryModel
    @State var checked = false
    
    var body: some View {
        
        RefreshableScrollView{
            ForEach($groceryModel.groceryList) { list in
                HStack {
                    CheckBoxView(checked: list.addToList ).padding()
                    Text(list.GroceryListName.wrappedValue).padding()
                    Spacer()
                    
                }
                Divider()
            }
            
        }
        .onAppear { groceryModel.getAllGroceryLists() }
        .refreshable { groceryModel.getAllGroceryLists() }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role:.none, action:{
                    
                    for list in $groceryModel.groceryList
                    {
                        if(list.addToList.wrappedValue == true)
                        {
                            for recipeItem in addRecipeItems.unsafelyUnwrapped
                            {
                                let newItem: GroceryItems = GroceryItems(name: recipeItem.name, quantity: Int(recipeItem.quantity) ?? 1, type: recipeItem.type)
                                let lastIndex = list.GroceryItems.wrappedValue.endIndex
                                list.GroceryItems.wrappedValue.insert(newItem, at: lastIndex)
                            }
                            
                            groceryModel.modifyGroceryList(groceryList: list.wrappedValue)
                        }
                    }
                })
                { Label("Add to lists", systemImage: "doc.fill.badge.plus")}
            }
        }
        
    }
}

