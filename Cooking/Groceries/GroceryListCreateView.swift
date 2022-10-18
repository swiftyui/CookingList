import SwiftUI

struct GroceryListCreateView: View {
    
    @EnvironmentObject var groceryModel: GroceryModel
    @Binding var popup: Bool
    @State var groceryList: GroceryList = GroceryList(GroceryListName: "", GroceryItems: [])
    
    var body: some View {
        ScrollView {
            //save button
            HStack {
                Spacer()
                Button(role: .none, action: {
                    groceryModel.saveGroceryList(groceryList: groceryList)
                    popup = false
                })
                {
                    Label("Save Grocery List", systemImage: "doc.fill.badge.plus")
                }.foregroundColor(Color(red: 0.193, green: 0.653, blue: 0.771))
            }
            .padding()
            .foregroundColor(Color.white)
                
            TextField(text: $groceryList.GroceryListName) {
                Label("Grocery list name....", systemImage: "pencil")
            }
            .padding()
            .background(Color.white)
            
        }
    }
}
