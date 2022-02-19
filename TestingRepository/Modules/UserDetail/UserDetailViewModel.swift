import Foundation

final class UserDetailViewModel: BaseViewModel {
    let user: User
    
    init(user: User) {
        self.user = user
    }
}
