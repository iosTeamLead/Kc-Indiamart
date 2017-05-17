//
//  NotificationViewViewController.h
//  Kc India Mart
//
//  Created by eweba1-pc-69 on 12/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsClass.h"
@interface NotificationViewViewController : UIViewController
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationDescriptionLbl;

@property (nonatomic) BOOL isFromNotification;

@property (nonatomic, strong) NSMutableDictionary *notificationDetailArray;
@end
