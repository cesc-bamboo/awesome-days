//
//  PhotoDetailView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 29/6/21.
//

import SwiftUI
import PDFKit

struct PhotoDetailView: View {
    @ObservedObject var viewModel: PhotoDetailViewModel
    
    var body: some View {
        let imgToShow = viewModel.image ?? UIImage(systemName: "clock.arrow.circlepath")!
        return PDFImageView(image: imgToShow)
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailViewModel(image: UIImage(named: "test_image")!).instantiateView()
    }
}

struct PDFImageView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument()
        pdfView.autoScales = true
        pdfView.maxScaleFactor = 3.0
        pdfView.minScaleFactor = calculateMinScale(pdfView: pdfView, image: image)
        pdfView.scaleFactor = pdfView.minScaleFactor
        setImage(image, in: pdfView.document)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document?.removePage(at: 0)
        
        uiView.minScaleFactor = calculateMinScale(pdfView: uiView, image: image)
        uiView.scaleFactor = uiView.minScaleFactor
        setImage(image, in: uiView.document)
    }
    
    private func setImage(_ image: UIImage, in document: PDFDocument?) {
        guard let document = document,
              let page = PDFPage(image: image) else { return }
        document.insert(page, at: 0)
    }
    
    private func calculateMinScale(pdfView: PDFView, image: UIImage) -> Double {
        let widthRatio = pdfView.frame.width / image.size.width
        let heightRatio = pdfView.frame.height / image.size.height
        let minRatio = min(widthRatio, heightRatio)
        print("Min ratio: \(minRatio)")
        return minRatio
    }
}
