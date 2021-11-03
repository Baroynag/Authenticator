// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: GoogleAuthenticator.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct MigrationPayload {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var otpParameters: [MigrationPayload.OtpParameters] = []

  var version: Int32 = 0

  var batchSize: Int32 = 0

  var batchIndex: Int32 = 0

  var batchID: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum Algorithm: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case unspecified // = 0
    case sha1 // = 1
    case sha256 // = 2
    case sha512 // = 3
    case md5 // = 4
    case UNRECOGNIZED(Int)

    init() {
      self = .unspecified
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .sha1
      case 2: self = .sha256
      case 3: self = .sha512
      case 4: self = .md5
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .sha1: return 1
      case .sha256: return 2
      case .sha512: return 3
      case .md5: return 4
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  enum DigitCount: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case unspecified // = 0
    case six // = 1
    case eight // = 2
    case UNRECOGNIZED(Int)

    init() {
      self = .unspecified
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .six
      case 2: self = .eight
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .six: return 1
      case .eight: return 2
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  enum OtpType: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case unspecified // = 0
    case hotp // = 1
    case totp // = 2
    case UNRECOGNIZED(Int)

    init() {
      self = .unspecified
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .hotp
      case 2: self = .totp
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .hotp: return 1
      case .totp: return 2
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  struct OtpParameters {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var secret: Data = Data()

    var name: String = String()

    var issuer: String = String()

    var algorithm: MigrationPayload.Algorithm = .unspecified

    var digits: MigrationPayload.DigitCount = .unspecified

    var type: MigrationPayload.OtpType = .unspecified

    var counter: Int64 = 0

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}
}

#if swift(>=4.2)

extension MigrationPayload.Algorithm: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [MigrationPayload.Algorithm] = [
    .unspecified,
    .sha1,
    .sha256,
    .sha512,
    .md5,
  ]
}

extension MigrationPayload.DigitCount: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [MigrationPayload.DigitCount] = [
    .unspecified,
    .six,
    .eight,
  ]
}

extension MigrationPayload.OtpType: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [MigrationPayload.OtpType] = [
    .unspecified,
    .hotp,
    .totp,
  ]
}

#endif  // swift(>=4.2)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension MigrationPayload: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "MigrationPayload"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "otp_parameters"),
    2: .same(proto: "version"),
    3: .standard(proto: "batch_size"),
    4: .standard(proto: "batch_index"),
    5: .standard(proto: "batch_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034

      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.otpParameters) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.version) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.batchSize) }()
      case 4: try { try decoder.decodeSingularInt32Field(value: &self.batchIndex) }()
      case 5: try { try decoder.decodeSingularInt32Field(value: &self.batchID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.otpParameters.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.otpParameters, fieldNumber: 1)
    }
    if self.version != 0 {
      try visitor.visitSingularInt32Field(value: self.version, fieldNumber: 2)
    }
    if self.batchSize != 0 {
      try visitor.visitSingularInt32Field(value: self.batchSize, fieldNumber: 3)
    }
    if self.batchIndex != 0 {
      try visitor.visitSingularInt32Field(value: self.batchIndex, fieldNumber: 4)
    }
    if self.batchID != 0 {
      try visitor.visitSingularInt32Field(value: self.batchID, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: MigrationPayload, rhs: MigrationPayload) -> Bool {
    if lhs.otpParameters != rhs.otpParameters {return false}
    if lhs.version != rhs.version {return false}
    if lhs.batchSize != rhs.batchSize {return false}
    if lhs.batchIndex != rhs.batchIndex {return false}
    if lhs.batchID != rhs.batchID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension MigrationPayload.Algorithm: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "ALGORITHM_UNSPECIFIED"),
    1: .same(proto: "ALGORITHM_SHA1"),
    2: .same(proto: "ALGORITHM_SHA256"),
    3: .same(proto: "ALGORITHM_SHA512"),
    4: .same(proto: "ALGORITHM_MD5"),
  ]
}

extension MigrationPayload.DigitCount: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "DIGIT_COUNT_UNSPECIFIED"),
    1: .same(proto: "DIGIT_COUNT_SIX"),
    2: .same(proto: "DIGIT_COUNT_EIGHT"),
  ]
}

extension MigrationPayload.OtpType: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "OTP_TYPE_UNSPECIFIED"),
    1: .same(proto: "OTP_TYPE_HOTP"),
    2: .same(proto: "OTP_TYPE_TOTP"),
  ]
}

extension MigrationPayload.OtpParameters: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = MigrationPayload.protoMessageName + ".OtpParameters"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "secret"),
    2: .same(proto: "name"),
    3: .same(proto: "issuer"),
    4: .same(proto: "algorithm"),
    5: .same(proto: "digits"),
    6: .same(proto: "type"),
    7: .same(proto: "counter"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.secret) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.issuer) }()
      case 4: try { try decoder.decodeSingularEnumField(value: &self.algorithm) }()
      case 5: try { try decoder.decodeSingularEnumField(value: &self.digits) }()
      case 6: try { try decoder.decodeSingularEnumField(value: &self.type) }()
      case 7: try { try decoder.decodeSingularInt64Field(value: &self.counter) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.secret.isEmpty {
      try visitor.visitSingularBytesField(value: self.secret, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if !self.issuer.isEmpty {
      try visitor.visitSingularStringField(value: self.issuer, fieldNumber: 3)
    }
    if self.algorithm != .unspecified {
      try visitor.visitSingularEnumField(value: self.algorithm, fieldNumber: 4)
    }
    if self.digits != .unspecified {
      try visitor.visitSingularEnumField(value: self.digits, fieldNumber: 5)
    }
    if self.type != .unspecified {
      try visitor.visitSingularEnumField(value: self.type, fieldNumber: 6)
    }
    if self.counter != 0 {
      try visitor.visitSingularInt64Field(value: self.counter, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: MigrationPayload.OtpParameters, rhs: MigrationPayload.OtpParameters) -> Bool {
    if lhs.secret != rhs.secret {return false}
    if lhs.name != rhs.name {return false}
    if lhs.issuer != rhs.issuer {return false}
    if lhs.algorithm != rhs.algorithm {return false}
    if lhs.digits != rhs.digits {return false}
    if lhs.type != rhs.type {return false}
    if lhs.counter != rhs.counter {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
