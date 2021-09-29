

import UIKit
import CloudKit

extension UIImage {
    static let man = UIImage(named: "man")!.withTintColor(.gray)
    static let foodPlaceholder = UIImage(named: "food-placeholder")!
    
    func convertToCKAsset(with recordName: String) -> CKAsset?{
        //Get our apps base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Directory url came back nil")
            return nil
        }
        //Append some unique identifier for our profile image
        let fileUrl = urlPath.appendingPathComponent(recordName)
        
        //Write the compressed image data to the location the addrss points to
        guard let imageData = self.jpegData(compressionQuality: 0.25) else { return nil}
        do {
            try imageData.write(to: fileUrl)
            //Create our CKAsset with the fileURL
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
}
