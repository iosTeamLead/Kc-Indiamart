//
//  RewardDetailView.h
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/22/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardDetailView : UIViewController
{
    __weak IBOutlet UIImageView *cardImage;
    __weak IBOutlet UIImageView *barcodeImage;
    __weak IBOutlet UIButton *bonusPointButton;
    __weak IBOutlet UIButton *bonusDoller;
   __weak IBOutlet UILabel *lblNumber;
   __weak IBOutlet UILabel *lblCardName;
    
    
}
- (IBAction)rewardTransction:(id)sender;
@property (nonatomic,strong) NSMutableDictionary *rewardDictionary;
- (IBAction)bonusAction:(id)sender;
- (IBAction)bonusPointAction:(id)sender;

- (IBAction)rewardBack:(id)sender;
@end
