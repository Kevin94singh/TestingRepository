import Foundation

typealias HasNetworkDependencies = HasNetworkManager
typealias HasDashboardDependencies = HasDashboardApi

final class AppDependency: HasNetworkDependencies, HasDashboardDependencies {
    lazy var networkManager: NetworkableManager = NetworkManager(dependencies: self)
    lazy var dashboardApi: DashboardServicing = DashboardService(dependencies: self)
}

protocol HasNoDependency {}

extension AppDependency: HasNoDependency {}

let dependencies = AppDependency()
