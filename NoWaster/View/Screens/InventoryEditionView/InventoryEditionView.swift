

import SwiftUI

struct InventoryEditionView: View {
    
    @State var inventoryItem: InventoryItem
    @StateObject var viewModel = InventoryEditionViewModel()
    @ObservedObject var inventoryListViewModel: InventoryListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                ImageHolder(diameter: 175, image: Image(uiImage: viewModel.image))
                    .overlay(cameraActionButton(), alignment: .bottomTrailing)
                    .padding(.top, 30)
                
                TextField("Food Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Expiry", selection: $viewModel.expiry, displayedComponents: .date)
                
                saveChangesButton()
                
                actionButtons()
                
                Spacer()
            }
            .frame(width: 240)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(perform: {viewModel.fetchRecord(with: inventoryItem.id)})
        .onAppear(perform: {viewModel.updateUI(with: inventoryItem)})
        .alert(item: $viewModel.alertItem){ alertItem in Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)}
        .actionSheet(isPresented: $viewModel.showingActionSheet) {
            ActionSheet(title: Text("Edit Image"), message: nil, buttons: [
                .default(Text("Open Camera")) { openCamera()},
                .default(Text("Select from Photo Library")) { openPhotoLibrary()},
                .cancel()
            ])
        }
        .sheet(isPresented: $viewModel.showingImagePicker){
            ImagePicker(selectedImage: $viewModel.image, sourceType: viewModel.sourceType)
        }
    }
    
    
    
    @ViewBuilder private func cameraActionButton() -> some View {
        Button {
            viewModel.showingActionSheet = true
        } label: {
            CameraButton(diameter: 30)
        }
    }
    

    @ViewBuilder private func saveChangesButton() -> some View {
        Button {
            updateItem()
        } label: {
            TextButton(text: "Save Changes", textColor: .white, color: viewModel.isValidItem() ? .brandPrimary : .secondary)
        }.disabled(!viewModel.isValidItem())
    }
    
    private func updateItem() {
        dismissEditionView()
        DispatchQueue.main.async { inventoryListViewModel.isLoading = true }
        viewModel.updateRecord { record in
            guard let record = record else {
                inventoryListViewModel.alertItem = AlertContext.failToUpdateInventoryItem
                return
            }
            inventoryListViewModel.update(updatedRecord: record)
        }
    }
    
    
    @ViewBuilder private func actionButtons() -> some View {
        LazyVGrid(columns: viewModel.columns) {
            Button {
                deleteItem()
            } label: {
                RoundedButton(image: Image(systemName: "checkmark.circle.fill"), title: "Consumed")
            }
            
            Button {
                giftItem()
            } label: {
                RoundedButton(image: Image(systemName: "gift.fill"), title: "Gift")
            }
            
            Button {
                extendExpiryDateBy1()
            } label: {
                RoundedButton(image: Image(systemName: "repeat.1.circle"), title: "Extend")
            }
            
            Button {
                deleteItem()
            } label: {
                RoundedButton(image: Image(systemName: "trash.fill"), title: "Delete")
            }
        }
    }
    
    
    private func deleteItem() {
        dismissEditionView()
        DispatchQueue.main.async { inventoryListViewModel.isLoading = true }
        viewModel.deleteRecord { recordId in
            guard let recordId = recordId else {
                inventoryListViewModel.alertItem = AlertContext.failToRemoveInventoryItem
                return
            }
            inventoryListViewModel.delete(recordId: recordId)
        }
    }
    
    
    private func extendExpiryDateBy1() {
        dismissEditionView()
        DispatchQueue.main.async { inventoryListViewModel.isLoading = true }
        viewModel.updateRecordExpiry { record in
            guard let record = record else {
                inventoryListViewModel.alertItem = AlertContext.failToUpdateInventoryItem
                return
            }
            inventoryListViewModel.update(updatedRecord: record)
        }
    }
    
    
    private func giftItem() {
        dismissEditionView()
        DispatchQueue.main.async { inventoryListViewModel.isLoading = true }
        viewModel.updateRecordToGift { record in
            guard let record = record else {
                inventoryListViewModel.alertItem = AlertContext.failToGiftItem
                return
            }
            inventoryListViewModel.delete(recordId: record.recordID)
        }
    }
    
    
    private func dismissEditionView() {
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    private func openCamera() {
        viewModel.sourceType = .camera
        viewModel.showingImagePicker = true
    }
    
    
    private func openPhotoLibrary() {
        viewModel.sourceType = .photoLibrary
        viewModel.showingImagePicker = true
    }
}

struct InventoryEditionView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryEditionView(inventoryItem: InventoryItem(record: MockData.inventoryItem), inventoryListViewModel: InventoryListViewModel())
    }
}
