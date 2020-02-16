//
//  hotelViewController.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/11.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//
// for the record
import UIKit
import AVFoundation
class RecordVC: UIViewController , AVAudioRecorderDelegate, AVAudioPlayerDelegate{

class hotelViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    
    let userModel = travelModel.sharedInstance
    var counter = 0.0
    var time = Timer()
    var isplaying = true
    var audioRecorder: AVAudioRecorder!
    
    @objc func UpdateTimer(){
        counter = counter + 0.1
        TimerLabel.text = String(format: "%.1f", counter)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 0.0
        print("here")
        TimerLabel.text = String(counter)
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
   
    
    // actually stop the timer
    @IBAction func startTimer(_ sender: Any) {
        stopButton.isEnabled = false
        time.invalidate()
        isplaying = false
        stopButton.setTitle("Go back for latest record", for: .normal)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
