//import Cocoa
//
//import Security
//
//// see https://stackoverflow.com/a/37539998/1694526
//
//// Arguments for the keychain queries
//
//let kSecClassValue = NSString(format: kSecClass)
//
//let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
//
//let kSecValueDataValue = NSString(format: kSecValueData)
//
//let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
//
//let kSecAttrServiceValue = NSString(format: kSecAttrService)
//
//let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
//
//let kSecReturnDataValue = NSString(format: kSecReturnData)
//
//let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
//
//public class KeychainService: NSObject {
//
//    class func updatePassword(service: String, account:String, data: String) {
//
//        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
//
//            // Instantiate a new default keychain query
//
//            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
//
//            if (status != errSecSuccess) {
//
//                if let err = SecCopyErrorMessageString(status, nil) {
//
//                    print(“Read failed: \(err)”)
//
//                }
//
//            }
//
//        }
//
//    }
//
//    class func removePassword(service: String, account:String) {
//
//        // Instantiate a new default keychain query
//
//        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//        // Delete any existing items
//
//        let status = SecItemDelete(keychainQuery as CFDictionary)
//
//        if (status != errSecSuccess) {
//
//            if let err = SecCopyErrorMessageString(status, nil) {
//
//                print(“Remove failed: \(err)”)
//
//            }
//
//        }
//
//    }
//
//    class func savePassword(service: String, account:String, data: String) {
//
//        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
//
//            // Instantiate a new default keychain query
//             let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
//
//            // Add the new keychain item
//
//            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
//
//            if (status != errSecSuccess) {    // Always check the status
//
//                if let err = SecCopyErrorMessageString(status, nil) {
//
//                    print(“Write failed: \(err)”)
//
//                }
//
//            }
//
//        }
//
//    }
//
//    class func loadPassword(service: String, account:String) -> String? {
//
//        // Instantiate a new default keychain query
//
//        // Tell the query to return a result
//
//        // Limit our results to one item
//
//        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//        var dataTypeRef :AnyObject?
//
//        // Search for the keychain items
//
//        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
//
//        var contentsOfKeychain: String?
//
//        if status == errSecSuccess {
//
//            if let retrievedData = dataTypeRef as? Data {
//
//                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
//
//            }
//
//        } else {
//
//            print(“Nothing was retrieved from the keychain. Status code \(status)”)
//
//        }
//
//        return contentsOfKeychain
//
//    }
//
//}
//
//You need to imagine the following wired up to a text input field and a label, then having four buttons wired up, one for each of the methods.
//
//class ViewController: NSViewController {
//
//    @IBOutlet weak var enterPassword: NSTextField!
//
//    @IBOutlet weak var retrievedPassword: NSTextField!
//
//    let service = “myService”
//
//    let account = “myAccount”
//
//    // will only work after
//
//    @IBAction func updatePassword(_ sender: Any) {
//
//        KeychainService.updatePassword(service: service, account: account, data: enterPassword.stringValue)
//
//    }
//
//    @IBAction func removePassword(_ sender: Any) {
//
//        KeychainService.removePassword(service: service, account: account)
//
//    }
//
//    @IBAction func passwordSet(_ sender: Any) {
//
//        let password = enterPassword.stringValue
//
//        KeychainService.savePassword(service: service, account: account, data: password)
//
//    }
//
//    @IBAction func passwordGet(_ sender: Any) {
//
//        if let str = KeychainService.loadPassword(service: service, account: account) {
//
//            retrievedPassword.stringValue = str
//
//        }
//
//        else {retrievedPassword.stringValue = “Password does not exist” }
//
//    }
//
//}
