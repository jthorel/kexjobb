//
//  ViewController.swift
//  kex
//
//  Created by Johan Thorell on 2016-02-11.
//  Copyright © 2016 Johan Thorell. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation


class OwnPlayer: AVAudioPlayerNode {
    
    override func outputFormatForBus(bus: AVAudioNodeBus) -> AVAudioFormat {
        return OurFormat()
    }
}


class OurFormat: AVAudioFormat {
    
    override var channelCount: AVAudioChannelCount{
        get {
            return AVAudioChannelCount(1)
        }
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var engine = AVAudioEngine()
    var envNode = AVAudioEnvironmentNode()
    var player = OwnPlayer()
    
    /*var azimuth   = AKInstrumentProperty(value: 0.0, minimum: -180.0, maximum: 180.0)
    var elevation = AKInstrumentProperty(value: 0.0, minimum: -40.0,  maximum: 90.0)
    */
    



    /*
    var reverbFeedback = AKInstrumentProperty(value: 0.5, minimum: 0.0,    maximum: 0.99)
    var reverbLevel    = AKInstrumentProperty(value: 0.5, minimum: 0.0,    maximum: 0.99)
    */
    

    //MARK: PROPS
    var yaw: Float = 0
    var roll: Float = 0
    var pitch: Float = 0
    
    
    // MARK: UI Properties
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
   
    
    // MARK: Waypoints array
    var locationFirst = CLLocation(latitude: 59.382422, longitude: 18.031327)
    
    
    private var locationManager = CLLocationManager()
    var bearing = 0.0

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        envNode.reverbParameters.enable = true
        envNode.distanceAttenuationParameters.maximumDistance = 10
        envNode.renderingAlgorithm = .HRTF
        player.position = AVAudio3DPoint(x:0,y:0,z:10)
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: 0, pitch: 0 , roll: 0)

        
        
        let FITTURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tag", ofType: "wav")!)
        let minfil = try! AVAudioFile(forReading: FITTURL)

        
        // MARK: Audio init
        
        let mainMixer = engine.mainMixerNode


        
        // MARK: Audio connect nodes
        engine.attachNode(envNode)
        engine.attachNode(player)
        
        engine.connect(player, to: envNode, format: nil)
        engine.connect(envNode, to: mainMixer, format: nil)
        //engine.connect(mainMixer, to: output, format: format)
        
        
        // MARK: Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
        
        player.play()
        player.scheduleFile(minfil, atTime: nil, completionHandler: nil)
        player.scheduleFile(minfil, atTime: nil, completionHandler: nil)

        
        // MARK: Location manager
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        print("HeJ")
        print("\(locationFirst.coordinate)")
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Math methods
    func moduloegen(a: Double, n: Double) -> Double {
        return a - floor(a/n) * n
    }
    func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(point2.coordinate.latitude);
        let lon2 = degreesToRadians(point2.coordinate.longitude);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        let theta = (radiansToDegrees(radiansBearing)+360)%360
        
        return theta
    }
    
    // MARK: locationManagers
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /*var heading = newHeading.magneticHeading
        let bearing = getBearingBetweenTwoPoints1(locationManager.location!, point2: locationFirst)
        let distance = locationManager.location!.distanceFromLocation(locationFirst)
        let directionToGo = moduloegen(((bearing - heading)+180), n: 360)-180
        heading = moduloegen((heading+180), n: 360)-180
        let dirRad = degreesToRadians(abs(90-bearing))
        
        label1.text = "\(distance)"
        label2.text = "\(heading)"
        label3.text = "\(bearing)"
        label4.text = "\(directionToGo)"

        
        envNode.listenerPosition = AVAudio3DPoint(x:Float(sin(dirRad)*distance),y:0,z:Float(cos(dirRad)*distance))
        envNode.listenerPosition = AVAudio3DPoint(x:Float(cos(dirRad)),y:0,z:-Float(sin(dirRad)))
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: Float(heading), pitch: 0, roll: 0)*/
    }
    
    @IBAction func slida1(sender: UISlider) {
        yaw = sender.value
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch, roll: roll)
        
    }
    
    @IBAction func slid2(sender: UISlider) {
        pitch = sender.value
        
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch, roll: roll)
        
    }


}

