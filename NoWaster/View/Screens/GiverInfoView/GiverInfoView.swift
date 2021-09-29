
//MARK:- Reference: https://stackoverflow.com/questions/56487323/make-a-vstack-fill-the-width-of-the-screen-in-swiftui
import SwiftUI
import CloudKit

struct GiverInfoView: View {
    
    let giverRecord: CKRecord
    @ObservedObject var giverMapViewModel: GiverMapViewModel
    @StateObject var viewModel = GiverInfoViewModel()
    @EnvironmentObject var tabViewModel: AppTabViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                giverHeaderView()
                
                bioView()
                
                giftListHeader()
                
                List(viewModel.giftList) { record in
                    GiverInfoCell(record: record, giverInfoViewModel: viewModel)
                }
                Spacer()
            }
            if viewModel.isLoading { LoadingView() }
        }
        .toolbar(content: {
            Button("Dismiss", action: {giverMapViewModel.selectedGiverRecord = nil})
        })
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: { viewModel.getGiftList(with: giverRecord) })
        .onAppear(perform: { viewModel.getGiverProfile(with: giverRecord) })
        .onDisappear(perform: { giverMapViewModel.getGivers()})
    }
    
    
    
    @ViewBuilder private func giverHeaderView() -> some View {
        HStack(alignment: .center) {
            
            ImageHolder(diameter: 125, image: Image(uiImage: viewModel.giftingUser?.avatar?.convertToUIImage() ?? .man))
            
            VStack(alignment: .center, spacing: 20){
                
                Text(viewModel.giftingUser?.username ?? "")
                    .frame(width: 200)
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Button {
                    pushToChatView()
                } label: {
                    TextButton(text: viewModel.userIsSelf ? "Edit Profile" : "Message", textColor: .white, color: .brandSecondary)
                }
            }
            Spacer()
        }
        .frame(height: 150)
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [.brandPrimary, .white]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    
    @ViewBuilder private func bioView() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Bio").fontWeight(.bold)
                Spacer()
            }
            
            Text(viewModel.giftingUser?.bio ?? "")
                .frame(maxWidth: .infinity, minHeight: 75, alignment: .topLeading)
                .padding(10)
                .lineLimit(3)
                .truncationMode(.tail)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1))
            
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .frame(height: 120)
    }
    
    
    @ViewBuilder private func giftListHeader() -> some View {
        HStack {
            Text(viewModel.giftList.isEmpty ? "No gift is on offer now ..." : "Gift(s) on offer ...")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
    
    
    private func pushToChatView() {
        if let uid = viewModel.giftingUser?.uid {
            tabViewModel.pushRecipientUid = uid
        }
        DispatchQueue.main.async(){
            presentationMode.wrappedValue.dismiss()
            tabViewModel.tabSelection = 4
        }
    }
}

struct GiverInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GiverInfoView(giverRecord: MockData.gifter, giverMapViewModel: GiverMapViewModel())
    }
}
