

import SwiftUI

struct PlusButton: View {
    
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(Color(.systemGray6))
                .opacity(0.6)
            Image(systemName: "plus")
                .resizable()
                .frame(width: size * 1/2, height: size * 1/2)
                .foregroundColor(.brandPrimary)
        }
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton(size: 70)
    }
}
