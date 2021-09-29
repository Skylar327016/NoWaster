

import SwiftUI

struct ShoppingListMenuView: View {
    
    @ObservedObject var viewModel: ShoppingListViewModel
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                
                shoppingListCountView()
                
                shoppingListMenuButtonsView(buttons: [
                    MenuButton(title: "Add to Inventory", image: Image(systemName: "arrowshape.turn.up.forward.circle.fill")),
                    MenuButton(title: "Delete", image: Image(systemName: "trash.fill"))
                ])
            }
        }
    }
    
    
    @ViewBuilder private func shoppingListCountView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 50)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 4)
            
            HStack{
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                    .padding(.leading, 20)
                Spacer()
                Text("\(viewModel.selectedShoppingListItems.count) item(s) selected")
                Spacer()
                Button {
                    viewModel.selectedShoppingListItems.removeAll()
                    viewModel.showingMenu = false
                }label: {
                    XButton(size: 30)
                        .padding(.trailing, 10)
                }
            }
            .frame(width: 350,height: 50)
        }
    }
    
    
    @ViewBuilder private func shoppingListMenuButtonsView(buttons: [MenuButton]) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 80)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 4)
            
            HStack{
                ForEach(buttons) { button in
                    Button {
                        viewModel.showingMenu = false
                        viewModel.performMenu(action: button.title)
                    } label: {
                        button
                    }
                }
            }
        }
    }
}

struct ShoppingListMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListMenuView(viewModel: ShoppingListViewModel())
    }
}
