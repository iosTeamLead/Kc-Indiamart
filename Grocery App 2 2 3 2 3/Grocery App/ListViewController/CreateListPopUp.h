//
//  CreateListPopUp.h
//  Grocery App
//
//  Created by Eweb-A1iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreateListPopUp;

@protocol saveDelegate <NSObject>

@optional
-(void)saveBtnTapped :(CreateListPopUp *)view;
@end
@interface CreateListPopUp : UIView<UITextFieldDelegate>
@property (strong) NSManagedObject *device;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *txtListName;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) id<saveDelegate> delegate;
-(id)initWithListName :(CGRect)frame delegate:(id)delegate;
@end
