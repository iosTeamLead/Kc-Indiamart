//
//  SideBarViewController.m
//  Grocery App
//
//  Created by eweba1-pc-55 on 9/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "SideBarViewController.h"
#import "MMDrawer.h"
#import "Server.h"
#import "groceryProductData.h"
#import "LoginViewController.h"

@interface SideBarViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *arrData;
   NSArray *imgData;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
  
    if (kGetValueForKey(Is_Login)!=nil) {
        arrData = [NSArray arrayWithObjects:@"Home",@"My List",@"Products",@"My Account" ,@"Notification",@"Contact Us" ,@"About", @"Store",@"Logout",nil];
        imgData = [NSArray arrayWithObjects:@"imgHome",@"imgMyList",@"imgProducts",@"imgMyAccount",@"notification",@"imgContactUs" ,@"imgAbout", @"imgStore",@"imgLogOut",nil];

    }
    else{
        arrData = [NSArray arrayWithObjects:@"Home",@"My List",@"Products",@"My Account",@"Notification" ,@"Contact Us" ,@"About", @"Store",@"Login",nil];
        imgData = [NSArray arrayWithObjects:@"imgHome",@"imgMyList",@"imgProducts",@"imgMyAccount" ,@"notification",@"imgContactUs", @"imgAbout", @"imgStore",@"imgLOgin",nil];
        

    }
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = arrData[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0];
     cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgData[indexPath.row]]];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 if (indexPath.row == 0) {

  MMDrawer *drawer = (MMDrawer *)[self parentViewController];
  UINavigationController *vcCenter =(UINavigationController *)drawer.centerViewController;
   vcCenter.viewControllers =@[[self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"]];
   [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
  }];
}

 else if (indexPath.row ==1) {
  MMDrawer *drawer = (MMDrawer *)[self parentViewController];
  
     
    if ([[groceryProductData sharedManager] getListName]!=nil) {
       UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
         vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailsViewController"] ];
     }
     else{
         UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
         vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"] ];
     }
     
     
   [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
  }];
  
 }
 else if (indexPath.row ==2) {
  MMDrawer *drawer = (MMDrawer *)[self parentViewController];
  UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
  vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"] ];
  [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
  }];
  
 }
// else if (indexPath.row ==3) {
//  MMDrawer *drawer = (MMDrawer *)[self parentViewController];
//  UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
//  vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"moviesTypeController"] ];
//  [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//  }];
//  
// }

 else if (indexPath.row ==3) {
 
     
     
     if (kGetValueForKey(Is_Login)==nil) {
         //        LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
         //        [self.navigationController pushViewController:login animated::YES];
         
         MMDrawer *drawer = (MMDrawer *)[self parentViewController];
         UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
         vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] ];
         [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
         }];
     }
     else{
     MMDrawer *drawer = (MMDrawer *)[self parentViewController];
  UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
  vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"] ];
  [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
  }];
     }
  
 }
 else if (indexPath.row ==4) {
     MMDrawer *drawer = (MMDrawer *)[self parentViewController];
     UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
     vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsClass"] ];
     [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
     }];
     
 }
    
 else if (indexPath.row ==5) {
  MMDrawer *drawer = (MMDrawer *)[self parentViewController];
  UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
  vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"] ];
  [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
  }];
  
 }
 else if (indexPath.row ==6) {
     MMDrawer *drawer = (MMDrawer *)[self parentViewController];
     UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
     vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"AboutUSViewController"] ];
     [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
     }];
     
 }
 else if (indexPath.row ==7) {
     MMDrawer *drawer = (MMDrawer *)[self parentViewController];
     UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
     vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"storeViewController"] ];
     [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
     }];
     
 }
    
    
else if (indexPath.row==8) {
    
    if (kGetValueForKey(Is_Login)==nil) {
        
//        LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.navigationController pushViewController:login animated::YES];
        
        
        
        
        
        
        MMDrawer *drawer = (MMDrawer *)[self parentViewController];
        
        
        
        
        UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
        vcCenter.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] ];
        [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];
    }
    else{
        
        
        
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"Alert" message:@"Are you Sure ?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes, please"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //What we write here????????**
                                        
                                        kRemoveObjectForKey(KMGUserId);
                                        kRemoveObjectForKey(Is_Login);
                                        kRemoveObjectForKey(USER_DATA);
                                        
                                        [appDelegate.window.rootViewController removeFromParentViewController];
                                        
                                        [appDelegate homeRootTabControler];
                                        
                                        NSLog(@"you pressed Yes, please button");
                                        
                                        [appDelegate.window.rootViewController removeFromParentViewController];
                                        [appDelegate homeRootTabControler];
                                        [[Server sharedManager] showToastInView:appDelegate.window.rootViewController toastMessage:@"Logout SuccessFully" withDelay:3];
                                        

                                        
                                        
                                        // call method whatever u need
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No, thanks"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //What we write here????????**
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       NSLog(@"you pressed No, thanks button");
                                       // call method whatever u need
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        

        
        
        
         }
   
 }
 
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return  50;
//}
@end
