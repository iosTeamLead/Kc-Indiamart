//
//  NotificationsClass.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/2/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "NotificationsClass.h"
#import "NotificationCustomCell.h"
#import "Server.h"
#import "NotificationViewViewController.h"
@interface NotificationsClass ()
{
    NSMutableArray *notification;
}

@end

@implementation NotificationsClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    notification=[[NSMutableArray alloc]init];
    
    
    
   // http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/UserRegistration/getAllNotification
    
    
   [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
    
    NSMutableDictionary *NotificationData = [[NSMutableDictionary alloc]init];
    
    
    
    
    if (kGetValueForKey(USER_DATA)) {
       [NotificationData setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CustNum"];
//        [NotificationData setObject:@"9997924" forKey:@"CustNum"];
//        [NotificationData setObject:@"9997924" forKey:@"CustNum"];
        
    }
    [NotificationData setObject:@"9997924" forKey:@"CustNum"];


    [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/getAllNotification" WithParameter:NotificationData Success:^(NSMutableDictionary *Dic) {
        NSLog(@"dic%@",Dic);
        notification =[Dic valueForKey:@"data"];
        
        [[Server sharedManager] hideHUD];
        [self.notificationTabl reloadData];

    }Error:^(NSError *error) {
        NSLog(@"error%@", [error localizedDescription]);
        [[Server sharedManager] hideHUD];

    }];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notification.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"NotificationCustomCell";
    
    NotificationCustomCell *cell = (NotificationCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [[[notification objectAtIndex:indexPath.row]valueForKey:@"Message"] sizeWithFont: cell.lblDiscrption.font
            constrainedToSize:maximumLabelSize  lineBreakMode:cell.lblDiscrption.lineBreakMode];
    //adjust the label the the new height.
    //        CGRect newFrame = descriptionLabel.frame;
    //        newFrame.size.height = expectedLabelSize.height;
    //        descriptionLabel.frame = newFrame;
    
    
    CGRect newFrame1 = cell.lblDiscrption.frame;
    newFrame1.size.height = expectedLabelSize.height;
  cell.lblDiscrption.frame = newFrame1;
    cell.lblDiscrption.text = [[notification objectAtIndex:indexPath.row]valueForKey:@"Message"];
    
    //cell.lblDiscrption.text =[[notification objectAtIndex:indexPath.row]valueForKey:@"id"];
    
    
    
    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[notification objectAtIndex:indexPath.row] valueForKey:@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
   
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.imgView.image  =  image;
        cell.imgView.hidden=NO;
        [cell.imgView stopAnimating];
    }];
    
    
    
    
    
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    [cell.imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        cell.imgView.image =  image;
//        cell.imgView.hidden=NO;
//        [cell.imgView stopAnimating];
//        
//        
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
//        [cell.imgView stopAnimating];
//        // _couponIndicatr.hidden=NO;
//        
//    }];
//
    
    
    return  cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NotificationViewViewController *notificationDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewViewController"];
    
    notificationDetail.notificationDetailArray = [notification objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:notificationDetail animated:YES];
}

- (IBAction)actnBack:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];
        
        
    }
    
    
   
    }
@end
