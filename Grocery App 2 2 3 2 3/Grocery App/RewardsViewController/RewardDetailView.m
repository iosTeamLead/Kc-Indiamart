//
//  RewardDetailView.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/22/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "RewardDetailView.h"
#import "MyRewardsViewController.h"
#import "Code39.h"
#import "Server.h"
#import "UtilityText.h"


@interface RewardDetailView ()
{
   NSMutableDictionary *rewardData,*userData;

}

@end

@implementation RewardDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    userData = kGetValueForKey(USER_DATA);
    
    
    [bonusPointButton setTitle:[NSString stringWithFormat:@"Bonus Points %d",[[_rewardDictionary valueForKey:@"Bonus_Points"] intValue]] forState:UIControlStateNormal];
    
    [bonusDoller setTitle:[NSString stringWithFormat:@"Bonus $%.2f",[[_rewardDictionary valueForKey:@"Bonus_Dollars"] floatValue]] forState:UIControlStateNormal];
    
    int barcode_width = 350;
    int barcode_height = 150;
       lblNumber.font = [UIFont fontWithName:@"Slidfis" size:18];
   
    if(userData!=nil)
    {
    lblNumber.text = [userData valueForKey:@"Swipe_Id"];
    lblCardName.text = [NSString stringWithFormat:@"%@ %@",[[userData valueForKey:@"First_Name"] uppercaseString],[[userData valueForKey:@"Last_Name"] uppercaseString] ];
        UIImage *code39Image = [Code39 code39ImageFromString:[userData valueForKey:@"Swipe_Id"] Width:barcode_width Height:barcode_height];
    barcodeImage.image =code39Image;
    }else{
        lblNumber.text = [_rewardDictionary valueForKey:@"Swipe_Id"];
        lblCardName.text = [NSString stringWithFormat:@"%@ %@",[[_rewardDictionary valueForKey:@"First_Name"] uppercaseString],[[_rewardDictionary valueForKey:@"Last_Name"] uppercaseString] ];
        UIImage *code39Image = [Code39 code39ImageFromString:[_rewardDictionary valueForKey:@"Swipe_Id"] Width:barcode_width Height:barcode_height];
        barcodeImage.image =code39Image;
    }


    
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)bonusAction:(id)sender {
}

- (IBAction)bonusPointAction:(id)sender {
}


- (IBAction)rewardTransction:(id)sender {
    
    MyRewardsViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"MyRewardsViewController"];
    view.rewardsTransaction = [[_rewardDictionary valueForKey:@"RewardTransactions"] mutableCopy];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)rewardBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
