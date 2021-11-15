//
//  mainScreen.swift
//  ugu
//
//  Created by Darius Kashani on 9/5/21.
//

import Foundation
import UIKit
import MessageUI
import PDFKit
import AVFoundation



class mainScreen : UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate {
    
    
    
    
    @IBAction func record1Act(_ sender: Any) {
        if (isRecording1) {
            finishAudioRecording1(success: true);
            record1.setTitle("Record", for: .normal)
            play1.isEnabled = true;
            isRecording1 = false;
        }
        else {
            setUpRecorder();
            
            audioRecPartner1.record();
            record1.setTitle("Stop", for: .normal)
            play1.isEnabled = false;
            isRecording1 = true;
            
        }
    }
    func preparePlayer1() {
        do {
            audioPlayPartner1 = try AVAudioPlayer(contentsOf: getFileURL(name: "Recording1.m4a"))
        }
        catch let error {
            displayAlert(title: "Error", message: error.localizedDescription);
        }
    }
    
    @IBAction func play1Act(_ sender: Any) {
        
        if (isPlaying1) {
            audioPlayPartner1.stop();
            record1.isEnabled = true;
            play1.setTitle("Play", for: .normal);
            isPlaying1 = false;
        }
        else if (FileManager.default.fileExists(atPath: getFileURL(name: "Recording1.m4a").path)) {
            record1.isEnabled = false;
            play1.setTitle("Pause", for: .normal)
            preparePlayer1();
            audioPlayPartner1.play();
            isPlaying1 = true;
        }
        else {
            displayAlert(title: "Error", message: "No recorded audio");
        }
         
    }
    @IBOutlet weak var play1: UIButton!
    @IBOutlet weak var record1: UIButton!
    @IBOutlet weak var nameBox1: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController();
        mailComposeVC.mailComposeDelegate = self;
        var sendTo:[String] = [String](repeating:"", count:1);
        if (nameBox1 != nil) {
            sendTo[0] = nameBox1.text!;
            
        }
        else {
            sendTo[0] = "";
        }
        mailComposeVC.setToRecipients(sendTo);
        mailComposeVC.setSubject("Consent Form");
        mailComposeVC.setMessageBody(nameBox1.text!, isHTML: false);
        
        return mailComposeVC;
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil);
    }
    
    
    
    
    @IBOutlet weak var emailBox1: UITextField!
    
    
    @IBAction func submitButton(_ sender: Any) {
        let mailcomposer = configuredMailComposeViewController();
        if (MFMailComposeViewController.canSendMail()) {
                    self.present(mailcomposer, animated: true, completion: nil)
        }
        else {
            displayAlert(title: "Error", message: "Could not send email");
        }
    }
    @IBOutlet var tapTesty: UITapGestureRecognizer!
    @IBOutlet weak var SignatureBox1: UILabel!
    
    @IBAction func tapTest(_ sender: Any) {
        print("tapped")
    }
    
    var isAudioRecordingGranted:Bool!;
    
    var audioRecPartner1:AVAudioRecorder!;
    var audioPlayPartner1:AVAudioPlayer!;
    var isPlaying1 = false;
    var isRecording1 = false;
    
    var audioRecPartner2:AVAudioRecorder!;
    var audioPlayPartner2:AVAudioPlayer!;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nameBox1.autocorrectionType = UITextAutocorrectionType.no;
        nameBox1.isEnabled = true;
        nameBox1.text = "Input person 1 name here";
        
        emailBox1.autocorrectionType = UITextAutocorrectionType.no;
        emailBox1.isEnabled = true;
        emailBox1.text = "Input person 1 email here";
        
        
        
        
        
        
        SignatureBox1.font = .italicSystemFont(ofSize: 30);
        SignatureBox1.backgroundColor = .black
        SignatureBox1.textAlignment = .center;
        
        SignatureBox1.isEnabled = true;
        SignatureBox1.isHidden = false;
        print(tapTesty.numberOfTouchesRequired)
        print(tapTesty.numberOfTapsRequired)
        SignatureBox1.addGestureRecognizer(tapTesty);
        
        // check for audio recording permission
        checkRecordPerms();
        // sleep(2000);
        
        
        
        
    }
    
    func checkRecordPerms() {
        switch (AVAudioSession.sharedInstance().recordPermission){
        case .granted:
            isAudioRecordingGranted = true;
            break;
        case .denied:
            isAudioRecordingGranted = false;
            break;
            
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed)
                in if (allowed) {
                    self.isAudioRecordingGranted = true;
                }
                else {
                    self.isAudioRecordingGranted = false;
                }
            });
            break;
            
        default:
            break;
            
        }
    }
    
    func play1Finished(_ player: AVAudioPlayer, success flag:Bool) {
        record1.isEnabled = true;
    }
    
    func setUpRecorder() {
        if (isAudioRecordingGranted) {
            let session = AVAudioSession.sharedInstance();
            do {
                try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true);
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey:44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high
                        .rawValue
                ];
                audioRecPartner1 = try AVAudioRecorder(url: getFileURL(name: "Recording1.m4a"), settings: settings);
                audioRecPartner1.delegate = self;
                audioRecPartner1.isMeteringEnabled = true;
                audioRecPartner1.prepareToRecord();
                
                
            }
            catch let error {
                displayAlert(title: "Error", message: error.localizedDescription);
            }
        }
        else {
            displayAlert(title: "Error", message: "Audio recording permission is not granted, enable the microphone in settings first");
        }
    }
    
    
    
    func displayAlert (title:String, message:String) {
        let testAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        self.present(testAlert, animated: true, completion: nil);
        testAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil));
    }
    
    func finishAudioRecording1 (success:Bool ) {
        if (success) {
            audioRecPartner1.stop();
            audioRecPartner1 = nil;
            print("Recorded successfully")
        }
        else {
            displayAlert(title: "Error", message: "Audio recording failed")
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0];
        return documentDirectory;
    }
    func getFileURL(name:String) -> URL {
        let path = getDocumentDirectory().appendingPathComponent(name);
        return path;
    }
    
    
    
    
    
}
