

import SwiftUI

struct ImageHolder: View {
    
    let diameter: CGFloat
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: diameter, height: diameter)
            .foregroundColor(Color(.systemGray3))
            .clipShape(Circle())
    }
}


struct ImageHolder_Previews: PreviewProvider {
    static var previews: some View {
        ImageHolder(diameter: 200, image: Image("food-placeholder"))
    }
}
