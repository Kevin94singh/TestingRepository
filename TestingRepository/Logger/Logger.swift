import Foundation
import os.log

/// Contains pre-defined OSLog categories
struct LoggerCategory {
    /// Generic app logging category
    static var app: String { return "App" }
    /// Networking logging category
    static var networking: String { return "Networking" }
    /// Lifecycle logging category
    static var lifecycle: String { return "Lifecycle" }
    /// Database logging category
    static var database: String { return "Database" }
    /// Push notifications logging category
    static var pushNotifications: String { return "Push Notifications" }
}

/// Wrapper class for os_log function
struct Logger {
    /// Create OSLog with subsystem and category
    static func osLog(subsystem: String = Bundle.main.bundleIdentifier ?? "-", category: String) -> OSLog {
        return OSLog(subsystem: subsystem, category: category)
    }
    
    /// Create app log
    static func appLog() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.app)
    }
    
    /// Create networking log
    static func networkingLog() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.networking)
    }
    
    /// Create lifecycle log
    static func lifecycleLog() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.lifecycle)
    }
    
    /// Create database log
    static func databaseLog() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.database)
    }
    
    /// Create push notifications log
    static func pushNotificationsLog() -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.pushNotifications)
    }
}
