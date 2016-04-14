//
//  ViewController.swift
//  SaitamaPlayer
//
//  Created by Mark Torres on 4/13/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
	
	// MARK: Outlets and other vars
	
	var audioPlayer: AVAudioPlayer!
	var audioDuration: NSTimeInterval!
	var timer = NSTimer()
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var totalTimeLabel: UILabel!
	@IBOutlet weak var audioPositionSlider: UISlider!
	@IBOutlet weak var volumeSlider: UISlider!
	
	// MARK: Default functions

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// prepare audio
		let audioFile = "OnePunchManOP"
		let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioFile, ofType: "mp3")!)
		do {
			try audioPlayer = AVAudioPlayer(contentsOfURL: audioURL)
			audioPlayer.prepareToPlay()
			audioDuration = audioPlayer.duration
			audioPositionSlider.maximumValue = Float(audioDuration)
			totalTimeLabel.text = formatTime(audioDuration)
			titleLabel.text = audioFile
		} catch {
			audioPlayer = AVAudioPlayer()
			audioDuration = 0
			totalTimeLabel.text = "0:00"
		}
		
		audioPlayer.delegate = self
		currentTimeLabel.text = "0:00"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: Utility Functions
	
	func formatTime(time: NSTimeInterval) -> String {
		var timeString: String = "0:00"
		let minutes: Int = Int(time /  60)
		let seconds: Int = Int(time % 60)
		let minString = "\(minutes)"
		let secString = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
		timeString = "\(minString):\(secString)"
		return timeString
	}
	
	func displayAudioTime() {
		if audioPlayer.playing == true {
			currentTimeLabel.text = formatTime(audioPlayer.currentTime)
			audioPositionSlider.value = Float(audioPlayer.currentTime)
		}
	}
	
	// MARK: Audio Player delegate
	
	func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
		stopAudioPlayer()
	}

	// MARK: Player actions
	
	@IBAction func tapPlay(sender: AnyObject) {
		if audioPlayer.url != nil {
			audioPlayer.play()
			timer = NSTimer.scheduledTimerWithTimeInterval(0.5,
				target: self,
				selector: Selector("displayAudioTime"),
				userInfo: nil,
				repeats: true)
		}
	}
	
	func stopAudioPlayer() {
		if audioPlayer.url != nil{
			audioPlayer.stop()
			timer.invalidate()
			audioPlayer.currentTime = 0
			audioPositionSlider.value = 0
			currentTimeLabel.text = "0:00"
		}
	}
	
	@IBAction func tapPause(sender: AnyObject) {
		if audioPlayer.url != nil {
			audioPlayer.pause()
			timer.invalidate()
		}
	}
	
	@IBAction func tapStop(sender: AnyObject) {
		stopAudioPlayer()
	}
	
	@IBAction func setVolume(sender: AnyObject) {
		audioPlayer.volume = volumeSlider.value
	}
	
	@IBAction func setAudioPosition(sender: AnyObject) {
		// use Touch Up Inside, not Changed Value
		if audioPlayer.playing == true {
			if audioDuration > 0 {
				audioPlayer.currentTime = Double(audioPositionSlider.value)
			}
		} else {
			audioPositionSlider.value = 0
		}
	}
	
	@IBAction func tapRewind(sender: AnyObject) {
		if audioPlayer.playing == true {
			if audioPlayer.currentTime > 10.0 {
				audioPlayer.currentTime -= 10.0
			} else {
				audioPlayer.currentTime = 0
			}
		}
	}
	
	@IBAction func tapForward(sender: AnyObject) {
		if audioPlayer.playing == true {
			if ((audioPlayer.currentTime + 10.0) < audioPlayer.duration) {
				audioPlayer.currentTime += 10.0
			} else {
				audioPlayer.currentTime = audioPlayer.duration - 1.0
			}
		}
	}
	
}

