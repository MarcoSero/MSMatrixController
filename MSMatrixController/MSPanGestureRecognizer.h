
#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MSMatrixMasterViewController.h"

typedef enum {
  MSPanDirectionRight,
  MSPanDirectionLeft,
  MSPanDirectionUp,
  MSPanDirectionDown
} MSPanDirection;

typedef enum {
  MSPanWayNone,
  MSPanWayHorizontal,
  MSPanWayVertical
} MSPanWay;


@interface MSPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) MSPanWay way;
@property (nonatomic, readonly) MSPanDirection direction;

@end