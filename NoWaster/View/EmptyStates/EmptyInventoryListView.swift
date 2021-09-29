
import SwiftUI

struct EmptyInventoryListView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                Image(uiImage: .foodPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                
                Text("Your inventory list is empty, press the plus botton to add some!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .offset(y: -50)
            
        }
    }
}

struct EmptyInventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyInventoryListView()
    }
}
