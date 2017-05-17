//
//  MyPurchasesViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "MyPurchasesViewController.h"
#import "MyPurchaseTableViewCell.h"
#import "PurchaseDetailsViewController.h"
#import "ListViewController.h"
#import "searchResultView.h"
#import "Server.h"
#import "ZBarSDK.h"

@interface MyPurchasesViewController ()<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate>
{
    NSMutableArray *purchaseArray;
    NSManagedObject *device;
    ZBarReaderViewController *codeReader;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MyPurchasesViewController


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
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    [self getPurchase];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)getPurchase{
//    http://webservices.com.kcimart.com/kcindia_app/webservices/UserRegistration/getCustomerInvoiceSummary
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
            [data setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CutNum"];
//    [data setObject:@"8365014" forKey:@"CutNum"];
    
    
    
    [[Server sharedManager] PostDataWithURL:Base_URL@"UserRegistration/getCustomerInvoiceSummary" WithParameter:data Success:^(NSMutableDictionary *Dic) {
        NSLog(@"%@ ",Dic);
        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
            
            noDataLabel.hidden = NO;
            myPurchaseTableView.hidden=YES;
        }
        else{
        
            purchaseArray = [[NSMutableArray alloc] init];
            purchaseArray = [[Dic valueForKey:@"data"]  mutableCopy];
                    [myPurchaseTableView reloadData];
            if (purchaseArray.count<=0) {
                noDataLabel.hidden = NO;
                myPurchaseTableView.hidden=YES;
                
            }
            else{
                noDataLabel.hidden = YES;
                myPurchaseTableView.hidden=NO;

            }
            
            
            
        }
        [[Server sharedManager]hideHUD];
        
        
    } Error:^(NSError *error) {
        
        NSLog(@"%@",[error localizedDescription]);
    }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return purchaseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 MyPurchaseTableViewCell *cell = (MyPurchaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
 if (cell==nil) {
  cell = [[MyPurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  
 }
    
    [cell.imageIndicator stopAnimating];
    cell.lblNumber.text=[[purchaseArray objectAtIndex:indexPath.row] valueForKey:@"CustNum"];
    cell.lblDate.text=[[purchaseArray objectAtIndex:indexPath.row] valueForKey:@"Invoice_Date"];
    cell.lblAmount.text=[NSString stringWithFormat:@"$%.2f",[[[purchaseArray objectAtIndex:indexPath.row] valueForKey:@"Grand_Total"] floatValue] ];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[purchaseArray objectAtIndex:indexPath.row] valueForKey:@"Image_Path"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    cell.imgView.hidden=YES;
//    
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    [cell.imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        cell.imgView.image  =  image;
//        cell.imgView.hidden=NO;
//        
//        [cell.imageIndicator stopAnimating];
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
//        [cell.imageIndicator stopAnimating];
//        //            cell.m_imageView.hidden=NO;
//        
//    }];

    
    
    
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 return  cell;
}

- (IBAction)sideBarTapped:(id)sender {
 
 [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    return  NO;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSMutableArray *arr =[[purchaseArray objectAtIndex:indexPath.row] valueForKey:@"InvoiceDetails"];
    
    if ([arr count] <=0) {
        [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Thier is no invoice detail found" cancelTitle:@"OK"];
    }
    else{
        
//        NSString *invoiceValue = [purchaseArray objectAtIndex:indexPath.row]valueForKey:        
        
        
        
        
        
    

        
        PurchaseDetailsViewController *purchaseDetail =  [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseDetailsViewController"];
        
        purchaseDetail.detailData = [[purchaseArray objectAtIndex:indexPath.row] mutableCopy];
        NSLog(@"purchaseDetail.detailData%@",purchaseDetail.detailData);
        
        [self.navigationController pushViewController:purchaseDetail animated:YES];
    }
  
 
}


- (IBAction)barCodePressed:(id)sender {
    NSLog(@"Scanning..");
    NSString *str = @"Scanning..";
    
   codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    self.view.hidden=YES;
    [self presentViewController:codeReader animated:YES completion:^{
        [self.view setHidden:NO];
    }];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
