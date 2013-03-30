//
//  Created by marco on 30/03/13.
//
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MSCartesianMasterViewController.h"

@interface MSPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) MSPanWay way;
@property (nonatomic, readonly) MSPanDirection direction;

@end