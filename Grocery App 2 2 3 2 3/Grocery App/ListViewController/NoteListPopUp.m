//
//  CreateListPopUp.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "NoteListPopUp.h"
#import "Server.h"
#import "groceryProductData.h"

@implementation NoteListPopUp
//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}
//

-(id)initWithListName :(CGRect)frame delegate:(id)delegate {
 self = [super initWithFrame:frame];
 
 if (self) {
  [[NSBundle mainBundle]loadNibNamed:@"NoteListPopUp" owner:self options:nil];
  
  
  self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.textView.placeholder = @"Enter Text";
     self.textView.delegate = self;
     
     
  self.delegate = delegate;
     if (kGetValueForKey(notesText)!=nil) {
         self.textView.text=kGetValueForKey(notesText);
     }
     
//     NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
//     self.device = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
     
  [self.view layoutIfNeeded];
  [self backGroundView];
  [self addSubview:self.view];
  
 }
 return self;
 
}
//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    [UtilityText setViewMovedUp:YES view:self.view];
////    if ( _commmenttextView.textColor == [UIColor lightGrayColor]) {
////        _commmenttextView.text = @"";
////        _commmenttextView.textColor = [UIColor blackColor];
////        
////        
////    }
////    
//    return YES;
//}

//-(void) textViewDidChange:(UITextView *)textView
//{
//    if( _commmenttextView.text.length == 0){
//        _commmenttextView.textColor = [UIColor lightGrayColor];
//        _commmenttextView.text = @"Enter Comment Text";
//        [ _commmenttextView resignFirstResponder];
//        [self setViewMovedUp:NO];
//        
//    }
//}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
           self.textView.placeholder = @"Enter Text";
            [UtilityText setViewMovedUp:NO view:self.view];

     
        return NO;
    }
    
    return YES;
}


- (IBAction)tabGestureClicked:(id)sender {
 [self removeFromSuperview];
}

-(void) backGroundView {
 UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
 bgView.backgroundColor = [UIColor lightGrayColor];
 bgView.alpha = 0.3;
 [self.view insertSubview:bgView atIndex:0];
}
-(void)awakeFromNib{
 [super awakeFromNib];
}

- (IBAction)saveBtnClicked:(id)sender {
    
    
    [[groceryProductData sharedManager] updateAllProduct:nil quantity:nil mylistName:nil notes: self.textView.text];
    
    
    [self.delegate saveBtnTapped:self];

 
}
- (IBAction)cancelBtnClicked:(id)sender {
 [self removeFromSuperview];
}
@end
