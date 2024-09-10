import SwiftUI
import AVFoundation

struct RecordingView: View {
    @State private var recording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var timer: Timer?
    @State private var timeElapsed: Double = 0.0
    @State private var showUploadMessage = false
    @State private var showViewResultsButton = false
    @State private var fftData: [Float] = []
    @State private var analysisCompleteMessage = ""
    @State private var audioFilename: URL = RecordingView.getDocumentsDirectory().appendingPathComponent("recording.m4a")
    @State private var fftFilename: URL = RecordingView.getDocumentsDirectory().appendingPathComponent("fftData.csv")
    @State private var analyzing = false
    @State private var isShowingFFTView = false
    @State private var waveStrength: Double = 0.0
    @State private var waveFrequency: Double = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                WaveBackground(strength: waveStrength, frequency: waveFrequency)

                VStack {
                    if showUploadMessage {
                        Text("Voice Recorded Successfully. Cloud Upload In Progress. Stay Tuned.")
                            .font(.headline)
                            .padding()

                        if !analysisCompleteMessage.isEmpty {
                            Text(analysisCompleteMessage)
                                .font(.headline)
                                .padding()
                        }

                        Button(action: {
                            self.playRecording()
                        }) {
                            Text("Play Voice")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 20)

                        if !showViewResultsButton {
                            Button(action: {
                                self.startAnalysis()
                            }) {
                                Text("Analyze Voice")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)
                        } else {
                            Button(action: {
                                self.isShowingFFTView = true
                                print("View Results button clicked. isShowingFFTView = \(self.isShowingFFTView)")
                            }) {
                                Text("View Results")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)
                            .navigationDestination(isPresented: $isShowingFFTView) {
                                FFTView(fileURL: fftFilename)
                            }
                        }
                    } else if analyzing {
                        Text("Buckle Up and Get Ready for Your Results!")
                            .font(.headline)
                            .padding()
                    } else {
                        Text("Recording...")
                            .font(.largeTitle)
                            .padding()

                        Text(String(format: "%.2f s", timeElapsed))
                            .font(.headline)
                            .padding()

                        Spacer()
                    }
                }
                .padding()
            }
            .onAppear {
                configureAudioSession()
                startRecording()
            }
            .onDisappear {
                stopRecording()
            }
            .navigationTitle("Recording")
        }
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("Audio session configured successfully.")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        let recordingSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordingSettings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            recording = true
            print("Recording started.")
            startTimer()
            startMetering()
        } catch {
            print("Could not start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recording = false
        stopTimer()
        showUploadMessage = true
        print("Recording stopped.")
    }

    func startTimer() {
        timeElapsed = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeElapsed += 0.1
            if self.timeElapsed >= 3.0 {
                self.stopRecording()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func startMetering() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.audioRecorder?.updateMeters()
            let averagePower = self.audioRecorder?.averagePower(forChannel: 0) ?? -160
            let linearLevel = pow(10.0, Double(averagePower) / 20.0) // Convert to Double
            
            if averagePower < -50 {
                self.waveStrength = 0.0
                self.waveFrequency = 0.0
            } else {
                let scaledLevel = linearLevel * 100.0 // Adjust this to control sensitivity
                self.waveStrength = scaledLevel * 10.0
                self.waveFrequency = scaledLevel * 2.0
            }
            
            print("Wave Strength: \(self.waveStrength), Wave Frequency: \(self.waveFrequency)") // Debugging print
        }
    }

    func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing recording.")
        } catch {
            print("Could not play recording: \(error)")
        }
    }

    func startAnalysis() {
        analyzing = true
        analysisCompleteMessage = ""
        DispatchQueue.global().async {
            self.performFFTOnRecording()
        }
    }

    func performFFTOnRecording() {
        print("Performing FFT on recording")
        
        guard FileManager.default.fileExists(atPath: audioFilename.path) else {
            print("Recording file does not exist")
            DispatchQueue.main.async {
                self.analyzing = false
            }
            return
        }
        
        do {
            let audioFile = try AVAudioFile(forReading: audioFilename)
            let format = audioFile.processingFormat
            let frameCount = AVAudioFrameCount(audioFile.length)
            print("Frame count: \(frameCount)")
            
            guard frameCount > 0 else {
                print("Invalid frame count: \(frameCount)")
                DispatchQueue.main.async {
                    self.analyzing = false
                }
                return
            }
            
            if let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) {
                try audioFile.read(into: buffer)
                print("File read into buffer successfully")
                
                if let floatChannelData = buffer.floatChannelData {
                    let frameCount = Int(buffer.frameLength)
                    print("Buffer frame count: \(frameCount)")
                    
                    var audioBuffer = [Float](repeating: 0, count: frameCount)
                    for i in 0..<frameCount {
                        audioBuffer[i] = floatChannelData[0][i]
                    }
                    print("Audio buffer filled successfully")
                    
                    // Perform FFT
                    print("Starting FFT analysis")
                    fftData = performFFT(on: audioBuffer)
                    print("FFT analysis complete. FFT data count: \(fftData.count)")
                    saveFFTDataToFile(fftData)
                    analysisCompleteMessage = "Your Voice Has Been Analyzed."
                    DispatchQueue.main.async {
                        self.analyzing = false
                        self.showViewResultsButton = true
                        print("FFT analysis complete. showViewResultsButton = \(self.showViewResultsButton)")
                    }
                } else {
                    print("Buffer floatChannelData is nil.")
                    DispatchQueue.main.async {
                        self.analyzing = false
                    }
                }
            } else {
                print("Failed to create AVAudioPCMBuffer.")
                DispatchQueue.main.async {
                    self.analyzing = false
                }
            }
        } catch {
            print("Error reading audio file: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.analyzing = false
            }
        }
    }

    func saveFFTDataToFile(_ data: [Float]) {
        let csvString = data.map { String($0) }.joined(separator: "\n")
        do {
            try csvString.write(to: fftFilename, atomically: true, encoding: .utf8)
            print("FFT data saved to file: \(fftFilename.path)")
        } catch {
            print("Error saving FFT data to file: \(error)")
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}


