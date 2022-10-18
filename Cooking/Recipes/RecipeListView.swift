import SwiftUI
import CloudKit

struct RecipeListView: View {
    //variables
    @EnvironmentObject var recipeModel: RecipeModel
    @State var searchString: String = ""
    
    var body: some View {
        
                List {
                    
                    ForEach($recipeModel.recipeList.filter { self.searchString.isEmpty ? true : $0.name.wrappedValue.lowercased().contains(searchString.lowercased())}) { recipe in
                        NavigationLink { RecipeDetail(recipe: recipe).environmentObject(recipeModel)}
                        label: { RecipeRow(recipe: recipe)}
                        .swipeActions(allowsFullSwipe: false) {
                    
                        //delete the recipe
                        Button(role:.destructive, action:{recipeModel.deleteRecipe(item: recipe.wrappedValue); recipeModel.recipeList.removeAll( where: {$0.recordID == recipe.recordID.wrappedValue})})
                        { Label("Delete", systemImage: "trash")}
                                
                                
                        //favorite the recipe
                        Button(role:.none, action:{ if(recipe.isFavorite.wrappedValue == true){recipe.isFavorite.wrappedValue = false}else{recipe.isFavorite.wrappedValue = true}; recipeModel.modifyRecipe(item: recipe.wrappedValue) })
                        { Label("Favorite", systemImage: "star")}.tint(Color(hue: 0.154, saturation: 0.944, brightness: 0.76))
                    }
                }
            }
            .refreshable { recipeModel.getAllRecipes() }
    }
}
