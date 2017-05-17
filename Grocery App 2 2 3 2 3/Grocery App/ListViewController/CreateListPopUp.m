//
//  CreateListPopUp.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "CreateListPopUp.h"
#import "Server.h"
#import "UtilityText.h"
#import "DetailListViewController.h"
#import "groceryProductData.h"

@implementation CreateListPopUp

@synthesize device;
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


-(id)initWithListName :(CGRect)frame delegate:(id)delegate {
 self = [super initWithFrame:frame];
 
 if (self) {
  [[NSBundle mainBundle]loadNibNamed:@"CreateListPopUp" owner:self options:nil];
  
  self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
 
  self.delegate = delegate;
     _txtListName.delegate = self;
  [self.view layoutIfNeeded];
  [self backGroundView];
  [self addSubview:self.view];
  
 }
 return self;
 
}


- (IBAction)btnSavePressed:(id)sender {
    
    if (_txtListName.text.length<=0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter some text" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil   , nil];
        [alert show];
    }
    else{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.device) {
        // Update existing device
        [self.device setValue:@"Hedfgjvbsfjgllo" forKey:@"listName"];
        
        
    } else {
       
        [[groceryProductData sharedManager]saveMyProduct:nil quantity:nil mylistName:_txtListName.text notes:nil];
        
        // Create a new device
//        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:context];
//        [newDevice setValue:_txtListName.text forKey:@"listName"];
//        if (kGetValueForKey(notesText)!=nil) {
//            [newDevice setValue:@"" forKey:notesText];
//
//        }
//        else{
//            [newDevice setValue:@"" forKey:notesText];
//
//        }
//
        kSetValueForKey(listName, _txtListName.text);
        
    }

    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
    

    
 [self.delegate saveBtnTapped:self];
 
}
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText setViewMovedUp:YES view:self.view];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UtilityText setViewMovedUp:NO view:self.view];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    [self .view endEditing: YES];
    [UtilityText setViewMovedUp:NO view:self.view];
    
    return  YES;
}


- (IBAction)tabGesture:(id)sender {
    if (_txtListName.text.length<=0) {
        [self.delegate saveBtnTapped:self];

    }
    [UtilityText setViewMovedUp:NO view:self.view];
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
@end
