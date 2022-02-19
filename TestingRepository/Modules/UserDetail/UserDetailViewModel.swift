import Foundation

final class UserDetailViewModel: BaseViewModel {
    let user: User
    
    // MARK: - Initialization
    
    init(user: User) {
        self.user = user
    }
}
