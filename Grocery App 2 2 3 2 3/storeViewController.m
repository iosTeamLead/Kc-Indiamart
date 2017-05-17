    //
//  storeViewController.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/14/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "storeViewController.h"
#import "storeCollectionCell.h"
#import <CoreLocation/CoreLocation.h>
@interface storeViewController ()
{
    CLLocationManager *locationManager;
    MKPolyline *routeLine;
    NSMutableArray *imageArray;
    int index;
    
    float hotLat,HotalLong;
    
}
@end

@implementation storeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    pageControl.numberOfPages = imageArray.count;
    index = 0;
    hotLat = 38.887070;
    HotalLong=  -94.684984;
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(targetMethod)
                                   userInfo:nil
                                    repeats:YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
  
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }
    
    
    mapViewForRoute.showsUserLocation=YES;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude=hotLat;
    myCoordinate.longitude=HotalLong;
    annotation.coordinate = myCoordinate;
  
    
    [mapViewForRoute addAnnotation:annotation];
//     [locationManager stopUpdatingLocation];
    
    
    
}




- (IBAction)sideBarPressed:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];

    }
    
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
     [locationManager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
    //    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:19.017615 longitude:72.856164];
 
    CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:hotLat longitude:HotalLong];
    CLLocationCoordinate2D newcordinate =   newLocation.coordinate;
    CLLocationCoordinate2D oldcordinate =   hotelLocation.coordinate;
    
    MKMapPoint * pointsArray =
    malloc(sizeof(CLLocationCoordinate2D)*2);
    
    pointsArray[0]= MKMapPointForCoordinate(oldcordinate);
    pointsArray[1]= MKMapPointForCoordinate(newcordinate);
    
    routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    
    
    
    free(pointsArray);
    
    [mapViewForRoute addOverlay:routeLine];  //MkMapView declared
    
//    CLLocationDistance itemDist = [location distanceFromLocation:newLocation];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=%@",  newLocation.coordinate.latitude,  newLocation.coordinate.longitude,hotLat,  HotalLong, @"DRIVING"];
    NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSMutableArray *arrDistance=[result objectForKey:@"routes"];
        if ([arrDistance count]==0) {
            NSLog(@"N.A.");
              durationLabel.text = @"N.A.";
        }
        else{
            NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
            NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
            NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
            durationLabel.text = [[dictleg   objectForKey:@"duration"] objectForKey:@"text"];
            
        }
    }
    else{
        NSLog(@"N.A.");
        durationLabel.text = @"N.A.";

    }
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    
    
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    
//    CLLocationCoordinate2D newcordinate =   newLocation.coordinate;
//    CLLocationCoordinate2D oldcordinate =   oldLocation.coordinate;
//    
//    MKMapPoint * pointsArray =
//    malloc(sizeof(CLLocationCoordinate2D)*2);
//    
//    pointsArray[0]= MKMapPointForCoordinate(oldcordinate);
//    pointsArray[1]= MKMapPointForCoordinate(newcordinate);
//    
//    MKPolyline *  routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
//    free(pointsArray);
//    
//    [MapView addOverlay:routeLine];  //MkMapView declared in .h
//}

//MKMapViewDelegate

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//{
//    MKOverlayView* overlayView = nil;
//    
//    
//    MKPolylineView  * _routeLineView = [[MKPolylineView alloc]  initWithPolyline:routeLine] ;
//    _routeLineView.fillColor = [UIColor blueColor];
//    _routeLineView.strokeColor =[UIColor blueColor];
//    _routeLineView.lineWidth = 5;
//    _routeLineView.lineCap = kCGLineCapRound;
//    
//    
//    overlayView = _routeLineView;
//    
//    return overlayView;
//    
//}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView
           rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    
    return renderer;
}


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != mapViewForRoute.userLocation)
    {
//        pinView = (MKAnnotationView *)[mapViewForRoute dequeueReusableAnnotationViewWithIdentifier:nil];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:nil];
        
//        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"annotationblue"];    //as suggested by Squatch
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:@"me heere" forState:UIControlStateNormal];
        NSLog(@"%@",rightButton );
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = rightButton;
        NSLog(@" rightButton.tag  %ld",(long)rightButton.tag);
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        pinView.enabled=YES;
        
        NSLog(@"%@",pinView.annotation);
        pinView.multipleTouchEnabled = NO;

        
        
        

    }
    else {
        
        pinView = (MKAnnotationView *)[mapViewForRoute dequeueReusableAnnotationViewWithIdentifier:nil];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:nil];
        
//        pinView.pinColor = m≥;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"annotationboth"];    //as suggest
        [mapViewForRoute.userLocation setTitle:@"hotel here"];
   
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:@"hotel here" forState:UIControlStateNormal];
        NSLog(@"%@",rightButton );
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = rightButton;
        NSLog(@" rightButton.tag  %ld",(long)rightButton.tag);
        [rightButton addTarget:self action:@selector(showMIneLocation:) forControlEvents:UIControlEventTouchUpInside];
        pinView.enabled=YES;
        
        NSLog(@"%@",pinView.annotation);
        pinView.multipleTouchEnabled = NO;
        
        
        return pinView;

    }
    return pinView;

}
-(void)showDetails:(id)sender
{
    
    NSLog(@"userLocation called ");
    
    
}
-(void)showMIneLocation:(id)sender
{
    
    NSLog(@"mylocation called ");
    
    
}

-(void)targetMethod
{
    
    
//    if (index ==imageArray.count-1) {
//        [self.collectionCell scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
//                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                            animated:NO];
//
//    }
//    else{
        [self.collectionCell scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];

//    }
    
    index=(index<imageArray.count-1)?(index+1):0;
    NSLog(@"%d",index);
    pageControl.currentPage = index;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    storeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"storeCollectionCell" forIndexPath:indexPath];
    
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    
//    return 0;
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = self.collectionCell.frame.size.width;
    pageControl.currentPage = self.collectionCell.contentOffset.x / pageWidth;
    index=self.collectionCell.contentOffset.x / pageWidth;

}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(150, 150);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
    CGSize size = CGSizeMake(screenWidth, collectionView.frame.size.height);
    return size;
    
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
