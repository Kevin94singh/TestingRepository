import RxSwift

/// View model base class
class BaseViewModel: ViewModelProtocol {
    
    // MARK: Properties
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
    
    /// Initializes view model with bind call
    init() {
        bind()
    }
    
    /// Binds actions in view model
    func bind() {
        disposeBag = DisposeBag()
    }
}
