//
//  QRImageScaner.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 15.09.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import UIKit
import Base32

enum QRCodeScanerError: Error {
    case missingDataInUrl
    case dataDecodingError
    case wrongProtbufFormat
    case otpParametersParsingFailled
    case failledScanningQR
}

final class QRImageScaner {

    class private func scanQrFromStaticImage(image: UIImage) -> String? {

        var qrStrinVgalue: String?

        if let ciImage = CIImage.init(image: image) {

            var options: [String: Any]
            let context = CIContext()

            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]

            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)

            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            if let features = qrDetector?.features(in: ciImage, options: options) {
                for case let row as CIQRCodeFeature in features {
                    qrStrinVgalue = row.messageString
                }
            }
        }

        return qrStrinVgalue
    }

    class public func getQueryStringParameter(url: URLComponents, param: String) -> String? {
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    class private func decodeProtobufInfo(urlString: String) throws -> MigrationPayload? {

        var protobufData: MigrationPayload?

        guard let url = URLComponents(string: urlString) else {
            return nil
        }

        guard let qrDataString = getQueryStringParameter(url: url, param: "data") else {
            throw QRCodeScanerError.missingDataInUrl
        }

        do {
            guard let data = Data(base64Encoded: qrDataString, options: .ignoreUnknownCharacters)
            else {
                throw QRCodeScanerError.dataDecodingError}
            protobufData = try MigrationPayload(serializedData: data)
        }

        return protobufData
    }

    class private func getMigrationData (qrStrinVgalue: String?) -> MigrationPayload? {

        guard let qrStrinVgalue = qrStrinVgalue else {return nil}

        var migrationData: MigrationPayload?

        do {
            migrationData = try decodeProtobufInfo(urlString: qrStrinVgalue)
        } catch {
            print(error.localizedDescription)
        }
        return migrationData
    }

    class public func getMigrationDataFromURLString (urlString: String) -> MigrationPayload? {
        let migrationData = getMigrationData(qrStrinVgalue: urlString)
        return migrationData
    }

    class public func getGoogleAuthenticatorInfo(image: UIImage) -> MigrationPayload? {
        var migrationData: MigrationPayload?
        if let qrString  = scanQrFromStaticImage(image: image) {
            migrationData = getMigrationData(qrStrinVgalue: qrString)
        }
        return migrationData
    }
}

extension String {
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
