import UIKit
import RxSwift

class BaseViewController<ViewModelType>: UIViewController, ViewControllerStyleable, NibLoadable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }
    
    // MARK: Properties
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
        
    // MARK: View Model
    
    var viewModel: ViewModelType!
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ViewModelType) {
        super.init(nibName: nil, bundle: nil)
        
        defer {
            self.viewModel = viewModel
        }
    }
    
    deinit {}
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStyle()
        navigationController?.hideHairline()
        bind()
    }
    
    // MARK: Bind
    
    func bind() {
        disposeBag = DisposeBag()
    }
    
    // MARK: Style
    
    func setStyle() {
        self.setDefaultAttributesFor(style: AppStyle.main, for: self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setNavBackButton() {
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 15))
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc private func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Navigation methods
    
    func popToViewControllerType<T>(type: T.Type, completion: @escaping (Bool) -> Void) {
        for controller in self.navigationController!.viewControllers as Array where controller is T {
            _ = self.navigationController?.popToViewController(controller as UIViewController, animated: true)
            completion(true)
            return
        }
        
        completion(false)
    }
    
    // MARK: Actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

/// Empty class for BaseViewControllerNoVM
public struct NoViewModel {}

/// Base VC with no VM
class BaseViewControllerNoVM: BaseViewController<NoViewModel> {
    public init() {
        super.init(viewModel: NoViewModel())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
