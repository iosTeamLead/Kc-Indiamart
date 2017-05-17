//
//  AllCouponsViewController.h
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/5/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCouponsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageCoupon;
@property (strong, nonatomic) IBOutlet UILabel *lblSave;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblSaveItem;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIView *viewForImg;

@property (strong, nonatomic) IBOutlet UIImageView *imgBarcode;

@property (strong, nonatomic) NSMutableDictionary *selectedData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *couponIndicatr;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *barCodeIndicatr;

- (IBAction)actnBack:(id)sender;

@end
