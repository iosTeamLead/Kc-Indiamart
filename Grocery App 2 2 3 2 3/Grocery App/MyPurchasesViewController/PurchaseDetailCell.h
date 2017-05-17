//
//  PurchaseDetailCell.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNumber;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblBonus;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
