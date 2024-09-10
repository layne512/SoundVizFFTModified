import SwiftUI

struct SoundWaveView: View {
    var audioLevels: [Float]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let step = width / CGFloat(max(audioLevels.count - 1, 1))

                for (index, level) in audioLevels.enumerated() {
                    let x = CGFloat(index) * step
                    let normalizedLevel = CGFloat(level + 160) / 160 // Normalize to range [0, 1]
                    let y = height * (1 - normalizedLevel) // Invert the graph

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

struct SoundWaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundWaveView(audioLevels: [Float](repeating: 0.5, count: 100))
    }
}

