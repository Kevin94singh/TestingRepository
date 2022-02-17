import RxSwift

protocol HasDashboardApi {
    var dashboardApi: DashboardServicing { get }
}

protocol DashboardServicing {
    func getData() -> Single<Story>
}

final class DashboardService {
    typealias Dependencies = HasNetworkDependencies
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DashboardService: DashboardServicing {
    func getData() -> Single<Story> {
        return dependencies.networkManager.makeRequest(router: DashboardApiRouter.getData)
    }
}

