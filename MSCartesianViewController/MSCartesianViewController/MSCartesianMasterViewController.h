//
//  Created by marco on 29/03/13.
//
//
//


#import <Foundation/Foundation.h>

@class MSCartesianChildViewController;

typedef enum {
  MSPanDirectionNone,
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

@interface MSCartesianMasterViewController : UIViewController

@property (weak, readonly, nonatomic) MSCartesianChildViewController *visibleViewController;
@property (strong, readonly, nonatomic) NSArray *childrenViewControllers;

- (id)initWithFrame:(CGRect)frame;
- (void)setChildren:(NSArray *)children;

@end