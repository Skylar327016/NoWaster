import SwiftUI

struct CharactersRemainView: View {
    var currentCount: Int
    
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .font(.callout)
            .bold()
            .foregroundColor(currentCount <= 100 ?  Color.brandPrimary : Color(.systemPink))
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}

struct CharactersRemainView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersRemainView(currentCount: 0)
    }
}
