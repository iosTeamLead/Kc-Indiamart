//
//  CreateListPopUp.h
//  Grocery App
//
//  Created by Eweb-A1iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteListPopUp;

@protocol saveDelegate <NSObject>

@optional
-(void)saveBtnTapped :(NoteListPopUp *)view;
@end
@interface NoteListPopUp : UIView <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong) NSManagedObject *device;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) id<saveDelegate> delegate;
-(id)initWithListName :(CGRect)frame delegate:(id)delegate ;
@end
