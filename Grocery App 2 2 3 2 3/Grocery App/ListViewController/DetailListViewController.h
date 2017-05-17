//
//  DetailListViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailListViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UILabel *productName;
    __weak IBOutlet UILabel *stockNumberLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *compositionLabel;
    __weak IBOutlet UIView *compositionView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *fullImageView;
    __weak IBOutlet UIImageView *fullImage;
    __weak IBOutlet UIButton *crossFullImage;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UIView *costPriceView;
    __weak IBOutlet UILabel *costLabel;
    __weak IBOutlet UILabel *priceLabel;
    __weak IBOutlet UIView *priceOnlyView;
    __weak IBOutlet UIView *costOblyView;
    __weak IBOutlet UIView *locationCompositionView;
    __weak IBOutlet UIView *quantAndaddToView;
    __weak IBOutlet UIView *discriptionView;
    __weak IBOutlet UIActivityIndicatorView *fullImageIndicator;
    __weak IBOutlet UIView *compositionViewOnly;
    
    __weak IBOutlet UIButton *addtoListButton;
    __weak IBOutlet UIButton *removeButton;
    __weak IBOutlet UIView *simpleView;
    
    
    
    
    
}
@property (nonatomic) BOOL isFromScanner;


@property (strong) NSManagedObject *device;
- (IBAction)closeFullImageAction:(id)sender;
- (IBAction)removeItemAction:(id)sender;

@property (nonatomic,strong)NSMutableDictionary *productDetail;
@end
