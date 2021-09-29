

import SwiftUI

struct AppTabView: View {
    
    @StateObject var viewModel = AppTabViewModel()
    
    var body: some View {
        
        ZStack {
            NavigationView {
                TabView(selection: $viewModel.tabSelection){
                    
                    ShoppingListView()
                        .tabItem(){
                            Image(systemName: "bag")
                            Text("Shopping")
                        }.tag(1)
                    
                    
                    InventoryListView()
                        .environmentObject(viewModel)
                        .tabItem(){
                            Image(systemName: "star")
                            Text("List")
                        }.tag(2)
                

                    GiverMapView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                        .tabItem(){
                            Image(systemName: "map")
                            Text("Map")
                        }.tag(3)

                    ChatView()
                        .environmentObject(viewModel)
                        .tabItem(){
                            Image(systemName: "message.fill")
                            Text("Chat")
                        }.tag(4)
                    
                    ProfileView()
                        .environmentObject(viewModel)
                        .tabItem() {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }.tag(5)
                }
                .accentColor(.brandPrimary)
                .navigationTitle(viewModel.title())
                .navigationBarHidden(viewModel.tabSelection == 2)
            }
            
            if viewModel.showingFirstStartUpView {
                FirstStartUpView(tabViewModel: viewModel)
            }
            
            if viewModel.showingSignInView {
                SignInView(tabViewModel: viewModel)
            }
        }
        .onAppear(perform: viewModel.startUpCheck)
        .onAppear(perform: viewModel.authCheck)
        .onAppear(perform: viewModel.fetchAllChatRecipients)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
