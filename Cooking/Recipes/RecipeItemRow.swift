import SwiftUI

struct RecipeItemRow: View {
    //variables
    @Binding var recipeItem: RecipeItem
    
    var body: some View {
            HStack {
                TextField(text: $recipeItem.name) {
                    Label("Name", systemImage: "plus.circle")
                }
                
                TextField(text: $recipeItem.quantity) {
                    Label("Quantity", systemImage: "pencil")
                }
                .keyboardType(.decimalPad)
                
                Picker(selection: $recipeItem.type, label: Text("")) {
                    Text("units").tag("units")
                    Text("mg").tag("mg")
                    Text("g").tag("g")
                    Text("ml").tag("ml")
                    Text("l").tag("l")
                    Text("tsp").tag("tsp")
                    Text("cup").tag("cupang")
                }
            }
    }
}
