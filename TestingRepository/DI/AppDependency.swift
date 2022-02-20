import Foundation

typealias HasNetworkDependencies = HasNetworkManager
typealias HasStoriesDependencies = HasStoriesApi

final class AppDependency: HasNetworkDependencies, HasStoriesDependencies {
    lazy var networkManager: NetworkableManager = NetworkManager(dependencies: self)
    lazy var storiesApi: StoriesServicing = StoriesService(dependencies: self)
}

protocol HasNoDependency {}

extension AppDependency: HasNoDependency {}

let dependencies = AppDependency()
