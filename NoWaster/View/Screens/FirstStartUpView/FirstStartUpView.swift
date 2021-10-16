
import SwiftUI

struct FirstStartUpView: View {
    
    @StateObject var viewModel = FirstStartUpViewModel()
    @ObservedObject var tabViewModel: AppTabViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.userCreated { Color.clear.onAppear(){
                    DispatchQueue.main.async { tabViewModel.showingFirstStartUpView = false }
                }}
                
                Color.brandPrimary
                
                VStack{
                    HeaderMessageView()
                    
                    formView()
                    
                    Button{
                        viewModel.createUser()
                    } label: {
                        TextButton(text: "Ok", textColor: viewModel.userCreating ? .white : .brandPrimary, color: viewModel.userCreating ?  .gray : .white)
                    }
                }
            }
            .disabled(viewModel.userCreating)
            .navigationBarHidden(true)
            .actionSheet(isPresented: $viewModel.showingActionSheet) {
                ActionSheet(title: Text("Edit Avatar"), message: nil, buttons: [
                    .default(Text("Open Camera")) { openCamera()},
                    .default(Text("Select from Photo Library")) { openPhotoLibrary()},
                    .cancel()
                ])
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(selectedImage: $viewModel.avatar, sourceType: viewModel.sourceType)
            }
            .alert(item: $viewModel.alertItem) { item in
                Alert(title: item.title, message: item.message, dismissButton: item.dismissButton)
            }
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
    
    @ViewBuilder func formView() -> some View{
        ZStack {
            RoundedRectangle(cornerRadius: 25).foregroundColor(.white)
            
            VStack {
                ImageHolder(diameter: 150, image: Image(uiImage: viewModel.avatar))
                    .overlay(Button {
                        viewModel.showingActionSheet = true
                    } label: {
                        CameraButton(diameter: 30)
                    }, alignment: .bottomTrailing)
                
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    CharactersRemainView(currentCount: viewModel.bio.count)
                    Spacer()
                }
                
                TextEditor(text: $viewModel.bio)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1))
                
                NavigationLink(destination: LocationSetUpView(location: $viewModel.userLocation)) {
                    LocationSetUpButton(hasLocationSet: $viewModel.hasLocationSet)
                }
            }
            .padding(25)
        }
        .frame(width: 300, height: 450)
    }
    
    
    private func openCamera() {
        viewModel.sourceType = .camera
        viewModel.showingImagePicker = true
    }
    
    
    private func openPhotoLibrary() {
        viewModel.sourceType = .photoLibrary
        viewModel.showingImagePicker = true
    }
    
    private func dismissFirstStartUpView(){
        tabViewModel.showingFirstStartUpView = false
    }
}

struct FirstStartUpView_Previews: PreviewProvider {
    static var previews: some View {
        FirstStartUpView(tabViewModel: AppTabViewModel())
    }
}

private struct HeaderMessageView: View {
    var body: some View {
        Text("Hello! Please set up your information to start using the app.")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
    }
}
