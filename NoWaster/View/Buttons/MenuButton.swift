
import SwiftUI

struct MenuButton: View, Identifiable {
    
    let id = UUID()
    let title: String
    let image: Image
    
    var body: some View {
        VStack(spacing: 10) {
            image
                .imageScale(.large)
            Text(title)
                .font(.system(size: 12))
        }
        .padding()
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(title: "Test", image: Image(systemName: "gift"))
    }
}
