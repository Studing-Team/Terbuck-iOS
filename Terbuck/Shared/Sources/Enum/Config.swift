//
//  Config.swift
//  Shared
//
//  Created by ParkJunHyuk on 12/21/25.
//

import Foundation

public enum Config {
    public enum Keys {
        public enum Plist {
            public static let googleAdmobUnitKey = "GADBannerAdUnitID"
        }
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}

public extension Config {
    static let googleAdmobUnitKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.googleAdmobUnitKey] as? String
        else {
            fatalError(
                "⛔️googleAdmobKey is not set in plist for this configuration⛔️"
            )
        }
        return key
    }()
}
