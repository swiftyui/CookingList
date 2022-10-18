import Foundation
import SwiftUI

struct GradientTextFieldStyle: TextFieldStyle {
    
    let systemImageString: String?
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            .red,
                            .blue
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 40)
            
            if(systemImageString != nil)
            {
                HStack {
                    Image(systemName: systemImageString.unsafelyUnwrapped)
                    // Reference the TextField here
                    configuration
                }
                .padding(.leading)
                .foregroundColor(.gray)
            } else {
                HStack {
                    // Reference the TextField here
                    configuration
                }
                .padding(.leading)
                .foregroundColor(.gray)
            }

        }
    }
}

struct EmptyCheckFieldStyle: TextFieldStyle {
    let systemImageString: String?
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        let mirror = Mirror(reflecting: configuration)
        let text: String = mirror.descendant("_text", "_value") as! String
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
              .strokeBorder(text.count > 0 ? Color.green : Color.red)
              .frame(height: 35 )
            
            HStack {
                if(systemImageString != nil)
                {
                    Image(systemName: systemImageString.unsafelyUnwrapped)
                }
                configuration.padding(.leading, 10.0)
            }
        }
    }
}

struct ClearStyle: TextFieldStyle {
  @ViewBuilder
  func _body(configuration: TextField<_Label>) -> some View {
    let mirror = Mirror(reflecting: configuration)
    let text: Binding<String> = mirror.descendant("_text") as! Binding<String>
      
    configuration.overlay( Button { text.wrappedValue = "" } label: { Image(systemName: "clear").foregroundStyle(Color(hue: 0.489, saturation: 0.027, brightness: 0.236)) }
          .padding(), alignment: .trailing )
  }
}

struct RedTextFieldStyle: TextFieldStyle {
    
    let systemImageString: String?
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [
                                  .red,
                                  .red
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 40)
            
            if(systemImageString != nil)
            {
                HStack {
                    Image(systemName: systemImageString.unsafelyUnwrapped)
                    // Reference the TextField here
                    configuration
                }
                .padding(.leading)
                .foregroundColor(.gray)
            } else {
                HStack {
                    // Reference the TextField here
                    configuration
                }
                .padding(.leading)
                .foregroundColor(.gray)
            }

        }
    }
}
