//
// Copyright (C) 2016-present Instructure, Inc.
//   
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
    
    

import Foundation
import CanvasKit1
import Reachability
import SoPretty


class NetworkMonitor: NSObject {
    static func engage() {
        NotificationCenter.default.addObserver(sharedMonitor, selector: #selector(networkActivityStarted), name: NSNotification.Name.CKCanvasNetworkRequestStarted, object: nil)
        NotificationCenter.default.addObserver(sharedMonitor, selector: #selector(networkActivityEnded), name: NSNotification.Name.CKCanvasNetworkRequestFinished, object: nil)
        
    }
    
    fileprivate static let sharedMonitor = NetworkMonitor()
    
    fileprivate var inflightNetworkOps = 0
    
    func networkActivityStarted() {
        inflightNetworkOps += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func networkActivityEnded() {
        inflightNetworkOps -= 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = inflightNetworkOps > 0
    }
    
    
    // MARK: Reachability
    fileprivate let toast = ToastManager()
    
    func monitorReachability() {
        Reachability.forInternetConnection().stopNotifier()
        let reach = Reachability(hostName: "canvas.instructure.com")
        
        reach?.reachableBlock = { _ in
            DispatchQueue.main.async {
                self.toast.dismissNotification()
            }
        }
        reach?.unreachableBlock = { _ in
            DispatchQueue.main.async {
                let message = NSLocalizedString("Uh-oh! No Internet Connection", comment: "Notification over status bar that displays when not connected to the internet.")
                self.toast.statusBarToastFailure(message)
            }
        }
        
        reach?.startNotifier()
    }
}
