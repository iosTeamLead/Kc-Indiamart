//
//  HomePageViewController.h
//  Grocery App
//
//  Created by eweba1-pc-55 on 9/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface HomePageViewController : UIViewController<CLLocationManagerDelegate>
{
    __weak IBOutlet UILabel *locationLabel;
     CLLocationManager *locationManager;
    __weak IBOutlet UIView *scanView;
}
@end
