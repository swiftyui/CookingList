
import SwiftUI

struct SplashScreenView: View {
    
    //variables
    @State var progress = 0.0
    @Binding var loading: Bool
    @EnvironmentObject var recipeModel: RecipeModel
    @EnvironmentObject var groceryModel: GroceryModel
    
    var body: some View {
        
        ZStack(alignment: .center) {
            GeometryReader { geo in
                Image("SplashScreen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width * 1)
                    .clipped()
                    .ignoresSafeArea(.all)
            }
            
            ProgressView(value: progress)
                .padding()
                .offset(y: 50)
                .progressViewStyle(SplashScreenProgressStyle())
        }
        .onAppear{
            recipeModel.getAllRecipes()
            groceryModel.getAllGroceryLists()
            
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                if( progress < 1.0)
                {
                    withAnimation{
                        progress += 0.25
                    }
                }
                else
                {
                    timer.invalidate()
                    loading = false
                }
            }
        }
    }
}
