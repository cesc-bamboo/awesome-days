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
        let imgToShow = viewModel.image ?? UIImage(systemName: "exclamationmark.triangle.fill")!
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
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit * 0.7
        pdfView.scaleFactor = pdfView.minScaleFactor
        setImage(image, in: pdfView.document)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document?.removePage(at: 0)
        setImage(image, in: uiView.document)
    }
    
    private func setImage(_ image: UIImage, in document: PDFDocument?) {
        guard let document = document,
              let page = PDFPage(image: image) else { return }
        document.insert(page, at: 0)
    }
}
