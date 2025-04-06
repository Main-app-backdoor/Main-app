// Proprietary Software License Version 1.0
//
// Copyright (C) 2025 BDG
//
// Backdoor App Signer is proprietary software. You may not use, modify, or distribute it except as expressly permitted under the terms of the Proprietary Software License.

import UIKit
import Foundation

// Import the necessary signing data types
import SwiftUI // For ObservableObject

// FIXME: Class name has a typo ("COntroller" instead of "Controller") but must match file name
// and existing references in other files. Should be properly renamed in a future PR.
class FRSITableViewCOntroller: FRSTableViewController {
    var signingDataWrapper: SigningDataWrapper
    var mainOptions: SigningMainDataWrapper

    init(signingDataWrapper: SigningDataWrapper, mainOptions: SigningMainDataWrapper) {
        self.signingDataWrapper = signingDataWrapper
        self.mainOptions = mainOptions

        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
