//
//  ArivalCell.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArivalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblAddToList;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;
@property (weak, nonatomic) IBOutlet UIButton *addedButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
