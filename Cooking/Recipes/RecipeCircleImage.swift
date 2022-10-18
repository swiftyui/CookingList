import SwiftUI

struct RecipeCircleImage: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
            
    }
}

