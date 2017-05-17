//
//  AllCouponsViewController.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/5/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "AllCouponsViewController.h"
#import "server.h"
@interface AllCouponsViewController ()

@end

@implementation AllCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"selecteddata %@",_selectedData);
  _lblSave.text = [self.selectedData valueForKey:@"Description1"];
     _lblSaveItem.text = [self.selectedData valueForKey:@"Description2"];
    _lblDate.text = [self.selectedData valueForKey:@"Exp_Date"];
    //_imgBarcode.image =[self.selectedData valueForKey:@"ItemNum"];
    
//    _imageCoupon.image =[self.selectedData valueForKey:@"Image_Path"];
    
    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[self.selectedData valueForKey:@"Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
//    NSString *str  =[NSString stringWithFormat:Image_URL@"%@",[[_productDetail  valueForKey:@"Image_Path"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
//    
    
    //    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    //    [fullImageIndicator startAnimating];
    
//    _imageCoupon.hidden=YES;
    
    [_imageCoupon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _imageCoupon.image  =  image;
        _imageCoupon.hidden=NO;
        [_couponIndicatr stopAnimating];
    }];
    

    
    
    
    
//
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    [_imageCoupon setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//       _imageCoupon.image  =  image;
//       _imageCoupon.hidden=NO;
//        [_couponIndicatr stopAnimating];
//
//       
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
//        [_couponIndicatr stopAnimating];
//                  // _couponIndicatr.hidden=NO;
//        
//    }];
    
    _viewForImg.layer.masksToBounds = YES;
    _viewForImg.layer.shadowOffset = CGSizeMake(5, 0);
    _viewForImg.layer.shadowRadius = 5;
    _viewForImg.layer.shadowOpacity = 0.5;
    _viewForImg.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewForImg.bounds].CGPath;

    


    
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
@end
