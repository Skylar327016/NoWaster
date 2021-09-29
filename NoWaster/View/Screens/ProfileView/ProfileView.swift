
import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var tabViewModel: AppTabViewModel
    
    var body: some View {
        ZStack {
            loadUserWhenTapProfileViewTab()
            VStack {
                ImageHolder(diameter: 150, image: Image(uiImage: viewModel.avatar))
                    .overlay(cameraActionButton(), alignment: .bottomTrailing)
                
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
                
                VStack(spacing: 30){
                    Button{
                        viewModel.updateUser()
                    } label: {
                        TextButton(text: "Update", textColor: .white, color: .brandPrimary)
                    }
                    
                    
                    Button{
                        viewModel.signOut()
                        tabViewModel.showingSignInView = true
                        tabViewModel.tabSelection = 1
                    } label: {
                        TextButton(text: "SIgn out", textColor: .white, color: .brandSecondary)
                    }
                       
                }
                Spacer()
            }
            .padding(25)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
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
    
    
    @ViewBuilder private func cameraActionButton() -> some View {
        Button {
            viewModel.showingActionSheet = true
        } label: {
            CameraButton(diameter: 30)
        }
    }
    
    
    @ViewBuilder func loadUserWhenTapProfileViewTab() -> some View{
        if tabViewModel.tabSelection == 5 && viewModel.userRecord == nil {
            Color.clear.onAppear() {
                viewModel.loadUser()
            }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .navigationTitle("Profile")
        }
    }
}
