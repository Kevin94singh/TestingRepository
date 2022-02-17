import RxSwift

/// View model protocol
protocol ViewModelProtocol: AnyObject {
    
    // MARK: Properties
    
    var disposeBag: DisposeBag { get }
    
    /// Binds actions in view model
    func bind()
}
