import SwiftUI

struct RecipeRow: View {
    @Binding var recipe: Recipe
    
    var body: some View {
        
        HStack {
            
            Image(uiImage: recipe.image)
                .resizable()
                .frame(width: 40, height: 40)
                .scaledToFill()
                .clipShape(Circle())
                .shadow(radius: 5)
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            
            Text(recipe.name)
                .font(.subheadline)
            Spacer()
        }
        
    }
}



