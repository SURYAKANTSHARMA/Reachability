//
//  ReachabilityViewAdaptor.swift
//  Reachability
//
//  Created by Rapido on 07/10/22.
//

import UIKit
import SwiftMessages

struct ReachabilityViewAdaptor {
    
    static let swiftMessage = ReachabilityViewAdaptor(onNetworkAvailable: SwiftMessages.removeNoInterentUI,
                                                      onNetworkUnavailable: SwiftMessages.showNoInternetUI)
    
    let onNetworkAvailable: (() -> Void)
    let onNetworkUnavailable: (() -> Void)
    
    init(onNetworkAvailable: @escaping () -> Void,
         onNetworkUnavailable: @escaping () -> Void) {
        self.onNetworkAvailable = onNetworkAvailable
        self.onNetworkUnavailable = onNetworkUnavailable
    }
    
    func updateNetworkStatus(_ status: Bool) {
        onNetworkAvailable()
        status ? onNetworkAvailable() : onNetworkUnavailable()
    }
    
}

extension SwiftMessages {
    public static func showNoInternetUI() {
        guaranteeMainThread {
            let status = MessageView.viewFromNib(layout: .statusLine)
            status.backgroundView.backgroundColor = UIColor.red
            status.bodyLabel?.textColor = UIColor.white
            status.configureContent(body: "Alas! No internet connection")
            var statusConfig = SwiftMessages.Config()
            statusConfig.preferredStatusBarStyle = .lightContent
            statusConfig.duration = .forever
            SwiftMessages.show(config: statusConfig, view: status)
        }
    }
    
    public static func removeNoInterentUI() {
        guaranteeMainThread {
            SwiftMessages.hide()
        }
    }
}



func guaranteeMainThread(work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
