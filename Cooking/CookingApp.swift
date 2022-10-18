import SwiftUI

@main
struct CookingApp: App {
    @State var loading: Bool = true
    @State var recipeModel: RecipeModel = RecipeModel()
    @State var groceryModel: GroceryModel = GroceryModel()
    
    
    var body: some Scene {
        WindowGroup {
            TabView{
                RecipesView()
                    .environmentObject(recipeModel)
                    .tabItem {
                        Label("Recipes", systemImage: "book")
                    }
                GroceryMainView()
                    .environmentObject(groceryModel)
                    .tabItem {
                        Label("Grocery Lists", systemImage: "list.dash")
                    }

                
            }
            .onAppear {
                ///allow notifications
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
                ///load the data
                recipeModel.getAllRecipes()
                groceryModel.getAllGroceryLists()
            }
        }
    }
}
