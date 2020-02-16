
import UIKit
import AVFoundation

class hotelViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    let userModel = travelModel.sharedInstance
    var counter = 0.0
    var time = Timer()
    var isplaying = true
    var isAudioRecordingGranted: Bool!
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    
    @objc func UpdateTimer(){
        counter = counter + 0.1
        TimerLabel.text = String(format: "%.1f", counter)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 0.0
        check_record_permission();
        let temp = isAudioRecordingGranted
        if(temp == true)
        {
            print("here");
            TimerLabel.text = String(counter)
            time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            setup_recorder()
            print("record")
            isRecording = true
        }
        else
        {
            finishAudioRecording(success: true)
            isRecording = false
        }
    }
    
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        userModel.AudioFilePath = filePath
        print (filePath)
        return filePath
    }
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                     AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                     AVSampleRateKey: 44100,
                     AVNumberOfChannelsKey: 2,
                     AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self as AVAudioRecorderDelegate
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
    }
    
    @IBAction func Stop(_ sender: UIButton) {
        if let a = audioRecorder {
            a.stop()
            fillRow(words: AudioRequest().postData())
        }
    }
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            if let a = audioRecorder {
                a.stop()
                //print("end")
            }
            audioRecorder = nil
            print("recorded successfully.")
        }
//        else
//        {
//            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
//        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
    }
    func fillRow(words : [String]) {
        let dateT = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: dateT)
        let re = Record(date: formattedDate,keywords: words, userID: -1)
        userModel.save(rec: re)
        userModel.currentUser.addRecord(r: re)
    }
    override func viewDidDisappear(_ animated: Bool) {
        TimerLabel.text = String(counter)
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    // actually stop the timer
    @IBAction func startTimer(_ sender: Any) {
        stopButton.isEnabled = false
        time.invalidate()
        isplaying = false
        stopButton.setTitle("Go back for latest record", for: .normal)
    }
}

