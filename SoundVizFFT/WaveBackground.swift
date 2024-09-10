import SwiftUI

struct WaveBackground: View {
    @State private var phase = 0.0
    var strength: Double
    var frequency: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<10) { i in
                Wave(strength: strength, frequency: frequency, phase: self.phase)
                    .stroke(Color.white.opacity(Double(i) / 10), lineWidth: 5)
                    .offset(y: CGFloat(i) * 10)
            }
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.phase = .pi * 2
                }
            }
        }
    }
}

struct WaveBackground_Previews: PreviewProvider {
    static var previews: some View {
        WaveBackground(strength: 0.00001, frequency: 0.000030)
    }
}
