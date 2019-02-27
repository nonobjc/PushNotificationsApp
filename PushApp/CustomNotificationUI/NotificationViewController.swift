//
//  NotificationViewController.swift
//  CustomNotificationUI
//
//  Created by Alexander on 25/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

final class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        
        guard let latitude = userInfo["latitude"] as? CLLocationDistance,
            let longitude = userInfo["longitude"] as? CLLocationDistance,
        let radius = userInfo["radius"] as? CLLocationDistance else {
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)
        
        mapView.setRegion(region, animated: false)
    }

    func didReceive(_ response: UNNotificationResponse,
                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        defer { completion(.doNotDismiss) }
        
        guard let response = response as? UNTextInputNotificationResponse else {
            return
        }
        
        let text = response.userText
        infoLabel.text = text
    }
}
