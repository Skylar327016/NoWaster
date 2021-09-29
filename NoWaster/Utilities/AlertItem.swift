
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    static let invalidUserInfo = AlertItem(title: Text("Invalid Information"), message: Text("All fields are required as well as the avatar. Your bio must be less than 100 characters.\nPlease try it again."), dismissButton: .default(Text("Ok")))
    
    static let noUserRecord = AlertItem(title: Text("No User Record"), message: Text("You must log into iCloud on your phone in order to utilise the app. Please log in on your phone's settings screen."), dismissButton: .default(Text("Ok")))
    
    static let createUserFailure = AlertItem(title: Text("Failed to Set Up"), message: Text("We were unable to set up your user information at this time.\nPlease try again later or contact customer suppert if this persists."), dismissButton: .default(Text("Ok")))
    
    static let invalidInventoryInfo = AlertItem(title: Text("Invalid Information"), message: Text("The food name can not be empty."), dismissButton: .default(Text("Ok")))
    
    static let failToRetrieveInventoryList = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to retrieve your inventory data at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToAddInventoryItem = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to add inventory item at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToExtendExpiry = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to extend the expiry dates of the items at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToRemoveInventoryItem = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to remove the items at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToRetrieveInventoryItem = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to retrieve your item at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToUpdateInventoryItem = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to udate the item at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let importInventoryItems = AlertItem(title: Text("Items Imported Successfully"), message: Text("The selected items were successfully imported to inventory list. \nYou may check them out and edit the expiry dates and images."), dismissButton: .default(Text("Ok")))
    
    static let failToImportItems = AlertItem(title: Text("Shopping List Error"), message: Text("We were unable to import the items to the inventory list at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToSaveShoppingList = AlertItem(title: Text("Shopping List Error"), message: Text("We were unable to update your shopping list at this time. \nPlease try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToLoadAppStorage = AlertItem(title: Text("Shopping List Error"), message: Text("We were unable to retrieve you shopping list data at this time. \nPlease try again later."), dismissButton: .default(Text("Ok")))
    
    static let locationDisabled = AlertItem(title: Text("Locations Service Disabled"), message: Text("Your phone's location services are disabled. To change that go to your phone's Settings > Privary > Location Services"), dismissButton: .default(Text("Ok")))
    
    static let failToGiftItem = AlertItem(title: Text("Inventory Error"), message: Text("We were unable to gift your item at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToRetrieveGifterInfo = AlertItem(title: Text("System Error"), message: Text("We were unable to get this gifter's information at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToRetrieveGifters = AlertItem(title: Text("System Error"), message: Text("We were unable to find gifters at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToRetrieveGift = AlertItem(title: Text("System Error"), message: Text("We were unable to retrieve the item at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failtToLoadChats = AlertItem(title: Text("System Error"), message: Text("We were unable to load your chats at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failtToLoadMessages = AlertItem(title: Text("System Error"), message: Text("We were unable to load your messages at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let failToSendMessage = AlertItem(title: Text("System Error"), message: Text("We were unable to send your message at this time. \nPlease check your internet and try again later."), dismissButton: .default(Text("Ok")))
    
    static let updateUserSuccess = AlertItem(title: Text("Update Success"), message: Text("You have updated your profile!"), dismissButton: .default(Text("Ok")))
}

