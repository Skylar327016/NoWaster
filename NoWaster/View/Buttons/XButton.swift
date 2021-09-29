
import SwiftUI

struct XButton: View {
    
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(Color.white)
                .opacity(0.6)
            
            Image(systemName: "xmark")
                .resizable()
                .frame(width: size / 2 , height: size / 2)
                .foregroundColor(.black)
        }
    }
}

struct XButton_Previews: PreviewProvider {
    static var previews: some View {
        XButton(size: 30)
    }
}
