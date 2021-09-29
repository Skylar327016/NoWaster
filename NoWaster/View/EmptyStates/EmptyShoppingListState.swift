
import SwiftUI

struct EmptyShoppingListState: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "list.bullet.rectangle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(Color(.lightGray))
                
                Text("Your shopping list is empty. Search the history or create some!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

struct EmptyShoppingList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyShoppingListState()
    }
}
