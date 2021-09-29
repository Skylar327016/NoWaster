

import SwiftUI

struct EmptyChatState: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(Color(.lightGray))
                
                Text("You don't have any chats at the moment!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

struct EmptyChatState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyChatState()
    }
}
