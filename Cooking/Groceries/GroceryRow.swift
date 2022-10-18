import SwiftUI

struct GroceryRow: View {
    @Binding var groceryItem: GroceryItems
    @State var quantityasString: String = ""
    
    var body: some View {
        HStack {
            TextField("Name", text: $groceryItem.name)
            Spacer()
            TextField("Quantity", value: $groceryItem.quantity, format: .number).keyboardType(.numberPad)
            Picker(selection: $groceryItem.type, label: Text("")) {
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
