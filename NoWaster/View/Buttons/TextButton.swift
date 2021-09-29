
import SwiftUI

struct TextButton: View {
    
    let text: String
    let textColor: Color
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(textColor)
            .frame(minWidth: 130, minHeight: 36)
            .background(color)
            .cornerRadius(18)
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "Save", textColor: .white, color: .brandPrimary)
    }
}
