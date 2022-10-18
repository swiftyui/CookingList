import SwiftUI
import PhotosUI


struct RecipeCreateView: View {
    @EnvironmentObject var recipeModel: RecipeModel
    @State var recipe: Recipe = Recipe(name: "", description: "", items: [], isFavorite: false)
    @Binding var popup: Bool
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                
                VStack{
                    
                    ZStack {
                        ///image
                        Image(uiImage: recipe.image)
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: geo.size.width,height: geo.size.height / 3)
                                   .cornerRadius(10)
                                   .clipped()
                                   .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                   .overlay(Color.secondary.cornerRadius(10).opacity(0.3))
                                   .onTapGesture { self.isPresented = true }
                                   .popover(isPresented: $isPresented) {
                                       let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                                       PhotoPicker(configuration: configuration, isPresented: $isPresented, selectedImage: $recipe.image)
                                   }
                        
                        ///icon
                        Image(systemName: "photo").resizable().frame(width: 50, height: 50).foregroundColor(.white).opacity(0.8)
                            .onTapGesture { self.isPresented = true }
                    }
                    
                    ///recipe name
                    TextField(text: $recipe.name)
                    { Text("Recipe name....") }.font(.title2)
                    
                    ///recipe description
                    TextField(text: $recipe.description)
                    { Text("Description") }.font(.body)
                    
                    Button(role:.none, action:{ recipeModel.saveRecipe(recipe: recipe)})
                    { Label("Save", systemImage: "doc.fill.badge.plus")}
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
            }
        }
    }
}
                
    
                
            



                
//        GeometryReader { geo in
//            ScrollView {
//
//
//
//                Image(uiImage: recipe.image)
//                           .resizable()
//                           .scaledToFill()
//                           .frame(minWidth: 0, maxWidth: .infinity)
//                           .frame(height: 200)
//                           .cornerRadius(10)
//                           .shadow(color: Color.primary.opacity(0.3), radius: 1)
//                           .overlay(Color.secondary.cornerRadius(10).opacity(0.3))
//                           .onTapGesture { self.isPresented = true }
//                           .sheet(isPresented: $isPresented) {
//                               let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//                               PhotoPicker(configuration: configuration, isPresented: $isPresented, selectedImage: $recipe.image)
//                           }
//
//                HStack {
//                    Spacer()
//                    Button(role: .none, action:{ recipeModel.saveRecipe(recipe: recipe); popup = false})
//                    { Label("Save Recipe", systemImage: "doc.fill.badge.plus")}
//                }.padding()
//
//
//                Divider()
//
//                ///recipe name
//                TextField(text: $recipe.name)
//                {Text("Recipe name....")}.font(.title)
//

//
//                ///add ingredient button
//                Button(role: .none, action: {
//                    let newItem = RecipeItem(name: "", quantity: "", type: "units")
//                    let lastIndex = $recipe.items.wrappedValue.endIndex
//                    $recipe.items.wrappedValue.insert(newItem, at: lastIndex)
//                }) { Label("Add Ingredient", systemImage: "plus.circle") }
//
//                ///list for all the items
//                List { ForEach($recipe.items) { item in
//                       RecipeItemRow(recipeItem: item)
//                        .swipeActions {
//                            Button(role: .destructive, action: { recipe.items.removeAll( where: {$0.id == item.id }) })
//                            { Label("Delete ingredient", systemImage: "trash") }
//                        }
//                    }
//                }
//                .frame(width: geo.size.width - 5, height: geo.size.height - 50, alignment: .center)
//
//
//
//            }
//        }
//    }
//}
