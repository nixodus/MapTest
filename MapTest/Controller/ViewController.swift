//
//  ViewController.swift
//  MapTest
//
//  Created by Nicholas Piotrowski on 09/07/2018.
//  Copyright © 2018 Nicholas Piotrowski. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let PopupVC = MessageBoxViewController()
    var popup : KLCPopup? = nil
    
    var initMap : Bool = false
    var gamePadImageImageView : UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        popup = KLCPopup.init(contentView: PopupVC.view)
        PopupVC.buttonOK.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        
        
        if(initMap){
            
            initGamepad()
            
            let duration = 1.0
            
            if(gamePadImageImageView != nil){
                UIView.animate(withDuration: duration, animations: {
                    self.gamePadImageImageView?.frame = CGRect(x: (self.gamePadImageImageView?.frame.size.width)!/3, y: (self.gamePadImageImageView?.frame.size.height)!/2, width: (self.gamePadImageImageView?.frame.size.width)!, height: (self.gamePadImageImageView?.frame.size.height)!)
                })
            }
        }
    }
    
    
    // MARK: Buttons init
    
    func addButtons(){
        let screenSize = UIScreen.main.bounds
        
        let button = UIButton(frame: CGRect(x: screenSize.width - screenSize.width/4 - 50, y:  screenSize.width/8, width: screenSize.width/4, height: screenSize.width/4))
        button.backgroundColor = .green
        button.setImage(#imageLiteral(resourceName: "face"), for: .normal)
        button.layer.cornerRadius = screenSize.width/8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        view.addSubview(button)
        
        
        let button2 = UIButton(frame: CGRect(x: button.center.x+button.frame.size.width/6, y: button.center.y+button.frame.size.height/6, width: button.frame.size.width/3, height: button.frame.size.height/3))
        button2.backgroundColor = .blue
        button2.setTitle("23", for: .normal)
        button2.layer.cornerRadius = button.frame.size.height/6
        button2.clipsToBounds = true
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        
        view.addSubview(button2)
        
        
        let buttonAR = UIButton(frame: CGRect(x: screenSize.width - screenSize.width/5, y: screenSize.height - screenSize.width/5, width: screenSize.width/7, height: screenSize.width/7))
        buttonAR.backgroundColor = .blue
        buttonAR.setTitle("AR", for: .normal)
        buttonAR.layer.cornerRadius = screenSize.width/14
        buttonAR.clipsToBounds = true
        buttonAR.addTarget(self, action: #selector(buttonActionAR), for: .touchUpInside)
        
        view.addSubview(buttonAR)
        
    }
    
    
    func initGamepad(){
        let screenSize = UIScreen.main.bounds
        
        
        if gamePadImageImageView != nil{
            return;
        }else{
            let gamePadImageWidth = screenSize.width/3
            let gamePadImageHeight = screenSize.width/4
            //let gamePadImageX = screenSize.width/10
            let gamePadImageY = screenSize.width/8
            
            let gamePadImage = UIImage(named: "gamePad")
            gamePadImageImageView = UIImageView(image: gamePadImage!)
            gamePadImageImageView?.frame = CGRect(x: -gamePadImageWidth, y: gamePadImageY, width: gamePadImageWidth, height: gamePadImageHeight)
            gamePadImageImageView?.isUserInteractionEnabled = true
            view.addSubview(gamePadImageImageView!)
            
            let gamePadButon1 = UIButton(frame: CGRect(x: (gamePadImageImageView?.frame.width)!/6, y: (gamePadImageImageView?.frame.height)!/10, width: (gamePadImageImageView?.frame.width)!/3.5, height: (gamePadImageImageView?.frame.width)!/3.5))
            gamePadButon1.clipsToBounds = true
            gamePadButon1.setImage(#imageLiteral(resourceName: "customButton1"), for: .normal)
            gamePadButon1.addTarget(self, action: #selector(self.buttonAction3), for: .touchUpInside)
            gamePadImageImageView?.addSubview(gamePadButon1)
            
            let gamePadButon2 = UIButton(frame: CGRect(x: (gamePadImageImageView?.frame.width)! * 3.3/6, y: (gamePadImageImageView?.frame.height)!/10, width: (gamePadImageImageView?.frame.width)!/3.5, height: (gamePadImageImageView?.frame.width)!/3.5))
            gamePadButon2.clipsToBounds = true
            gamePadButon2.setImage(#imageLiteral(resourceName: "customButton2"), for: .normal)
            gamePadButon2.addTarget(self, action: #selector(self.buttonAction4), for: .touchUpInside)
            gamePadImageImageView?.addSubview(gamePadButon2)
        }
    }
    
    // MARK: Buttons actions
    
    @objc func buttonAction(sender: UIButton!) {
        PopupVC.mainLabel.text = "Button1 message"
        popup?.show();
        
        print(UIDevice.current.orientation.isPortrait)
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        PopupVC.mainLabel.text = "Button2 message"
        popup?.show();
    }
    
    @objc func buttonAction3(sender: UIButton!) {
        PopupVC.mainLabel.text = "Button3 message"
        popup?.show();
    }
    
    @objc func buttonAction4(sender: UIButton!) {
        PopupVC.mainLabel.text = "Button4 message"
        popup?.show();
    }
    
    @objc func buttonActionAR(sender: UIButton!) {
        let duration = 1.0
        
        if(gamePadImageImageView != nil){
            UIView.animate(withDuration: duration, animations: {
                self.gamePadImageImageView?.frame = CGRect(x: -(self.gamePadImageImageView?.frame.size.width)!, y: (self.gamePadImageImageView?.frame.size.height)! / 2, width: (self.gamePadImageImageView?.frame.size.width)!, height: (self.gamePadImageImageView?.frame.size.height)!)
            }, completion: { finished in
                self.performSegue(withIdentifier: "segueAR", sender: nil)
            })
        }
        
    }
    
    
    @objc func dismissPopup(sender:UIButton!){
        sender.dismissPresentingPopup()
    }
    
    
    // MARK: Maps methods
    
    func initializeMap(locValue : CLLocationCoordinate2D){
        initMap = true
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude), zoomLevel: 15, animated: false)
        view.addSubview(mapView)
        
        
        // Set the map view‘s delegate property.
        mapView.delegate = self
        
        addButtons()
        
        let belarusBallLocation = locationWithBearing(bearing: Double.pi,distanceMeters: 200,origin:locValue)
        
        
        let belarusBall = MGLPointAnnotation()
        belarusBall.coordinate = CLLocationCoordinate2D(latitude: belarusBallLocation.latitude, longitude: belarusBallLocation.longitude)
        belarusBall.title = "Belarus Ball"
        mapView.addAnnotation(belarusBall)
        
        
        let polandBallLocation = locationWithBearing(bearing: 0,distanceMeters: 200,origin:locValue)
        
        let polandBall = MGLPointAnnotation()
        polandBall.coordinate = CLLocationCoordinate2D(latitude: polandBallLocation.latitude, longitude: polandBallLocation.longitude)
        polandBall.title = "Poland Ball"
        mapView.addAnnotation(polandBall)
        
        
        let germanyBallLocation = locationWithBearing(bearing: Double.pi/2,distanceMeters: 200,origin:locValue)
        
        let germanyBall = MGLPointAnnotation()
        germanyBall.coordinate = CLLocationCoordinate2D(latitude: germanyBallLocation.latitude, longitude: germanyBallLocation.longitude)
        germanyBall.title = "Germany Ball"
        mapView.addAnnotation(germanyBall)
        
        viewDidAppear(true);
    }
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // get the custom reuse identifier for this annotation
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation: annotation)
        // try to reuse an existing annotation image, if it exists
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        // if the annotation image hasn‘t been used yet, initialize it here with the reuse identifier
        if annotationImage == nil {
            // lookup the image for this annotation
            let image = imageForAnnotation(annotation: annotation)
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
    }
    
    func reuseIdentifierForAnnotation(annotation: MGLAnnotation) -> String {
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title, title != nil {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle, subtitle != nil {
            reuseIdentifier += subtitle!
        }
        return reuseIdentifier
    }
    
    func imageForAnnotation(annotation: MGLAnnotation) -> UIImage {
        var imageName = ""
        if let title = annotation.title, title != nil {
            switch title! {
            case "Belarus Ball":
                imageName = "belarusball"
            case "Poland Ball":
                imageName = "polandball"
            case "Germany Ball":
                imageName = "germanyball"
                
            default:
                imageName = "defaultball"
            }
        }
        
        return UIImage(named: imageName)!
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if initMap == false{
            initializeMap(locValue: locValue)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

