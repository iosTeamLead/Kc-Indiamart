//
//  NotificationViewViewController.m
//  Kc India Mart
//
//  Created by eweba1-pc-69 on 12/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "NotificationViewViewController.h"
#import "NotificationsClass.h"
#import "Server.h"
#import "AppDelegate.h"
@interface NotificationViewViewController ()
{

}
@end

@implementation NotificationViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"detail%@",_notificationDetailArray);
    _notificationDescriptionLbl.text = [_notificationDetailArray valueForKey:@"Message"];
//   _notificationTitleLabel.text = [_notificationDetailArray valueForKey:@"Message"];
    NSString *str  =[NSString stringWithFormat:Image_URL@"%@",[[_notificationDetailArray  valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    
    [_notificationImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        _notificationImageView.image = image;
        
        
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        //[UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
        //        [cell.collectIndicator stopAnimating];
        
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnBack:(id)sender {
    
    if (_isFromNotification) {
        _isFromNotification = NO;
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];
    }
    else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
