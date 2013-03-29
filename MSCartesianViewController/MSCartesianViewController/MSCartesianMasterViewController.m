//
//  Created by marco on 29/03/13.
//
//
//


#import "MSCartesianMasterViewController.h"
#import "MSCartesianChildViewController.h"

@interface MSCartesianMasterViewController ()
@end

@implementation MSCartesianMasterViewController

- (void)setChildren:(NSArray *)children
{
  _childrenViewControllers = children;
  [self setAdjacentViewControllers];
  _visibleViewController = [_childrenViewControllers objectAtIndex:0];
}

- (void)setAdjacentViewControllers
{
  for (MSCartesianChildViewController *child in _childrenViewControllers) {
    Position left = child.position;
    left.col = left.col - 1;
    Position right = child.position;
    right.col = right.col + 1;
    Position top = child.position;
    top.row = top.row - 1;
    Position bottom = child.position;
    bottom.row = bottom.row + 1;

    child.leftViewController = [self getControllerAtPosition:left];
    child.rightViewController = [self getControllerAtPosition:right];
    child.topViewController = [self getControllerAtPosition:top];
    child.bottomViewController = [self getControllerAtPosition:bottom];
  }
}

- (MSCartesianChildViewController *)getControllerAtPosition:(Position)position
{
  NSPredicate *positionPredicate = [NSPredicate predicateWithFormat:@"row == %d AND col == %d", position.row, position.col];
  NSArray *viewControllersWithMatchedPosition = [_childrenViewControllers filteredArrayUsingPredicate:positionPredicate];
  if (viewControllersWithMatchedPosition.count == 0) {
    return nil;
  }
  return [viewControllersWithMatchedPosition objectAtIndex:0];
}

@end