//
//  HomePageViewController.m
//  Grocery App
//
//  Created by eweba1-pc-55 on 9/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "HomePageViewController.h"
#import "MMDrawer.h"
#import "ListViewController.h"
#import "CategoriesViewController.h"
#import "MyPurchasesViewController.h"
#import "SpecialViewController.h"
#import "LoginViewController.h"
#import "RewardsViewController.h"
#import "CoupansViewController.h"
#import "ArivalsViewController.h"
#import "ListDetailsViewController.h"
#import "DetailListViewController.h"
#import "moviesTypeController.h"
#import "Server.h"

#import "groceryProductData.h"
#import "RewardDetailView.h"
#import "searchResultView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "ScannerViewViewController.h"
#import "GiftCardsViewController.h"

@interface HomePageViewController ()<AVCaptureMetadataOutputObjectsDelegate,UISearchBarDelegate,ZBarReaderDelegate>{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    BOOL isload;
    
    NSManagedObject *device;
    
    ZBarReaderViewController *codeReader;
    
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@",kGetValueForKey(USER_DATA));
    
    
    // [_searchBar setBackgroundColor:[UIColor clearColor]];
    // [_searchBar setBarTintColor:[UIColor clearColor]];
    // for (UIView *subview in [[_searchBar.subviews lastObject] subviews]) {
    //  if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
    //   [subview removeFromSuperview];
    //   break;
    //  }
    // }
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    //    _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y, _searchBar.frame.size.width, _searchBar.frame.size.height+30);
    // searchField.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    [self setCountry:@""];
    //    locationManager = [[CLLocationManager alloc] init];
    //    locationManager.delegate = self;
    //    //    locationManager.distanceFilter = kCLDistanceFilterNone;
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    [locationManager requestAlwaysAuthorization];
    //    [locationManager startUpdatingLocation];
    
    
    
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)setCountry:(NSString *)withCountry{
    
    //    NSString *loctName=[withCountry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //
    //    NSMutableString *MUTABESTRING=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ image",loctName]];
    //
    //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ image",loctName]];
    //    //    NSRange range = [MUTABESTRING rangeOfString:@"Red"];
    //    NSRange range=[MUTABESTRING rangeOfString:@"image" options:NSCaseInsensitiveSearch];
    //    //    NSRange range1;
    //    //    range1 = [MUTABESTRING rangeOfString:[[feedData objectAtIndex:indexPath.row] valueForKey:@"calendar_name"] options:NSCaseInsensitiveSearch];
    //    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //    textAttachment.image = [UIImage imageNamed:@"imgLocation"];
    //
    //
    //    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //    [string replaceCharactersInRange:range withAttributedString:attrStringWithImage];
    //        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    
    NSDate *date = [NSDate date];
    
    // Make Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"HH mm"];
    
    // hh for hour mm for minutes and a will show you AM or PM
    NSString *str = [dateFormatter stringFromDate:date];
    NSLog(@"%@", str);
    
    // Sperate str by space i.e. you will get time and AM/PM at index 0 and 1 respectively
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    // Now you can check it by 12. If < 12 means Its morning > 12 means its evening or night
    
    NSString *message;
    
    NSString *personName = @"";
    NSString *timeInHour = array[0];
   // NSString *am_pm      = array[1];
    
    if (kGetValueForKey(USER_DATA)==nil) {
        personName = @"Guest!";
    }
    else{
        personName =[NSString stringWithFormat:@"%@!",[kGetValueForKey(USER_DATA) valueForKey:@"First_Name"] ];
        
    }
    
    
    
    if([timeInHour integerValue] >= 0   && [timeInHour integerValue] < 12)
    {
        message = [NSString stringWithFormat:@"Good Morning %@", personName];
    }
    else if ([timeInHour integerValue] >= 12 && [timeInHour integerValue] < 17)
    {
        message = [NSString stringWithFormat:@"Good Afternoon %@", personName];
    }
    else if ([timeInHour integerValue] >= 17 && [timeInHour integerValue] < 20)
    {
        message = [NSString stringWithFormat:@"Good Evening %@", personName];
    }
    else if ([timeInHour integerValue] >= 20 || [timeInHour integerValue] < 24)
    {
        message = [NSString stringWithFormat:@"Good Night %@", personName];
    }
    
    
    NSLog(@"%@", message);
    
    locationLabel.text = [message capitalizedString];
    
    
    
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"didFailWithError: %@", error);
////    UIAlertView *errorAlert = [[UIAlertView alloc]
////                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////    [errorAlert show];
////    [manager stopUpdatingLocation];
//
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//      CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:19.017615 longitude:72.856164];
//
//
//    CLLocationDistance itemDist = [location distanceFromLocation:newLocation];
//
//    NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=%@", [@"19.017615" floatValue],  [@"72.856164" floatValue], newLocation.coordinate.latitude,  newLocation.coordinate.longitude, @"DRIVING"];
//    NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSData *jsonData = [NSData dataWithContentsOfURL:url];
//    if(jsonData != nil)
//    {
//        NSError *error = nil;
//        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//        NSMutableArray *arrDistance=[result objectForKey:@"routes"];
//        if ([arrDistance count]==0) {
//            NSLog(@"N.A.");
//        }
//        else{
//            NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
//            NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
//            NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
//        }
//    }
//    else{
//        NSLog(@"N.A.");
//    }
//
//
//
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error == nil && [placemarks count] > 0) {
//            CLPlacemark  *placemark = [placemarks lastObject];
//            NSLog( @"%@",placemark.locality);
//            [self setCountry:placemark.locality];
//
//                }else
//        {
//            NSLog(@"  %@", error.debugDescription);
//        }
//    } ];
//
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//      // stop updating location in order to save battery power
//    [locationManager stopUpdatingLocation];
//
//
//    // Reverse Geocoding
//    NSLog(@"Resolving the Address");
//
//    // “reverseGeocodeLocation” method to translate the locate data into a human-readable address.
//
//    // The reason for using "completionHandler" ----
//    //  Instead of using delegate to provide feedback, the CLGeocoder uses “block” to deal with the response. By using block, you do not need to write a separate method. Just provide the code inline to execute after the geocoding call completes.
////    NSString *country=nil;
////    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
////     {
////         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
////         CLPlacemark *placemark = [placemarks lastObject];
////
////       country=[NSString stringWithFormat:@"%@",[[placemarks lastObject] country]];
////
//////         NSLog(@"%@",[placemarks valueForKey:country])
////
////
////         if (error == nil && [placemarks count] > 0)
////         {
////             // strAdd -> take bydefault value nil
////             NSString *strAdd = nil;
////
////             if ([placemark.subThoroughfare length] != 0)
////                 strAdd = placemark.subThoroughfare;
////
////             if ([placemark.thoroughfare length] != 0)
////             {
////                 // strAdd -> store value of current location
////                 if ([strAdd length] != 0)
////                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
////                 else
////                 {
////                     // strAdd -> store only this value,which is not null
////                     strAdd = placemark.thoroughfare;
////                 }
////             }
////
////             if ([placemark.postalCode length] != 0)
////             {
////                 if ([strAdd length] != 0)
////                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
////                 else
////                     strAdd = placemark.postalCode;
////             }
////
////             if ([placemark.locality length] != 0)
////             {
////                 if ([strAdd length] != 0)
////                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
////                 else
////                     strAdd = placemark.locality;
////             }
////
////             if ([placemark.administrativeArea length] != 0)
////             {
////                 if ([strAdd length] != 0)
////                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
////                 else
////                     strAdd = placemark.administrativeArea;
////             }
////
////             if ([placemark.country length] != 0)
////             {
////                 if ([strAdd length] != 0)
////                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
////                 else
////                     strAdd = placemark.country;
////             }
////
////
////    [locationManager startUpdatingLocation];
////
////}
////     }];
//
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//
//    if (currentLocation != nil) {
////        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
////        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
//}

-(void)viewWillAppear:(BOOL)animated{
    [self setCountry:@""];

    if ( !isload) {
        isload =YES;
        [[Server sharedManager] showHUDInView:self.view hudMessage:@"Loading Data"];
        [[groceryProductData sharedManager] groceryProductData];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
    [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
}
- (IBAction)barCodePressed:(id)sender {
    //
    //    ScannerViewViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ScannerViewViewController"];
    //    [self.navigationController pushViewController:next animated:YES];
    
    NSLog(@"Scanning..");
    NSString *str = @"Scanning..";
    self.view.hidden=YES;
    codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //    codeReader.cameraFlashMode = -1;
    
    
    ZBarImageScanner *scanner = codeReader.scanner;
    
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
//        [scanView addSubview:codeReader.view];
    
//        [self.navigationController pushViewController:codeReader animated:YES];
    
//    [codeReader.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self presentViewController:codeReader animated:YES completion:^{
        [self.view setHidden:NO];
    }];

    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
            detail.productDetail = tempDict;
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















- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            
            break;
        }
    }
    
    //_highlightView.frame = highlightViewRect;
}
-(void)getProductDetails:(NSString *)strId
{
    
}
#pragma -mark searchfield delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    return  NO;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTxt {
    
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    
    
    
    
    
}
- (IBAction)myListTapped:(id)sender {
    [self.searchBar resignFirstResponder];
    
    NSLog(@"%@",[[groceryProductData sharedManager] getListName]);
    if ([[groceryProductData sharedManager] getListName]!=nil) {
        ListDetailsViewController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailsViewController"];
        listView.isFromLeft=YES;
        [self.navigationController pushViewController:listView animated:YES];
    }
    else{
        ListViewController *listVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        listVc.isFromLeft=YES;
        [self.navigationController pushViewController:listVc animated:YES];
    }
    
}
- (IBAction)myPurchaseTapped:(id)sender {
    [self.searchBar resignFirstResponder];
    if (kGetValueForKey(Is_Login)==nil) {
        
        LoginViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        view.isFromLeft = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else{
        
        MyPurchasesViewController *purchaseVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPurchasesViewController"];
        [self.navigationController pushViewController:purchaseVc animated:YES];    }
    
    
    
    
}
- (IBAction)myProductTapped:(id)sender {
    [self.searchBar resignFirstResponder];
    CategoriesViewController *categoriesVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    categoriesVc.isFromLeft=YES;
    [self.navigationController pushViewController:categoriesVc animated:YES];
}
- (IBAction)specialBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    SpecialViewController *specialVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialViewController"];
    [self.navigationController pushViewController:specialVc animated:YES];
}
- (IBAction)rewardsBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    
    
    if (kGetValueForKey(Is_Login)==nil) {
        
        
        RewardsViewController *rewardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardsViewController"];
        [self.navigationController pushViewController:rewardVc animated:YES];

 }
    else{
        
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CustNum"];
        [dict setObject:@"" forKey:@"LastName"];
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
        
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/getCustomersRewards" WithParameter:dict Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"Dic = %@",Dic);
            
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"code"]isEqualToString:@"201"]) {
                RewardDetailView *next=[self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailView"];
                next.rewardDictionary = [Dic mutableCopy];
                [self.navigationController pushViewController:next animated:YES];
                
            }
            else{
                [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"ok"];
            }
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];
        
       
        
        NSLog(@"LOGIN");
        
       }
}
- (IBAction)coupansBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
//    if (kGetValueForKey(Is_Login)==nil) {
//        
//        
//        LoginViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        view.isFromLeft = YES;
//        [self.navigationController pushViewController:view animated:YES];
//    }
//    else{
        CoupansViewController *coupansVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoupansViewController"];
        [self.navigationController pushViewController:coupansVc animated:YES];
    
}
- (IBAction)newArivalBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    
    if (kGetValueForKey(Is_Login)==nil) {
        
        LoginViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        view.isFromLeft = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else{
    NSString *url = @"http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/UserRegistration/customersGiftCards";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CustNum"];
    
    
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    
    //    http://webservices.com.kcimart.com/kcindia_app/webservices/getMovies
    [[Server sharedManager] PostDataWithURL:url WithParameter:dict Success:^(NSMutableDictionary *Dic) {
        NSLog( @"%@",Dic);
        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Data Not Found" cancelTitle:@"OK"];
        }
        else{
            GiftCardsViewController *coupansVc = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftCardsViewController"];
            coupansVc.giftCardData =  [Dic mutableCopy];
            
            [self.navigationController pushViewController:coupansVc animated:YES];

        }
        
        
        
        
      
        [[Server sharedManager] hideHUD];
    } Error:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [[Server sharedManager] hideHUD];

        
    }];
    
    }
}


//-(void) getGiftCard{
//
//        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
//        
//        //    http://webservices.com.kcimart.com/kcindia_app/webservices/getMovies
//        [[Server sharedManager] FetchingData:Base_URL@"getMovies" WithParameter:nil Success:^(NSMutableDictionary *Dic) {
//            NSLog(@"%@ ",Dic);
//            if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
//                [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
//            }
//            else{
//                NSLog(@"%@",[[Dic valueForKey:@"data"] valueForKey:@"Language"]);
//                AllMovies =[[NSMutableArray alloc] init];
//                AllMovies=[[Dic valueForKey:@"data"] mutableCopy];
//                
//                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[[AllMovies valueForKey:@"Language"] mutableCopy]];
//                NSArray *languageArray = [orderedSet array];
//                
//                //              NSMutableArray *languageArray=[[[Dic valueForKey:@"data"] valueForKey:@"Language"] mutableCopy];
//                notLoaded = YES;
//                
//                moviesDict=[[NSMutableDictionary alloc] init];
//                for (int i=0;i< [languageArray count]; i++)
//                {
//                    NSMutableArray *langData= [[NSMutableArray alloc] init];
//                    for (int j=0; j<[AllMovies count]; j++) {
//                        if ([[[AllMovies objectAtIndex:j]valueForKey:@"Language"] isEqualToString:[languageArray objectAtIndex:i]]) {
//                            [langData addObject:[[AllMovies objectAtIndex:j]mutableCopy]];
//                        }
//                    }
//                    [moviesDict setObject:langData forKey:[languageArray objectAtIndex:i]];
//                    
//                }
//                NSLog(@"%@",moviesDict);
//                
//                
//            }
//            
//            NSLog(@"m %lu",[[moviesDict valueForKey:@"TELUGU"] count]);
//            
//            [[Server sharedManager]hideHUD];
//            
//        } Error:^(NSError *error) {
//            NSLog(@"%@",[error localizedDescription]);
//            
//        } InternetConnected:^(NSError *error) {
//            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Internet Not Connected" cancelTitle:@"Ok"];
//            
//        }];
//
//    
//    
//    
//}
//




- (IBAction)newMoviesBtnPressed:(id)sender {
//    [self.searchBar resignFirstResponder];
//    moviesTypeController *newArivalVc = [self.storyboard instantiateViewControllerWithIdentifier:@"moviesTypeController"];
//    newArivalVc.isFromLeft=YES;
//    [self.navigationController pushViewController:newArivalVc animated:YES];
    
    
    [self.searchBar resignFirstResponder];
    ArivalsViewController *newArivalVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArivalsViewController"];
    newArivalVc.isFromLeft=YES;
    newArivalVc.buttonName = @"New Arrivals";
    [self.navigationController pushViewController:newArivalVc animated:YES];
    

    
}

- (IBAction)organicBtnPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    ArivalsViewController *newArivalVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArivalsViewController"];
    newArivalVc.isFromLeft=YES;
    newArivalVc.buttonName = @"Organic";
    [self.navigationController pushViewController:newArivalVc animated:YES];
}
- (IBAction)tapAction:(id)sender {
    if (_searchBar.text.length<=0) {
        [self.view endEditing: YES];
        
    }
    
}

- (IBAction)tapGesture:(id)sender {
    [self.searchBar resignFirstResponder];
}

@end
