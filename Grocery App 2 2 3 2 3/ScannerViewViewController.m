//
//  ScannerViewViewController.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/19/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ScannerViewViewController.h"
#import "ZBarSDK.h"
#import "DetailListViewController.h"
#import "Server.h"
#import "ListViewController.h"
#import "groceryProductData.h"

@interface ScannerViewViewController ()<ZBarReaderDelegate>
{
    NSManagedObject *device;
    ZBarReaderViewController *codeReader;
}
@end

@implementation ScannerViewViewController



- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    [scanningView addSubview:codeReader.view];
    
  }
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    
    
    // showing the result on textview
    NSString *str = symbol.data;
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    NSMutableDictionary *dict = [[groceryProductData sharedManager] fetchPerticularProduct:str];
    if (dict !=nil) {
        
        
        //              [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        BOOL isOn=  [[NSUserDefaults standardUserDefaults]boolForKey:@"isSwitchOn"];
        
        
        
        
        if (isOn) {
            [self addtoLocalData:dict];
        }
        else{
            DetailListViewController *detail= [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
            
            
            NSMutableDictionary  *tempDict= (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, CFBridgingRetain([dict  mutableCopy]), kCFPropertyListMutableContainersAndLeaves));
                        
            detail.isFromScanner = YES;

            detail.productDetail = [tempDict  mutableCopy];
            [reader presentViewController:detail animated:YES completion:nil];
//            [reader dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
    
    
    // dismiss the controller
}


-(void)addtoLocalData:(NSMutableDictionary *) dataArray{
    
    
    
    if (kGetValueForKey(listName) == nil) {
        
        
        
        
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"Alert" message:@"You don't have any list created. Please create a list first."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes, please"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //What we write here????????**
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [codeReader dismissViewControllerAnimated:YES completion:nil];
                                        ListViewController *move=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                                        move.isFromLeft=YES;
                                        [self.navigationController pushViewController:move animated:YES]; //  present it
                                        
                                        
                                        NSLog(@"you pressed Yes, please button");
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
        
        [codeReader presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
        
    }
    else{
        
        NSManagedObjectContext *context = [self managedObjectContext];
        if (device) {
            // Update existing device
            //        _productDetail
            //        [self.device setValue:[[groceryProductData sharedManager] getListName] forKey:@"listName"];
            
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[dataArray mutableCopy]];
            [device setValue:arrayData forKey:@"productDetails"];
            [device setValue:@"1" forKey:@"quantity"];
            
            
            
            
            
        } else {
            if([dataArray valueForKey:@"myQuantity"]!=nil  )
            {
                
                
                int quant= [[dataArray valueForKey:@"myQuantity"] intValue];
                NSString *newQuat=[NSString stringWithFormat:@"%d",++quant];
                
                
                [[groceryProductData sharedManager] updateQuantity:[dataArray valueForKey:@"ItemNum"] withQuantity:newQuat];
                
                
                [UtilityText showAlertWithAlert:codeReader Alert:@"Message" message:@"Product updated" cancelTitle:@"ok"];
                
                
                //                UIAlertController * alert=[UIAlertController
                //
                //                                           alertControllerWithTitle:@"Alert" message:@"Already Added To List /n Do You want to update?"preferredStyle:UIAlertControllerStyleAlert];
                //
                //               UIAlertAction* yesButton = [UIAlertAction
                //                                                            actionWithTitle:@"Yes, please"
                //                                                            style:UIAlertActionStyleDefault
                //                                                            handler:^(UIAlertAction * action)
                //                                                            {
                //                                                                //What we write here????????**
                //
                //                                                                [[groceryProductData sharedManager]deleteClubsEntity:[dataArray valueForKey:@"productId"]];
                //                                                                NSLog(@"you pressed Yes, please button");
                //                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                //
                //                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
                //                //                                                [productTableView reloadData];
                //
                //                                                                // call method whatever u need
                //                                                            }];
                //                UIAlertAction* noButton = [UIAlertAction
                //                                           actionWithTitle:@"No, thanks"
                //                                           style:UIAlertActionStyleDefault
                //                                           handler:^(UIAlertAction * action)
                //                                           {
                //                                               //What we write here????????**
                //                                               [alert dismissViewControllerAnimated:YES completion:nil];
                //
                //                                               NSLog(@"you pressed No, thanks button");
                //                                               // call method whatever u need
                //
                //                                           }];
                //
                //                   [alert addAction:yesButton];
                //                [alert addAction:noButton];
                //
                //                [codeReader presentViewController:alert animated:YES completion:nil];
                //
                //
                //
                
                
                
            }
            else{
                [[groceryProductData sharedManager] saveMyProduct:[dataArray mutableCopy] quantity:@"1" mylistName:kGetValueForKey(listName) notes:kGetValueForKey(notesText)];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Product Added Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
        
        
        
        //    kSetBoolValueForKey(IsListCreated, YES);
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else{
            [[groceryProductData sharedManager] fetchSavedListAndProductId];
            
            //
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
        //        [productTableView reloadData];
        
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

@end
