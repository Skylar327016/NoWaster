import SwiftUI
import CloudKit





final class ShoppingListViewModel: ObservableObject {
    
    @AppStorage("shoppingList") private var shoppingListData: Data?
    @AppStorage("shoppingHistory") private var shoppingHistoryData: Data?
    @Published var foodName = ""
    @Published var isEditing = false
    @Published var shoppingList: [ShoppingListItem] = []
    @Published var shoppingHistory: [ShoppingListHistory] = []
    @Published var showingMenu = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var selectedShoppingListItems: Set<UUID> = []
    
    func addItem() {
        if foodName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        shoppingList.append(ShoppingListItem(itemName: foodName))
        
        saveShoppingList()
    }
    
    
    func addFromHistory(itemName: String) {
        shoppingList.append(ShoppingListItem(itemName: itemName))
        updateHistory()
        saveShoppingList()
    }
    
    
    func updateHistory() {
        var isNotDuplicateItem = true
        
        if shoppingHistory.count != 0 {
            for i in 0...shoppingHistory.count - 1 {
                if shoppingHistory[i].itemName.uppercased() == foodName.uppercased() {
                    shoppingHistory[i].count += 1
                    isNotDuplicateItem = false
                    break
                }
            }
        }
        
        if isNotDuplicateItem {
            if shoppingHistory.count >= 100 {
                shoppingHistory.sort()
                for _ in 0...10 {
                    let _ = shoppingHistory.popLast()
                }
                shoppingHistory.append(ShoppingListHistory(itemName: foodName))
                saveShoppingHistory()
            } else {
                shoppingHistory.append(ShoppingListHistory(itemName: foodName))
                saveShoppingHistory()
    
            }
        } else {
            saveShoppingHistory()
        }
    }
    
    
    private func saveShoppingList() {
        do {
            shoppingListData = try JSONEncoder().encode(shoppingList)
        } catch {
            alertItem = AlertContext.failToSaveShoppingList
        }
    }
    
    
    private func saveShoppingHistory() {
        do {
            shoppingHistoryData = try JSONEncoder().encode(shoppingHistory)
        } catch {
            alertItem = AlertContext.failToSaveShoppingList
        }
    }
    
    
    func fetchShoppingList() {
        guard let shoppingListData = shoppingListData else { return }
        
        do {
            shoppingList = try JSONDecoder().decode([ShoppingListItem].self, from: shoppingListData)
        } catch {
            alertItem = AlertContext.failToLoadAppStorage
        }
    }
    
    
    func fetchShoppingHistory() {
        guard let shoppingHistoryData = shoppingHistoryData else { return }
        do {
            shoppingHistory = try JSONDecoder().decode([ShoppingListHistory].self, from: shoppingHistoryData)
        } catch {
            alertItem = AlertContext.failToLoadAppStorage
        }
    }
    
    
    func selected(item:ShoppingListItem) -> Bool{
        return selectedShoppingListItems.contains(item.id)
    }
    
    
    func select(_ item: ShoppingListItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.selectedShoppingListItems.isEmpty {
                self.showingMenu = true
            }
            self.selectedShoppingListItems.insert(item.id)
        }
    }
    
    
    func deselect(_ item: ShoppingListItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectedShoppingListItems.remove(item.id)
            if self.selectedShoppingListItems.isEmpty {
                self.showingMenu = false
            }
        }
    }
    
    
    func performMenu(action: String) {
        
        switch action {
            case "Add to Inventory" :
                importInventoryItems()
                showingMenu = false
                
            case "Delete" :
                deleteItems()
                showingMenu = false
                
            default:
                break
        }
    }
    
    
    func deleteItems() {
        DispatchQueue.main.async { [self] in
            while(selectedShoppingListItems.count > 0) {
                let idToDelete = selectedShoppingListItems.removeFirst()
                shoppingList.removeAll { (food) -> Bool in
                    food.id == idToDelete
                }
            }
            isLoading = false
            saveShoppingList()
        }
    }
    
    
    private func importInventoryItems() {
        var itemNames:[String] = []
        var itemToDelete: [UUID] = []
        var records: [CKRecord] = []
        var itemsToImports = selectedShoppingListItems
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let user = CloudKitManager.shared.user else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        while(itemsToImports.count > 0) {
            let idToImport = itemsToImports.removeFirst()
            for item in shoppingList {
                if item.id == idToImport {
                    itemNames.append(item.itemName)
                    itemToDelete.append(item.id)
                    break
                }
            }
        }
        
        for name in itemNames {
            let record = CKRecord(recordType: RecordType.inventoryItem)
            
            record[InventoryItem.kName] = name
            record[InventoryItem.kImage] = UIImage.foodPlaceholder.convertToCKAsset(with: record.recordID.recordName)
            record[InventoryItem.kUser] = userReference
            record[InventoryItem.kExpiry] = Date()
            record[InventoryItem.kIsGift] = 0
            
            records.append(record)
        }
        
        
        CloudKitManager.shared.batchSave(records: records) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            switch result {
            
                case .success(let records):
                    CloudKitManager.shared.importedRecords = records
                    DispatchQueue.main.async {
                        for id in itemToDelete {
                            self.shoppingList.removeAll() {$0.id == id}
                        }
                        self.selectedShoppingListItems.removeAll()
                        self.saveShoppingList()
                        self.alertItem = AlertContext.importInventoryItems
                    }
                    
                case .failure(_):
                    self.alertItem = AlertContext.failToImportItems
            }
        }
    }
}
