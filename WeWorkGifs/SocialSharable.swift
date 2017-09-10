//
//  SocialSharable.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/7/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit
import Social
import MessageUI

enum SocialMedium {
    case facebook
    case imessage
    case twitter
}

protocol SocialSharable {
    func shareSheet(for image: Data, on social: SocialMedium) -> UIViewController?
}

extension SocialSharable {
    func shareSheet(for image: Data, on social: SocialMedium) -> UIViewController? {
        switch social {
        case .facebook:
            guard let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else { return nil }
            return vc
        case .twitter:
            guard let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return nil }
            return vc
        case .imessage:
            let vc = MFMessageComposeViewController()
            guard MFMessageComposeViewController.canSendText() else { return nil }
            vc.addAttachmentData(image,
                                 typeIdentifier: "public.data",
                                 filename: "giphygif.gif")
            return vc
        }
    }
}
