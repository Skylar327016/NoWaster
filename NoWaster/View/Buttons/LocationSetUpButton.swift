

import SwiftUI

struct LocationSetUpButton: View {
    
    @Binding var hasLocationSet: Bool
    
    var body: some View {
        HStack {
            Text(hasLocationSet ? "Your Location ✅" : "Your Location (approx)")
                .foregroundColor(hasLocationSet ? .brandPrimary : .secondary)
                .font(.system(size: 14, weight: .semibold))
            Spacer()
            Image(systemName: "arrow.right.circle")
                .foregroundColor(hasLocationSet ? .brandPrimary : .gray)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1))
    }
}

struct LocationSetUpButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationSetUpButton(hasLocationSet: .constant(true))
    }
}
