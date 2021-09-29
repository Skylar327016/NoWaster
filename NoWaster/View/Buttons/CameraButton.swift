import SwiftUI

struct CameraButton: View {
    
    let diameter: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "camera.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: diameter, height: diameter)
                .foregroundColor(.brandPrimary)
                .background(Color.white)
                .imageScale(.large)
                .clipShape(Circle())
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraButton(diameter: 40)
    }
}
