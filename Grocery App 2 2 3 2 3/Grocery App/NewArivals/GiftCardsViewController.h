//
//  GiftCardsViewController.h
//  Grocery App
//
//  Created by eweba1-pc-69 on 11/28/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCardsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *barCodeImg;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@property (strong, nonatomic) IBOutlet UILabel *giftCardNumber;
@property (strong, nonatomic) NSMutableDictionary *giftCardData;
- (IBAction)actnBack:(id)sender;
- (IBAction)btnTransactn:(id)sender;

@end
