//
//  UIColor+PhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Olivier Collet on 2019-10-07.
//  Copyright © 2019 Unsplash. All rights reserved.
//

import UIKit

struct PhotoPickerColors {
    var background: UIColor { .systemBackground }
    var titleLabel: UIColor { .label }
    var subtitleLabel: UIColor { .secondaryLabel }
}

extension UIColor {
    static let photoPicker = PhotoPickerColors()
}
