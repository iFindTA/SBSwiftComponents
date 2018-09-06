//
//  RSAKit.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/6.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import Security
import Foundation

public typealias DigestAlgorithmClosure = (_ data: UnsafePointer<UInt8>, _ dataLength: UInt32) -> [UInt8]

public enum DigestAlgorithm: CustomStringConvertible {
    case md2, md4, md5, sha1, sha224, sha256, sha384, sha512
    
    func progressClosure() -> DigestAlgorithmClosure {
        var closure: DigestAlgorithmClosure?
        
        switch self {
        case .md2:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_MD2($0, $1, &hash)
                return hash
            }
        case .md4:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_MD4($0, $1, &hash)
                return hash
            }
        case .md5:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_MD5($0, $1, &hash)
                return hash
            }
        case .sha1:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_SHA1($0, $1, &hash)
                return hash
            }
        case .sha224:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_SHA224($0, $1, &hash)
                return hash
            }
        case .sha256:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_SHA256($0, $1, &hash)
                return hash
            }
        case .sha384:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_SHA384($0, $1, &hash)
                return hash
            }
        case .sha512:
            closure = {
                var hash = [UInt8](repeating: 0, count: self.digestLength())
                CC_SHA512($0, $1, &hash)
                return hash
            }
        }
        return closure!
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .md2:
            result = CC_MD2_DIGEST_LENGTH
        case .md4:
            result = CC_MD4_DIGEST_LENGTH
        case .md5:
            result = CC_MD5_DIGEST_LENGTH
        case .sha1:
            result = CC_SHA1_DIGEST_LENGTH
        case .sha224:
            result = CC_SHA224_DIGEST_LENGTH
        case .sha256:
            result = CC_SHA256_DIGEST_LENGTH
        case .sha384:
            result = CC_SHA384_DIGEST_LENGTH
        case .sha512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    public var description: String {
        get {
            switch self {
            case .md2:
                return "Digest.MD2"
            case .md4:
                return "Digest.MD4"
            case .md5:
                return "Digest.MD5"
            case .sha1:
                return "Digest.SHA1"
            case .sha224:
                return "Digest.SHA224"
            case .sha256:
                return "Digest.SHA256"
            case .sha384:
                return "Digest.SHA384"
            case .sha512:
                return "Digest.SHA512"
            }
        }
    }
}

extension String {
    /// Digest to an array of UInt8
    public func digestBytes(_ algorithm:DigestAlgorithm)->[UInt8]{
        let data = self.data(using: String.Encoding.utf8)
        return data!.digestBytes(algorithm)
    }
    /// Digest with an algorithm
    public func digestData(_ algorithm:DigestAlgorithm)->Data{
        let data = self.data(using: String.Encoding.utf8)
        return data!.digestData(algorithm)
    }
    /// Digest with an algorithm to a hexadecimal string
    public func digestHex(_ algorithm:DigestAlgorithm)->String{
        let data = self.data(using: String.Encoding.utf8)
        return data!.digestHex(algorithm)
    }
    /// Digest with an algorithm to a base64 string
    public func digestBase64(_ algorithm:DigestAlgorithm)->String{
        let data = self.data(using: String.Encoding.utf8)
        return data!.digestBase64(algorithm)
    }
}

extension Data {
    /// Digest data to an array of UInt8
    public func digestBytes(_ algorithm:DigestAlgorithm)->[UInt8]{
        let string = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        let stringLength = UInt32(self.count)
        
        let closure = algorithm.progressClosure()
        
        let bytes = closure(string, stringLength)
        return bytes
    }
    /// Digest data with an algorithm
    public func digestData(_ algorithm:DigestAlgorithm)->Data{
        let bytes = self.digestBytes(algorithm)
        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
    /// Digest data with an algorithm to a hexadecimal string
    public func digestHex(_ algorithm:DigestAlgorithm)->String{
        let digestLength = algorithm.digestLength()
        let bytes = self.digestBytes(algorithm)
        var hashString: String = ""
        for i in 0..<digestLength {
            hashString += String(format: "%02x", bytes[i])
        }
        return hashString
    }
    /// Digest string to a base64 string with an algorithm
    public func digestBase64(_ algorithm:DigestAlgorithm)->String{
        let data = self.digestData(algorithm)
        return data.base64EncodedString()
    }
}

public enum RSAAlgorithm:Int {
    case sha1 = 0, sha224, sha256, sha384, sha512, md2, md5
    public var padding:SecPadding {
        switch self {
        case .sha1:
            return SecPadding.PKCS1SHA1
        case .sha224:
            return SecPadding.PKCS1SHA224
        case .sha256:
            return SecPadding.PKCS1SHA256
        case .sha384:
            return SecPadding.PKCS1SHA384
        case .sha512:
            return SecPadding.PKCS1SHA512
        case .md2:
            //            return SecPadding.PKCS1MD2
            return SecPadding.PKCS1
        case .md5:
            //            return SecPadding.PKCS1MD5
            return SecPadding.PKCS1
        }
    }
    public var digestAlgorithm:DigestAlgorithm {
        switch self {
        case .sha1:
            return DigestAlgorithm.sha1
        case .sha224:
            return DigestAlgorithm.sha224
        case .sha256:
            return DigestAlgorithm.sha256
        case .sha384:
            return DigestAlgorithm.sha384
        case .sha512:
            return DigestAlgorithm.sha512
        case .md2:
            return DigestAlgorithm.md2
        case .md5:
            return DigestAlgorithm.md5
        }
    }
}

/// 从string生成公钥
fileprivate func rsa_form_public(_ key: String) -> SecKey? {
    let keyData = Data.init(base64Encoded: key)
    guard let data = keyData else {
        debugPrint("empty key data")
        return nil
    }
    
    //method1: create with data
    let keyMap:[NSObject:NSObject] = [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass: kSecAttrKeyClassPublic,
        kSecAttrKeySizeInBits: NSNumber(value: 2048),
        kSecReturnPersistentRef: true as NSObject
    ]
    let seckey = SecKeyCreateWithData(data as CFData, keyMap as CFDictionary, nil)
    return seckey
    
    /*method2: create with keychain
     let tag = "RSA_PUBLIC_KEY"
     //delete old lingering key with same tag
     let pubMap:[NSObject:NSObject] = [
     kSecClass: kSecClassKey,
     kSecAttrKeyType: kSecAttrKeyTypeRSA,
     kSecAttrApplicationTag:tag as NSObject,
     ]
     SecItemDelete(pubMap as CFDictionary)
     //Add persistent version of the key to system keychain
     let keyDict:[NSObject:NSObject] = [
     kSecClass: kSecClassKey,
     kSecAttrKeyType: kSecAttrKeyTypeRSA,
     kSecAttrApplicationTag:tag as NSObject,
     kSecValueData: data as NSObject,
     kSecReturnPersistentRef: true as NSObject
     ]
     var persistKey: CFTypeRef?
     var status = SecItemAdd(keyDict as CFDictionary, &persistKey)
     guard status == noErr  else {
     debugPrint("empty persist key!")
     return nil
     }
     let keyMap:[NSObject:NSObject] = [
     kSecClass: kSecClassKey,
     kSecAttrKeyType: kSecAttrKeyTypeRSA,
     kSecAttrApplicationTag:tag as NSObject,
     kSecReturnRef: true as NSObject
     ]
     // Now fetch the SecKeyRef version of the key
     var keyRef: CFTypeRef?
     status = SecItemCopyMatching(keyMap as CFDictionary, &keyRef);
     guard status == noErr, let ref:CFTypeRef = keyRef else {
     return nil
     }
     return (ref as! SecKey)*/
    
    /*method3: create with certificate not working
     if let certifivate = SecCertificateCreateWithData(kCFAllocatorDefault, data as CFData) {
     let policy = SecPolicyCreateBasicX509()
     var trust: SecTrust?
     if SecTrustCreateWithCertificates(certifivate, policy, &trust) == errSecSuccess {
     var trustResultType: SecTrustResultType = SecTrustResultType.invalid
     if SecTrustEvaluate(trust!, &trustResultType) == errSecSuccess {
     return SecTrustCopyPublicKey(trust!)
     }
     }
     }
     return nil*/
}

/// 公钥加密
fileprivate func rsa_encrypt(_ input: Data, withAlgorithm algorithm: RSAAlgorithm, withKey key: SecKey) -> Data? {
    guard input.count > 0 && input.count < SecKeyGetBlockSize(key) - 11 else {
        return nil
    }
    let key_size = SecKeyGetBlockSize(key)
    var encrypt_bytes = [UInt8](repeating: 0, count: key_size)
    var output_size: Int = key_size
    let inputBytes:[UInt8] = [UInt8](input)
    if SecKeyEncrypt(key, algorithm.padding, inputBytes, input.count, &encrypt_bytes, &output_size) == errSecSuccess {
        return Data(bytes: UnsafePointer<UInt8>(encrypt_bytes), count: output_size)
    }
    return nil
}

fileprivate func rsa_verify(_ input: Data, signed: Data, withAlgorithm algorithm: RSAAlgorithm, withKey key: SecKey) -> Bool {
    let inputDigest = input.digestData(algorithm.digestAlgorithm)
    guard inputDigest.count > 0 && inputDigest.count < SecKeyGetBlockSize(key) - 11 else {
        return false
    }
    let inputBytes:[UInt8] = [UInt8](inputDigest)
    let signedBytes:[UInt8] = [UInt8](signed)
    let result = SecKeyRawVerify(key, algorithm.padding, inputBytes, inputDigest.count, signedBytes, signed.count)
    return result == errSecSuccess
}

public struct RSAKit {
    
    public static func verify(_ plain: String, signature: String, publicKey key: String) -> Bool {
        guard let secKey = rsa_form_public(key) else {
            debugPrint("failed to genearte public sec key!")
            return false
        }
        guard let plainData = plain.data(using: String.Encoding.utf8) else {
            debugPrint("failed to transform data from plain text!")
            return false
        }
        guard let signedData = signature.data(using: String.Encoding.utf8) else {
            debugPrint("failed to transform data from signature text!")
            return false
        }
        let algorithm: RSAAlgorithm = .sha256
        return rsa_verify(plainData, signed: signedData, withAlgorithm: algorithm, withKey: secKey)
    }
    
    public static func encrypt(_ plain: String, publicKey key: String) -> String? {
        guard let secKey = rsa_form_public(key) else {
            debugPrint("failed to genearte public sec key!")
            return nil
        }
        guard let plainData = plain.data(using: String.Encoding.utf8) else {
            debugPrint("failed to transform data from plain text!")
            return nil
        }
        let en_algorithm: RSAAlgorithm = .md2
        guard let enData = rsa_encrypt(plainData, withAlgorithm: en_algorithm, withKey: secKey) else {
            debugPrint("failed to encrypt data!")
            return nil
        }
        let algorithm: DigestAlgorithm = .sha256
        return enData.digestBase64(algorithm)
    }
}
