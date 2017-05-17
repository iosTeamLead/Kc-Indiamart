//
//  GiftCardsViewController.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 11/28/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "GiftCardsViewController.h"
#import "RSCodeGen.h"
#import "GiftTransactnViewController.h"
@interface GiftCardsViewController ()

@end

@implementation GiftCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    int barcode_width = 350;
//    int barcode_height = 150;
//    _giftCardNumber.text =[_giftCardData valueForKey:@"CardNum"];
//    
//      _lblPrice.text =[NSString stringWithFormat:@"$%@",[_giftCardData valueForKey:@"Balance"] ];
    //        UIImage *code39Image = [Code39 code39ImageFromString:[_giftCardData valueForKey:@"CardNum"] Width:barcode_width Height:barcode_height];

    UIImage *code39Image = [CodeGen genCodeWithContents:[_giftCardData valueForKey:@"CardNum"] machineReadableCodeObjectType:AVMetadataObjectTypeCode128Code];
 
    _barCodeImg.image =code39Image;
//    _barCodeImg.backgroundColor = [UIColor whiteColor];
    
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

- (IBAction)actnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTransactn:(id)sender {
    
    GiftTransactnViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftTransactnViewController"];
    obj.giftTransactions = [_giftCardData valueForKey:@"GiftCardTransactions"];
    
    [self.navigationController pushViewController:obj animated:YES];

    
    
}
@end
