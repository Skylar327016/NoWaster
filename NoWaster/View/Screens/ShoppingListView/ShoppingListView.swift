

import SwiftUI

struct ShoppingListView: View {
    
    @StateObject var viewModel = ShoppingListViewModel()
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 20) {
                    searchBarView()
                    
                    addButton()
                }
                
                ZStack {
                    List(viewModel.shoppingList) { food in
                        ShoppingListCell(viewModel: viewModel, food: food)
                    }
                    .listStyle(PlainListStyle())
                    
                    if viewModel.shoppingList.isEmpty {
                        EmptyShoppingListState()
                    }
                    
                    if !viewModel.foodName.isEmpty {
                        showHistoryList()
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
            }
            .padding()
            
            if viewModel.showingMenu {
                ShoppingListMenuView(viewModel: viewModel)
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(perform: viewModel.fetchShoppingList)
        .onAppear(perform: viewModel.fetchShoppingHistory)
        .alert(item: $viewModel.alertItem) { item in
            Alert(title: item.title, message: item.message, dismissButton: item.dismissButton)
        }
    }
    
    @ViewBuilder private func searchBarView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 280, height: 35)
                .foregroundColor(Color(.white))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.brandPrimary, style: StrokeStyle(lineWidth: 2))
                )
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width:20, height: 20)
                    .foregroundColor(.brandPrimary)
                    .padding(.leading, 10)
                TextField("", text: $viewModel.foodName)
                    .frame(height: 35)
                
                if !viewModel.foodName.isEmpty {
                    Button {
                        viewModel.foodName = ""
                        hideKeyboard()
                    }label: {
                        XButton(size: 25).padding(.trailing, 10)
                    }
                }
            }
            .frame(width: 280, height: 35)
        }
    }
    
    
    @ViewBuilder private func addButton() -> some View{
        Button {
            DispatchQueue.main.async {
                viewModel.addItem()
                viewModel.updateHistory()
                hideKeyboardAndEmptySearchBar()
            }
        }label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.brandPrimary)
        }
        .disabled(viewModel.foodName.isEmpty)
    }
    
    
    @ViewBuilder private func showHistoryList() -> some View{
        
        let historyItems = viewModel.shoppingHistory.filter { $0.itemName.contains(viewModel.foodName) }
        
        List(historyItems) { item in
            Text(item.itemName)
                .onTapGesture {
                    viewModel.addFromHistory(itemName: item.itemName)
                    hideKeyboardAndEmptySearchBar()
                }
        }
    }
    
    
    private func hideKeyboardAndEmptySearchBar() {
        viewModel.foodName = ""
        hideKeyboard()
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoppingListView()
                .navigationTitle("Shopping List")
        }
        
    }
}
