//
//  Created by marco on 30/03/13.
//
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MSCartesianMasterViewController.h"

@interface MSPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>
// must be set in viewDidAppear methods, or else maps would not have had the chance to set up yet
@property (nonatomic, assign) NSUInteger minNumberTouchesLeft;
@property (nonatomic, assign) NSUInteger minNumberTouchesRight;
@property (nonatomic, assign) NSUInteger minNumberTouchesUp;
@property (nonatomic, assign) NSUInteger minNumberTouchesDown;

-(void)setRecognizerState:(UIGestureRecognizerState)state;
-(MSPanDirection)direction;
@end