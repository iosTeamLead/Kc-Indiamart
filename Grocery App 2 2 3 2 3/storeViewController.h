//
//  storeViewController.h
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/14/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface storeViewController : UIViewController<UIScrollViewDelegate,MKAnnotation,CLLocationManagerDelegate>
{
    __weak IBOutlet UIPageControl *pageControl;
    
    __weak IBOutlet UIButton *backButton;
    
    __weak IBOutlet UILabel *durationLabel;
    __weak IBOutlet MKMapView *mapViewForRoute;
    
}
@property(nonatomic) BOOL isFromLeft;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionCell;

@end
