//
//  Created by marco on 29/03/13.
//
//
//


#import "MSCartesianMasterViewController.h"
#import "MSCartesianChildViewController.h"

typedef enum {
  MSPanDirectionRight,
  MSPanDirectionLeft,
  MSPanDirectionUp,
  MSPanDirectionDown
} MSPanDirection;

@interface MSCartesianMasterViewController ()
@property(strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation MSCartesianMasterViewController

- (void)viewDidLoad
{
  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
  [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)setChildren:(NSArray *)children
{
  _childrenViewControllers = children;
  [self setAdjacentViewControllers];

  _visibleViewController = [_childrenViewControllers objectAtIndex:0];
  [self changeCurrentViewControllerWithController:_visibleViewController];
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

- (void)panDetected:(UIPanGestureRecognizer *)panGestureRecognizer
{
  if (panGestureRecognizer.state != UIGestureRecognizerStateEnded) {
    return;
  }

  CGFloat const gestureMinimumTranslation = 20.0;
  CGPoint translation = [panGestureRecognizer translationInView:self.view];
  MSPanDirection panDirection;

  // determine if horizontal swipe only if you meet some minimum velocity
  if (fabs(translation.x) > gestureMinimumTranslation) {
    BOOL gestureHorizontal = NO;

    if (translation.y == 0.0) {
      gestureHorizontal = YES;
    } else {
      gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
    }

    if (gestureHorizontal) {
      if (translation.x > 0.0) {
        NSLog(@"moved right");
        panDirection = MSPanDirectionRight;
      } else {
        NSLog(@"moved left");
        panDirection = MSPanDirectionLeft;
      }
    }
  }
  // determine if vertical swipe only if you meet some minimum velocity
  else if (fabs(translation.y) > gestureMinimumTranslation) {
    BOOL gestureVertical = NO;

    if (translation.x == 0.0) {
      gestureVertical = YES;
    } else {
      gestureVertical = (fabs(translation.y / translation.x) > 5.0);
    }

    if (gestureVertical) {
      if (translation.y > 0.0) {
        NSLog(@"moved down");
        panDirection = MSPanDirectionDown;
      } else {
        NSLog(@"moved up");
        panDirection = MSPanDirectionUp;
      }
    }
  }

  [self changeCurrentViewControllerAfterPanDirection:panDirection];
}

- (void)changeCurrentViewControllerAfterPanDirection:(MSPanDirection)panDirection
{
  NSInteger direction = panDirection;
  switch (direction) {
    case MSPanDirectionRight:
      [self changeCurrentViewControllerWithController:_visibleViewController.leftViewController];
      break;
    case MSPanDirectionLeft:
      [self changeCurrentViewControllerWithController:_visibleViewController.rightViewController];
      break;
    case MSPanDirectionUp:
      [self changeCurrentViewControllerWithController:_visibleViewController.bottomViewController];
      break;
    case MSPanDirectionDown:
      [self changeCurrentViewControllerWithController:_visibleViewController.topViewController];
      break;
    default:
      break;
  }
}

- (void)changeCurrentViewControllerWithController:(MSCartesianChildViewController *)newController
{
  if (newController == nil) {
    return;
  }

  // remove old
  [_visibleViewController willMoveToParentViewController:self];
  [_visibleViewController.view removeFromSuperview];
  [_visibleViewController removeFromParentViewController];

  // add new
  [self addChildViewController:newController];
  newController.view.frame = self.view.bounds;
  [self.view addSubview:newController.view];
  [newController didMoveToParentViewController:self];

  _visibleViewController = newController;
}

@end