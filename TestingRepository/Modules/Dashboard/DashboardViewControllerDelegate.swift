import Foundation

protocol DashboardViewControllerDelegate: AnyObject {
    func dashboardViewControllerDelegateShowUser(detail: User)
}
