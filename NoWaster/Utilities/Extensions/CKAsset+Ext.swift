import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage() -> UIImage? {
        
        guard let fileUrl = self.fileURL else {
            return nil
        }
        
        do {
            let data = try Data (contentsOf: fileUrl)
            return UIImage(data: data) ?? nil
        } catch {
            return nil
        }
    }
}
