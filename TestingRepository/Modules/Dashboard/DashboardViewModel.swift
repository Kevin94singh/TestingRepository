import Action
import RxCocoa
import RxSwift

protocol DashboardViewModelInputs {
    var getDataAction: Action<Void, Story> { get set }
}

protocol DashboardViewModelOutputs {
    var dashboardData: BehaviorRelay<Story?> { get }
    var error: BehaviorRelay<Error?> { get }
    var isExecuting: BehaviorRelay<Bool> { get }
}

final class DashboardViewModel: BaseViewModel, DashboardViewModelInputs, DashboardViewModelOutputs {
    
    typealias Dependencies = HasNetworkDependencies & HasDashboardDependencies
    
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
            return self.dependencies.dashboardApi.getData()
        })
    }()
    
    // MARK: - Outputs
    
    let dashboardData = BehaviorRelay<Story?>(value: nil)
    let error = BehaviorRelay<Error?>(value: nil)
    let isExecuting = BehaviorRelay<Bool>(value: false)
}

extension DashboardViewModel {
    func bindAction() {
        getDataAction
            .elements
            .bind(to: dashboardData)
            .disposed(by: disposeBag)
        
        getDataAction.underlyingError
            .bind(to: error)
            .disposed(by: disposeBag)
        
        getDataAction.executing
            .bind(to: isExecuting)
            .disposed(by: disposeBag)
    }
}
