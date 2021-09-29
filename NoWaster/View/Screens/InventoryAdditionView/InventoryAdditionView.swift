
import SwiftUI

struct InventoryAdditionView: View {
    
    @ObservedObject var inventoryListViewModel: InventoryListViewModel
    @StateObject var viewModel = InventoryAdditionViewModel()
    @EnvironmentObject var tabViewModel: AppTabViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                ImageHolder(diameter: 150, image: Image(uiImage: viewModel.image))
                    .overlay(cameraActionButton(), alignment: .bottomTrailing)
                
                textFieldView()
                
                DatePicker("Expiry", selection: $viewModel.expiry, displayedComponents: .date)
                
                addInventoryButton()
            }
            .frame(width: 250)
            .modifier(AdditionViewStyle())
            .overlay(dismissAdditionViewButton(), alignment: .topTrailing)
            .alert(item: $viewModel.alertItem){ alertItem in Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)}
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .actionSheet(isPresented: $viewModel.showingActionSheet) {
                ActionSheet(title: Text("Edit Image"), message: nil, buttons: [
                    .default(Text("Open Camera")) { openCamera()},
                    .default(Text("Select from Photo Library")) { openPhotoLibrary()},
                    .cancel()
                ])
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(selectedImage: $viewModel.image, sourceType: viewModel.sourceType)
            }
            if viewModel.showingScanView {
                ScanDocumentView(viewModel: viewModel)
            }
        }
    }
    
    
    private func addNewInventoryItem() {
        DispatchQueue.main.async {
            inventoryListViewModel.showingAdditionView = false
            inventoryListViewModel.isLoading = true
            viewModel.createInventoryItem { record in
                guard let record = record else { return }
                inventoryListViewModel.add(record: record)
            }
        }
    }
    
    
    @ViewBuilder private func cameraActionButton() -> some View {
        Button {
            viewModel.showingActionSheet = true
        } label: {
            CameraButton(diameter: 30)
        }
    }
    
    
    @ViewBuilder private func textFieldView() -> some View{
        HStack {
            TextField("Food Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                hideKeyboard()
                viewModel.showingScanView = true
            }label: {
                Image(systemName: "viewfinder")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .imageScale(.large)
                    .foregroundColor(.brandPrimary)
            }
        }
    }
    
    
    @ViewBuilder private func addInventoryButton() -> some View {
        Button {
            DispatchQueue.main.async {
                addNewInventoryItem()
            }
        } label: {
            TextButton(text: "Add", textColor: .white, color: viewModel.isValidItem() ? .brandPrimary : .secondary)
        }
        .disabled(!viewModel.isValidItem())
    }
    
    
    @ViewBuilder private func dismissAdditionViewButton() -> some View {
        Button{
            DispatchQueue.main.async {
                inventoryListViewModel.showingAdditionView = false
            }
            
        }label: {
            XButton(size: 30)
                .padding()
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

struct InventoryAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryAdditionView(inventoryListViewModel: InventoryListViewModel())
    }
}

struct AdditionViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 400)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 40)
    }
}
