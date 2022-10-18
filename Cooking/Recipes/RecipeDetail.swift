import SwiftUI
import PhotosUI

struct RecipeDetail: View {
    
    //variables
    @EnvironmentObject var recipeModel: RecipeModel
    
    @Binding var recipe: Recipe
    @State var isPresented: Bool = false
    @State var navigateToAdd: Bool = false
    
    var body: some View {
        if( self.navigateToAdd == true )
        {
            /// navigate to the add grocery lists list view
            GroceryListsListView(addRecipeItems: recipe.items).environmentObject(GroceryModel())
        }
        else
        {
            
            GeometryReader { geo in
                RefreshableScrollView {
                    ///create the center image
                    Image(uiImage: recipe.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .onTapGesture { isPresented.toggle()}
                        .sheet(isPresented: $isPresented) {
                            let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                            PhotoPicker(configuration: configuration, isPresented: $isPresented, selectedImage: $recipe.image)
                        }
                    
                    Divider()
                    
                    ///recipe name
                    TextField(text: $recipe.name)
                    { Label("Recipe name", systemImage: "pencil")}.font(.title)
                    
                    ///recipe description
                    TextEditor(text: $recipe.description).frame( height: 200)
                    
                    ///add ingredient button
                    Button(role: .none, action: {
                        let newItem = RecipeItem(name: "", quantity: "", type: "units")
                        let lastIndex = $recipe.items.wrappedValue.endIndex
                        $recipe.items.wrappedValue.insert(newItem, at: lastIndex)
                    }) { Label("Add Ingredient", systemImage: "plus.circle") }
                    
                    ///Create a list containing all the ingredients
                    List { ForEach($recipe.items) { item in
                           RecipeItemRow(recipeItem: item)
                            .swipeActions {
                                Button(role: .destructive, action: { recipe.items.removeAll( where: {$0.id == item.id }) })
                                { Label("Delete ingredient", systemImage: "trash") }
                            }
                        }
                    }
                    .frame(width: geo.size.width - 5, height: geo.size.height - 50, alignment: .center)
                }
                .navigationTitle(recipe.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Menu {
                        //add recipe to grocery list
                        Button(role:.none, action: { self.navigateToAdd = true})
                        { Label("Add to grocery list", systemImage: "plus.circle")}
                        
                        if( recipe.isFavorite == true )
                        {
                            Button(role: .none, action:{recipe.isFavorite = false; recipeModel.modifyRecipe(item: recipe)})
                            { Label("Remove from favorites", systemImage: "star")}
                        }
                        else
                        {
                            Button(role: .none, action:{recipe.isFavorite = true; recipeModel.modifyRecipe(item: recipe)})
                            { Label("Add to favorites", systemImage: "star")}
                        }
                        

                        Button(role: .destructive, action:{recipeModel.deleteRecipe(item: recipe)})
                        { Label("Delete recipe", systemImage: "trash")}
                        
                        } label: {
                            Label("Options", systemImage: "ellipsis")
                        }
                    }
            }
        }
    }
}


