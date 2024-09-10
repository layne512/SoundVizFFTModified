import Foundation
import Accelerate

func performFFT(on data: [Float]) -> [Float] {
    guard !data.isEmpty else {
        print("Empty data array")
        return []
    }
    
    let paddedLength = 1 << Int(ceil(log2(Double(data.count))))
    var paddedData = data
    paddedData.append(contentsOf: [Float](repeating: 0, count: paddedLength - data.count))
    
    let log2n = UInt(round(log2(Double(paddedLength))))
    let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))!
    
    var realp = [Float](repeating: 0, count: paddedLength / 2)
    var imagp = [Float](repeating: 0, count: paddedLength / 2)
    var magnitudes = [Float](repeating: 0.0, count: paddedLength / 2)
    
    realp.withUnsafeMutableBufferPointer { realPtr in
        imagp.withUnsafeMutableBufferPointer { imagPtr in
            var splitComplex = DSPSplitComplex(realp: realPtr.baseAddress!, imagp: imagPtr.baseAddress!)
            
            paddedData.withUnsafeBufferPointer { bufferPointer in
                bufferPointer.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: paddedLength) {
                    vDSP_ctoz(UnsafePointer($0), 2, &splitComplex, 1, vDSP_Length(paddedLength / 2))
                }
            }
            
            vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
            vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(paddedLength / 2))
        }
    }

    vDSP_destroy_fftsetup(fftSetup)
    
    return magnitudes
}

