import SwiftUI

struct GroceryMainView: View {
    @EnvironmentObject var groceryModel: GroceryModel
    @State var presentAlert: Bool = false
    @State var groceryList: GroceryList = GroceryList(GroceryListName: "", GroceryItems: [])
    @State var groceryListName: String? = ""
        
    
    @State var popup: Bool = false
    @State var searchQuery: String = ""

    
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                
                RefreshableScrollView {
                    Menu {
                        
                        ForEach($groceryModel.groceryList) { list in
                            Button(role: .none, action: { groceryList = list.wrappedValue})
                            { Text(list.GroceryListName.wrappedValue) }
                        }
                        
                    } label: {
                        if( self.$groceryList.GroceryListName.wrappedValue != "")
                        {
                            Label(self.$groceryList.GroceryListName.wrappedValue, systemImage: "chevron.down")
                        }
                        else
                        {
                            Label("Select a Grocery List", systemImage: "chevron.down")
                        }
                        
                        
                    }
                    
                    if(self.$groceryList.GroceryListName.wrappedValue != "")
                    {
                        Spacer()
                        SearchBar(searchString: self.$searchQuery)
                        
                        GroceryListView(groceryList: self.$groceryList, searchString: self.$searchQuery)
                            .environmentObject(groceryModel)
                            .frame(width: geo.size.width - 5,
                                   height: geo.size.height - 50,
                                   alignment: .center)
                    }
                    
                    
                }
                .refreshable { groceryModel.getAllGroceryLists() }
                .navigationTitle("Grocery Lists")
                .navigationBarHidden(false)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Menu {
                        //create a new Grocery List
                        Button(role: .none, action: {self.presentAlert = true})
                        { Label("Create grocery list", systemImage: "plus.circle")}
                        

                        //delete the current Grocery List
                        Button(role: .destructive, action: {groceryModel.deleteGroceryList(groceryList: groceryList); groceryModel.groceryList.removeAll(where: {$0.recordID == groceryList.recordID}); groceryList = GroceryList(GroceryListName: "", GroceryItems: [])})
                        { Label("Delete grocery list", systemImage: "trash")}
                        
                    } label: {
                        Label("Options", systemImage: "ellipsis")
                    }
                }
                .textFieldAlert(isPresented: $presentAlert)
                {
                    TextFieldAlert(title: "New Grocery List", message: "Please enter a new name", text: self.$groceryListName)
                }
                .onChange(of: self.presentAlert) { newValue in
                    if ( newValue == false && groceryListName != "")
                    {
                        groceryList = GroceryList(GroceryListName: groceryListName.unsafelyUnwrapped, GroceryItems: [])
                        groceryModel.saveGroceryList(groceryList: groceryList)
                    }
                        
                }
                .popover(isPresented: self.$popup, arrowEdge: .bottom)
                {
                    GroceryListCreateView(popup: self.$popup).environmentObject(groceryModel)
                }
            }
        }
    }
}



