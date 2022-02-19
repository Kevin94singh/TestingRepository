import Stevia
import UIKit

final class LoadingViewController: BaseViewController<NoViewModel> {
    
    // MARK: - Variables
    
    private weak var backgroundView: UIView!
    private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initialization
    
    init() {
        super.init(viewModel: NoViewModel())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let backgroundView = UIView()
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.sv(
            backgroundView.sv(
                blurEffectView
            ),
            activityIndicator
        )
        
        backgroundView.fillContainer()
        activityIndicator.width(70%).heightEqualsWidth().centerInContainer()
        
        self.backgroundView = backgroundView
        self.activityIndicator = activityIndicator
    }
    
    // MARK: - Style
    
    override func setStyle() {
        super.setStyle()
        navigationController?.navigationItem.hidesBackButton = true
    }
}
