
import SwiftUI

struct ShoppingListCell: View {
    
    @ObservedObject var viewModel: ShoppingListViewModel
    let food: ShoppingListItem
    
    var body: some View {
        ZStack {
            HStack{
                Image(systemName: viewModel.selected(item: food) ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.primary)
                
                Text(food.itemName)
                    .font(.title2)
                    .padding(.leading, 5)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color(.systemBackground))
            .onTapGesture {
                if viewModel.selected(item: food) {
                    viewModel.deselect(food)
                } else {
                    viewModel.select(food)
                }
            }
        }
    }
}

struct ShoppingListCell_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListCell(viewModel: ShoppingListViewModel(), food: ShoppingListItem(itemName: "Test"))
    }
}
