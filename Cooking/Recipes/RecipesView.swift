import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var recipeModel: RecipeModel
    @State var searchString: String = ""
    @State var gridLayout: [GridItem] = [ GridItem(.adaptive(minimum: 100)), GridItem(.flexible()) ]
    @State var popup: Bool = false
    @State var showCreateView: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                RefreshableScrollView {
                    RecipesFavoritesView().environmentObject(recipeModel)
                    
                    SearchBar(searchString: $searchString)
                    
                    
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach($recipeModel.recipeList.filter { self.searchString.isEmpty ? true : $0.name.wrappedValue.lowercased().contains(searchString.lowercased())}) { recipe in
                            NavigationLink(destination: RecipeDetail(recipe: recipe).environmentObject(recipeModel))
                            {
                                Image(uiImage: recipe.image.wrappedValue)
                                           .resizable()
                                           .scaledToFill()
                                           .frame(minWidth: 0, maxWidth: .infinity)
                                           .frame(height: 200)
                                           .cornerRadius(10)
                                           .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                           .overlay(Color.secondary.cornerRadius(10).opacity(0.3))
                            }
                            
                        }
                    }
                    .padding(.all, 10)
                    .animation(.easeIn, value: gridLayout.count)
                }
                .refreshable { recipeModel.getAllRecipes() }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Recipes").font(.custom("Futura-Medium", size: 22))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RecipeCreateView(popup: self.$popup).environmentObject(recipeModel))
                    {
                         Label("Create recipe", systemImage: "plus.circle") 
                    }
                    
                }
                
            }
            .popover(isPresented: self.$popup, arrowEdge: .bottom)
            {
                RecipeCreateView(popup: self.$popup).environmentObject(recipeModel)
            }
        }
    }
}
