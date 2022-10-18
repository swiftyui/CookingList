import SwiftUI

struct RecipesFavoritesView: View {
    @EnvironmentObject var recipeModel: RecipeModel
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:12) {
                Button(role:.none, action:{print("share")})
                { }
                
                ForEach($recipeModel.recipeList) { recipe in
                    if(recipe.isFavorite.wrappedValue == true)
                    {
                        NavigationLink(destination: RecipeDetail(recipe: recipe).environmentObject(recipeModel))
                        {
                            ZStack {
                                Image(uiImage: recipe.image.wrappedValue)
                                    .resizable()
                                    .frame(width: 65, height: 65, alignment: .center)
                                    .clipShape(Circle())

                                
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(AngularGradient(gradient: .init(colors: [Color(red: 0.193, green: 0.653, blue: 0.771),Color(red: 0.193, green: 0.653, blue: 0.771),.blue]), center: .center), style: StrokeStyle(lineWidth: 3, dash: [0])).frame(width: 66, height: 66)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 2.0)
        }
    }
}
