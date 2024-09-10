import SwiftUI

struct FFTView: View {
    var fftData: [Float] = []
    @State private var showReportView = false

    init(fileURL: URL) {
        do {
            let dataString = try String(contentsOf: fileURL)
            let dataLines = dataString.split(separator: "\n")
            fftData = dataLines.compactMap { Float($0) }
            print("FFT data loaded from file: \(fileURL.path)")
        } catch {
            print("Error loading FFT data from file: \(error)")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    let chartWidth = geometry.size.width - 50 // Adjusting width for axis
                    let chartHeight = geometry.size.height * 0.4 // Adjusting height to use top half
                    let maxY = fftData.max() ?? 1.0 // Find the maximum value in the FFT data for scaling
                    let maxX = 7000.0 // Maximum frequency value for x-axis
                    let step = chartWidth / CGFloat(maxX)

                    // Find the index to truncate the FFT data where the signal drops to zero
                    let truncationIndex = fftData.firstIndex(where: { $0 == 0 }) ?? fftData.count
                    let truncatedFFTData = Array(fftData[..<truncationIndex])

                    // Draw the FFT graph
                    Path { path in
                        for (index, fftValue) in truncatedFFTData.enumerated() {
                            let x = CGFloat(index) * step + 40 // Adjust x to account for left padding
                            let normalizedValue = CGFloat(fftValue) / CGFloat(maxY) // Convert Float to CGFloat
                            let y = chartHeight * (1 - normalizedValue) // Scale y based on normalized value

                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.red, lineWidth: 1)
                    .background(Color.white) // Set background color to white

                    // Draw axes
                    Path { path in
                        // Y-axis
                        path.move(to: CGPoint(x: 40, y: 0))
                        path.addLine(to: CGPoint(x: 40, y: chartHeight))

                        // X-axis
                        path.move(to: CGPoint(x: 40, y: chartHeight))
                        path.addLine(to: CGPoint(x: chartWidth + 40, y: chartHeight))
                    }
                    .stroke(Color.black, lineWidth: 1) // Set axes color to black

                    // Y-axis ticks and labels
                    ForEach(0..<6) { i in
                        let yPosition = chartHeight - (CGFloat(i) * chartHeight / 5)
                        Path { path in
                            path.move(to: CGPoint(x: 35, y: yPosition))
                            path.addLine(to: CGPoint(x: 40, y: yPosition))
                        }
                        .stroke(Color.black, lineWidth: 1) // Set ticks color to black

                        Text("\(Int(maxY * Float(i) / 5))")
                            .foregroundColor(.black) // Set label color to black
                            .font(.system(size: 10))
                            .position(x: 20, y: yPosition)
                    }

                    // X-axis ticks and labels
                    ForEach(0..<7) { i in
                        let xPosition = CGFloat(i) * chartWidth / 6 + 40
                        Path { path in
                            path.move(to: CGPoint(x: xPosition, y: chartHeight))
                            path.addLine(to: CGPoint(x: xPosition, y: chartHeight + 5))
                        }
                        .stroke(Color.black, lineWidth: 1) // Set ticks color to black

                        Text("\(Int(maxX * Double(i) / 6))")
                            .foregroundColor(.black) // Set label color to black
                            .font(.system(size: 10))
                            .rotationEffect(.degrees(-45)) // Rotate labels to avoid overlap
                            .position(x: xPosition, y: chartHeight + 15) // Adjust y position
                    }

                    // X-axis label
                    Text("Frequency (Hz)")
                        .foregroundColor(.black) // Set label color to black
                        .font(.system(size: 12)) // Adjust font size
                        .position(x: chartWidth / 2 + 40, y: chartHeight + 30) // Adjust position
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                .padding([.leading, .trailing], 30) // Ensure padding on both sides

                // Add the "Report" button below the FFT graph
                NavigationLink(destination: ReportView()) {
                    Text("Report")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct FFTView_Previews: PreviewProvider {
    static var previews: some View {
        FFTView(fileURL: URL(fileURLWithPath: ""))
    }
}
