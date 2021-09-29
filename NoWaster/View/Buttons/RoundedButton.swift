

import SwiftUI

struct RoundedButton: View {
    
    let image: Image
    let title: String
    
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemGray6))
                .frame(width: 90, height: 90)
            VStack {
                image
                    .resizable()
                    .frame(width: 45, height: 45)
                Text(title)
                    .font(.system(size: 12))
            }
            .foregroundColor(.brandPrimary)
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(image: Image(systemName: "gift.fill"), title: "Gift")
    }
}
