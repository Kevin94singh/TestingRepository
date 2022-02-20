import Action
import RxCocoa
import RxSwift

protocol StoriesViewModelInputs {
    var getDataAction: Action<Void, Story> { get set }
}

protocol StoriesViewModelOutputs {
    var storiesData: BehaviorRelay<Story?> { get }
    var error: BehaviorRelay<Error?> { get }
    var isExecuting: BehaviorRelay<Bool> { get }
}

final class StoriesViewModel: BaseViewModel, StoriesViewModelInputs, StoriesViewModelOutputs {
    
    typealias Dependencies = HasNetworkDependencies & HasStoriesDependencies
    
    // MARK: - Dependencies
    
    let dependencies: Dependencies
    
    // MARK: - Initialization
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        bindAction()
    }
    
    // MARK: - Inputs
    
    lazy var getDataAction: Action<Void, Story> = {
        return Action(workFactory: { [unowned self] () -> Single<Story> in
            return self.dependencies.storiesApi.getData()
        })
    }()
    
    // MARK: - Outputs
    
    let storiesData = BehaviorRelay<Story?>(value: nil)
    let error = BehaviorRelay<Error?>(value: nil)
    let isExecuting = BehaviorRelay<Bool>(value: false)
}

extension StoriesViewModel {
    func bindAction() {
        getDataAction
            .elements
            .bind(to: storiesData)
            .disposed(by: disposeBag)
        
        getDataAction.underlyingError
            .bind(to: error)
            .disposed(by: disposeBag)
        
        getDataAction.executing
            .bind(to: isExecuting)
            .disposed(by: disposeBag)
    }
}
