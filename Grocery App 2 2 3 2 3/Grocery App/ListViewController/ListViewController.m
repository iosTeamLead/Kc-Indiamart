//
//  ListViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ListViewController.h"
#import "CreateListPopUp.h"
#import "ListDetailsViewController.h"
#import "searchResultView.h"
#import "DetailListViewController.h"
#import "ZBarSDK.h"
#import "Server.h"
#import "groceryProductData.h"

@interface ListViewController ()<UISearchBarDelegate,ZBarReaderDelegate>
{
    NSManagedObject *device;
    ZBarReaderViewController *codeReader;

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }

    
    
    
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
    //  get the decode results
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

- (IBAction)leftBtnPressed:(id)sender {
// MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
// [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];
        
        
       }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)drawerBtnAction:(id)sender {
    MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
    [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
}

- (IBAction)createListTapped:(id)sender {
 CreateListPopUp * listPopUp = [[CreateListPopUp alloc]initWithListName:self.view.frame delegate:self];
 [self.view addSubview:listPopUp];
 
}
-(void)saveBtnTapped :(CreateListPopUp *)view{
 [view removeFromSuperview];
    if (kGetValueForKey(listName)!=nil) {
        ListDetailsViewController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailsViewController"];
        //    kSetBoolValueForKey(IsListCreated, YES);
        [self.navigationController pushViewController:listView animated:YES];
    }
    else{
        NSLog(@"List Not Created");
    }
    

 
}
#pragma -mark searchfield delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTxt {
 
 
}
- (IBAction)tapClicked:(id)sender {
    
//    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];;
//    
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
 [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 [searchBar resignFirstResponder];
 
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


@end
