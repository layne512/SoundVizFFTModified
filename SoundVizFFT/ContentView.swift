import SwiftUI

struct ContentWave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double

    // allow SwiftUI to animate the wave phase
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // find how far we are from the horizontal center
            let distanceFromMidWidth = x - midWidth

            // bring that into the range of -1 to 1
            let normalDistance = oneOverMidWidth * distanceFromMidWidth

            let parabola = -(normalDistance * normalDistance) + 1

            // calculate the sine of that position, adding our phase offset
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = parabola * strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}

struct ContentView: View {
    @State private var phase1 = 0.0
    @State private var phase2 = Double.pi / 2
    @State private var phase3 = Double.pi
    @State private var phase4 = Double.pi * 3 / 2
    @State private var phase5 = Double.pi * 2
    @State private var phase6 = Double.pi * 5 / 2
    @State private var phase7 = Double.pi * 3

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                
                ForEach(0..<7) { i in
                    ContentWave(strength: 50, frequency: 10, phase: self.phase(for: i))
                        .stroke(Color.white.opacity(Double(7 - i) / 7), lineWidth: 5)
                        .offset(y: CGFloat(i) * 10)
                }
                
                VStack {
                    Image(systemName: "headphones.circle.fill")  // Placeholder logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding()

                    Text("Welcome to VoiceAnalyzer4.0")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Text("Are You Ready to Explore the Hidden World of Voices?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    NavigationLink(destination: RecordingView()) {
                        Text("Start Recording")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Text("Click the Start Recording button, and record your regular voice for 3 seconds. You can say anything you want.")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.phase1 = Double.pi * 2
                    self.phase2 = Double.pi * 2
                    self.phase3 = Double.pi * 2
                    self.phase4 = Double.pi * 2
                    self.phase5 = Double.pi * 2
                    self.phase6 = Double.pi * 2
                    self.phase7 = Double.pi * 2
                }
            }
        }
    }
    
    func phase(for index: Int) -> Double {
        switch index {
        case 0:
            return phase1
        case 1:
            return phase2
        case 2:
            return phase3
        case 3:
            return phase4
        case 4:
            return phase5
        case 5:
            return phase6
        case 6:
            return phase7
        default:
            return 0.0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
