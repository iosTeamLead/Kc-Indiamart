//
//  UtilityText.m
//  MyVite
//
//  Created by Apple on 05/05/14.
//
//

#import "UtilityText.h"
#import <UIKit/UIKit.h>

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static CGFloat animatedDistance = 0.0;
#define kOFFSET_FOR_KEYBOARD 150.0
const int kTagConfirmationPopUp = 1;
const int kTagInformationPopUp = 2;

const float kDefaultCellFontSize = 12.0;
@implementation UtilityText


//TextField
+ (void)textFieldDidBeginEditing:(UIView *)textField view:(UIView*)view
{
	CGRect textFieldRect =
	[view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect =
	[view.window convertRect:view.bounds fromView:view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = view.frame;
	viewFrame.origin.y -= animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

+ (void)textFieldDidEndEditing:(UIView*)textField view:(UIView*)view
{
	CGRect viewFrame = view.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

+(void)setViewMovedUp:(BOOL)movedUp view:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = view.frame;
    if (movedUp)
    {
        
        if (rect.origin.y>=0) {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        }
        //        else{
        //        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        
        
        //        }
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        //        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        // rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        if (rect.origin.y<0) {
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            [view endEditing:YES];
        }
        //        if (rect.origin.y<-kOFFSET_FOR_KEYBOARD) {
        //            rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //
        //        }
        //        else{
        //        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //        }
        // revert back to the normal state.
        //       rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
   view.frame = rect;
    
    [UIView commitAnimations];
}

+ (void)showAlertWithAlert:(UIViewController *)ViewController Alert:(NSString *)Alert message:(NSString *)Message cancelTitle:(NSString *)Cancel{
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:Alert message:Message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [ViewController presentViewController:alert animated:YES completion:nil];

    
    
}





@end
