//
//  AppleLoginService.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import AuthenticationServices

public final class AppleLoginService: NSObject {
    public static let shared = AppleLoginService()
    
    private override init() {}
    
    private var continuation: CheckedContinuation<(code: String, name: String), Error>?

   public func login() async throws -> (code: String, name: String) {
       return try await withCheckedThrowingContinuation { continuation in
           self.continuation = continuation
           let provider = ASAuthorizationAppleIDProvider()
           let request = provider.createRequest()
           request.requestedScopes = [.fullName]
           let controller = ASAuthorizationController(authorizationRequests: [request])
           controller.delegate = self
           controller.presentationContextProvider = self
           controller.performRequests()
       }
   }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleLoginError.noCredential)
            return
        }
        
        let fullName = credential.fullName
        let givenName = fullName?.givenName ?? ""
        let familyName = fullName?.familyName ?? ""
        let userName = "\(familyName)\(givenName)"
        
        let authCode = String(data: credential.authorizationCode ?? Data(), encoding: .utf8) ?? ""
        
        print("애플로그인 결과 반환",authCode, userName)
        
        let responseDTO = AppleLoginResponseDTO(
            authCode: authCode,
            userName: userName
        )
        
        continuation?.resume(returning: (code: authCode, name: userName))
   }

   public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       continuation?.resume(throwing: error)
   }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
   public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
       UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
   }
}
