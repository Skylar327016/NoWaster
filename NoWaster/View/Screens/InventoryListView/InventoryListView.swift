
import SwiftUI
import CloudKit

struct InventoryListView: View {
    
    @EnvironmentObject var tabViewModel: AppTabViewModel
    @StateObject var viewModel = InventoryListViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    List(viewModel.inventoryList) { record in
                        inventoryItemLink(with: record)
                    }
                    .listStyle(PlainListStyle())
                    
                    if viewModel.inventoryList.isEmpty{
                        EmptyInventoryListView()
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
                .overlay(showAdditionViewButton(), alignment: .bottomTrailing)
                .blur(radius: viewModel.showingAdditionView ? 60 : 0)
                .onAppear(perform: viewModel.getInventoryList)
                .onAppear(perform: importRecords)
                .alert(item: $viewModel.alertItem) { item in
                    Alert(title: item.title, message: item.message, dismissButton: item.dismissButton)
                }
                if viewModel.showingAdditionView {
                    InventoryAdditionView(inventoryListViewModel:viewModel)
                }
                
                if viewModel.showingMenu {
                    InventoryListMenuView(viewModel: viewModel)
                }
            }
            .navigationTitle(viewModel.showingAdditionView ? "": "Inventory")
        }
        
    }
    
    
    @ViewBuilder private func inventoryItemLink(with record: CKRecord) -> some View {
        ZStack {
            NavigationLink(destination: InventoryEditionView(inventoryItem: InventoryItem(record: record), inventoryListViewModel: viewModel)) {
                EmptyView()
            }
            .opacity(0)
            .disabled(viewModel.showingMenu)
            
            InventoryListCell(record: record, viewModel: viewModel)
        }
    }
    
    
    @ViewBuilder private func showAdditionViewButton() -> some View {
        Button{
            DispatchQueue.main.async {
                viewModel.showingAdditionView = true
            }
        } label: {
            PlusButton(size: 70)
                .padding(.trailing, 30)
                .padding(.bottom, 30)
                .opacity(viewModel.isLoading ? 0 : 1)
        }
        .disabled(viewModel.isLoading ? true : false)
    }
    
    
    private func importRecords() {
        if !CloudKitManager.shared.importedRecords.isEmpty {
            DispatchQueue.main.async {
                viewModel.inventoryList.append(contentsOf: CloudKitManager.shared.importedRecords)
                CloudKitManager.shared.importedRecords.removeAll()
            }
        }
    }
}

struct InventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InventoryListView()
        }
    }
}

