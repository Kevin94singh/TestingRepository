import RxSwift

protocol HasStoriesApi {
    var storiesApi: StoriesServicing { get }
}

protocol StoriesServicing {
    func getData() -> Single<Story>
}

final class StoriesService {
    typealias Dependencies = HasNetworkDependencies
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension StoriesService: StoriesServicing {
    func getData() -> Single<Story> {
        return dependencies.networkManager.makeRequest(router: StoriesApiRouter.getData)
    }
}

