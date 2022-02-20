import Foundation
import UIKit

enum UserDefaultsKey: String, CaseIterable {
    case didShowOnboarding = "testingRepository_didShowOnboarding"
}

private typealias UserDefaultsValues = UserDefaults
private typealias UserDefaultsFunctions = UserDefaults

extension UserDefaultsValues {
    public class var didShowOnboarding: Bool {
        get {
            return UserDefaults.get(key: .didShowOnboarding) ?? false
        }
        set (newValue) {
            UserDefaults.save(object: newValue, key: .didShowOnboarding)
        }
    }
}

extension UserDefaultsFunctions {
    fileprivate class func save<T>(object: T?, key: UserDefaultsKey) {
        UserDefaults.standard.set(object, forKey: key.rawValue)
    }
    
    fileprivate class func get<T>(key: UserDefaultsKey) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
