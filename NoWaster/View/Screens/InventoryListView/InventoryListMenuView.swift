

import SwiftUI

struct InventoryListMenuView: View {
    
    @ObservedObject var viewModel: InventoryListViewModel
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                inventoryCountView()
                
                inventoryMenuButtonsView(buttons: [
                    MenuButton(title: "Consumed", image: Image(systemName: "checkmark.circle.fill")),
                    MenuButton(title: "Gift", image: Image(systemName: "gift")),
                    MenuButton(title: "Extend", image: Image(systemName: "repeat.1")),
                    MenuButton(title: "Delete", image: Image(systemName: "trash.fill"))
                ])
            }
        }
    }
    
    
    @ViewBuilder private func inventoryCountView() -> some View {
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
                Text("\(viewModel.selectedRecords.count) item(s) selected")
                Spacer()
                Button {
                    viewModel.showingMenu = false
                    viewModel.selectedRecords.removeAll()
                }label: {
                    XButton(size: 30)
                        .padding(.trailing, 10)
                }
                
            }
            .frame(width: 350,height: 50)
        }
    }
    
    
    @ViewBuilder private func inventoryMenuButtonsView(buttons: [MenuButton]) -> some View {
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

struct InventoryListMenuView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListMenuView(viewModel: InventoryListViewModel())
    }
}
