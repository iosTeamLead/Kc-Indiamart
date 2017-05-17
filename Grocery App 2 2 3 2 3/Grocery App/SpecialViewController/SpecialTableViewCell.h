//
//  SpecialTableViewCell.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;

@end
