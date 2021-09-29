

import Firebase
import UIKit

final class DatabaseManager: ObservableObject {
    
    private init() {}
    static let shared = DatabaseManager()
    let database = Database.database(url: "https://nowaster-8f0c5-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    func createNewChat(with otherUid: String, firstMessage: Message, completion: @escaping (Chat?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseReference = database.child(uid)
        
        
        databaseReference.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String : Any] else {
                completion(nil)
                return
            }
            
            var content = ""
            let messageDate = firstMessage.sentDate
            let dateString = MessageViewModel.dateFormatter.string(from: messageDate)
            let chatId = firstMessage.id
            
            switch firstMessage.type {
            
            case .text(let textMessage):
                content = textMessage
            case .image(_):
                break
            }
            
            
            let newChatData: [String : Any] = [
                "id" : chatId,
                "other_uid" : otherUid,
                "latest_message" : [
                    "date" : dateString,
                    "message" : content,
                    "is_read" : false
                ]
            ]
            
            let recipientNewChatData: [String : Any] = [
                "id" : chatId,
                "other_uid" : uid,
                "latest_message" : [
                    "date" : dateString,
                    "message" : content,
                    "is_read" : false
                ]
            ]
            
            //MARK:- Update recipitent chats entry
            self?.database.child("\(otherUid)/chats").observeSingleEvent(of: .value) { snapshot in
                if var chats = snapshot.value as? [[String : Any]]{
                    chats.append(recipientNewChatData)
                    self?.database.child("\(otherUid)/chats").setValue(chats)
                } else {
                    self?.database.child("\(otherUid)/chats").setValue([recipientNewChatData])
                }
            }
            
            
            
            //MARK:- Update current user chats entry
            if var chats = userNode["chats"] as? [[String : Any]] {
                chats.append(newChatData)
                userNode["chats"] = chats
            } else {
                userNode["chats"] = [newChatData]
            }
            
            databaseReference.setValue(userNode, withCompletionBlock: { [weak self] error, reference in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                let chat = Chat(id: chatId, otherUid: otherUid, latestMessage: LatestMessage(date: dateString, text: content, isRead: false))
                
                self?.finishCreatingChat(chat: chat, firstMessage: firstMessage, completion: completion)
            })
        }
    }
    
    
    private func finishCreatingChat(chat: Chat, firstMessage: Message, completion: @escaping (Chat?) -> Void) {
        
        
        let messageDate = firstMessage.sentDate
        let dateString = MessageViewModel.dateFormatter.string(from: messageDate)
        var content = ""
       
        switch firstMessage.type {
        
        case .text(let textMessage):
            content = textMessage
        case .image(_):
            break
        }
        
        let collectionMessage: [String : Any] = [
            "id": firstMessage.id,
            "type": firstMessage.type.description,
            "content": content,
            "date": dateString,
            "sender_uid" : firstMessage.sender,
            "is_read": false
        ]
        
        let value: [String : Any] = [
            "messages" : [collectionMessage]
        ]
        
        database.child(chat.id).setValue(value) { error, reference in
            guard error == nil else {
                completion(nil)
                return
            }
            completion(chat)
        }
    }
    
    
    func getAllChats(for uid: String, completion: @escaping ([Chat]?) -> Void) {
        database.child("\(uid)/chats").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String : Any]] else {
                completion(nil)
                return
            }
            
            let chats: [Chat] = value.compactMap { dictionary in
                guard let chatId = dictionary["id"] as? String,
                      let otherUid = dictionary["other_uid"] as? String,
                      let latestMessageDictionary = dictionary["latest_message"] as? [String : Any],
                      let date = latestMessageDictionary["date"] as? String,
                      let message = latestMessageDictionary["message"] as? String,
                      let isRead = latestMessageDictionary["is_read"] as? Bool
                else {
                    return nil
                }
                
                let latestMessage = LatestMessage(date: date, text: message, isRead: isRead)
                return Chat(id: chatId, otherUid: otherUid, latestMessage: latestMessage)
            }
            completion(chats)
        }
    }
    
    
    func getAllMessagesForChat(with id: String, completion: @escaping ([Message]?) -> Void) {
        database.child("\(id)/messages").observe(.value) { snapshot in

            guard let value = snapshot.value as? [[String : Any]] else {
                completion(nil)
                return
            }

            let messages :[Message] = value.compactMap { dictionary in
                guard let isRead = dictionary["is_read"] as? Bool,
                      let id = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let sender = dictionary["sender_uid"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let type = dictionary["type"] as? String,
                      let date = MessageViewModel.dateFormatter.date(from: dateString)
                else { return nil }
               
                return Message(sender: sender, id: id, sentDate: date, type: .text(content))
            }

            completion(messages)
        }
    }
    
    
    func sendMessage(to chatId: String, message: Message, completion: @escaping (Bool) -> Void) {
        
        database.child("\(chatId)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var currentMessages = snapshot.value as? [[String : Any]], let self = self  else {
                completion(false)
                return
            }
            
            let messageDate = message.sentDate
            let dateString = MessageViewModel.dateFormatter.string(from: messageDate)
            var content = ""
           
            switch message.type {
            
            case .text(let textMessage):
                content = textMessage
            case .image(_):
                break
            }
            
            let newMessageEntry: [String : Any] = [
                "id": message.id,
                "type": message.type.description,
                "content": content,
                "date": dateString,
                "sender_uid" : message.sender,
                "is_read": false
            ]
            
            currentMessages.append(newMessageEntry)
            
            let latestMessage: [String : Any] = [
                "date" : dateString,
                "is_read" : false,
                "message" : content
            ]
            // Add new message to messages
            self.database.child("\(chatId)/messages").setValue(currentMessages) { [weak self] error, _ in
                guard error == nil, let self = self else {
                    completion(false)
                    return
                }
                // Update sender latest message
                self.updateSenderChat(chatId: chatId, uid: message.sender, latestMessage: latestMessage, completion: completion)
            }
        }
    }
    
    
    private func updateSenderChat(chatId: String, uid: String, latestMessage: [String : Any], completion: @escaping (Bool) -> Void) {
        self.database.child("\(uid)/chats").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var currentChats = snapshot.value as? [[String : Any]], let self = self else {
                completion(false)
                return
            }
            
            var targetChat: [String : Any]?
            var position = 0
            
            for chat in currentChats {
                if let id = chat["id"] as? String, id == chatId {
                    targetChat = chat
                    break
                }
                position += 1
            }
            
            targetChat?["latest_message"] = latestMessage
            guard let updatedChat = targetChat else {
                completion(false)
                return
            }
            
            currentChats[position] = updatedChat
            
            guard let otherUid = updatedChat["other_uid"] as? String else {
                completion(false)
                return
            }
            
            self.database.child("\(uid)/chats").setValue(currentChats) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                // Update recipient latest message
                self.updateRecipientChat(chatId: chatId, uid: otherUid, latestMessage: latestMessage, completion: completion)
            }
        }
    }
    
    
    private func updateRecipientChat(chatId: String, uid: String, latestMessage: [String : Any], completion: @escaping (Bool) -> Void) {
        self.database.child("\(uid)/chats").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var currentChats = snapshot.value as? [[String : Any]], let self = self else {
                completion(false)
                return
            }
            
            var targetChat: [String : Any]?
            var position = 0
            
            for chat in currentChats {
                if let id = chat["id"] as? String, id == chatId {
                    targetChat = chat
                    break
                }
                position += 1
            }
            
            targetChat?["latest_message"] = latestMessage
            guard let updatedChat = targetChat else {
                completion(false)
                return
            }
            
            currentChats[position] = updatedChat
            
            self.database.child("\(uid)/chats").setValue(currentChats) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    
    func fetchAllChats(completion: @escaping ([String]?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.database.child("\(uid)/chats").observeSingleEvent(of: .value) {snapshot in
            guard let currentChats = snapshot.value as? [[String : Any]] else {
                completion(nil)
                return
            }
            
            guard let recipientUids = currentChats.map({ $0["other_uid"] }) as? [String] else {
                completion(nil)
                return
            } 
            completion(recipientUids)
        }
    }
}

