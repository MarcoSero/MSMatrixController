//
//  Created by marco on 29/03/13.
//
//
//


#import <CoreGraphics/CoreGraphics.h>
#import "MSCartesianMasterViewController.h"
#import "MSCartesianChildViewController.h"
#import "MSCartesianView.h"
#import "MSPanGestureRecognizer.h"


@interface MSCartesianMasterViewController ()
@property(strong, nonatomic) MSPanGestureRecognizer *panGestureRecognizer;
@property(assign, nonatomic) CGPoint positionBeforePan;
@property(assign, nonatomic) MSPanWay lastPanningWay;
@property(assign, nonatomic) NSInteger numberPanDetectedCalled;
@end

@implementation MSCartesianMasterViewController {
  int _numberPanDetectedCalled;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super init];
  if (self) {
    self.view = [[MSCartesianView alloc] initWithFrame:frame];
    return self;
  }
  return nil;
}

- (void)setChildren:(NSArray *)children
{
  _childrenViewControllers = children;

  NSInteger maxRows = 0;
  NSInteger maxCols = 0;
  CGFloat screenWidth = self.view.frame.size.width;
  CGFloat screenHeight = self.view.frame.size.height;
  for (MSCartesianChildViewController *child in _childrenViewControllers) {

    maxRows = MAX(maxRows, child.row);
    maxCols = MAX(maxCols, child.col);

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

    CGRect frameInsideMasterView = child.view.frame;
    frameInsideMasterView.origin.x = screenWidth * child.col;
    frameInsideMasterView.origin.y = screenHeight * child.row;
    child.view.frame = frameInsideMasterView;
  }

  CGSize contentSize = CGSizeMake(screenWidth * (maxCols + 1), screenHeight * (maxRows + 1));
  CGRect frame = self.view.frame;
  frame.size = contentSize;
  self.view.frame = frame;

  for (MSCartesianChildViewController *child in _childrenViewControllers) {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
  }

  _panGestureRecognizer = [[MSPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
  [self.view addGestureRecognizer:_panGestureRecognizer];

  _visibleViewController = [_childrenViewControllers objectAtIndex:0];
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

- (void)panDetected:(UIPanGestureRecognizer *)pan
{

  if (pan.state == UIGestureRecognizerStateBegan) {
    _positionBeforePan = self.view.frame.origin;
    _lastPanningWay = MSPanWayNone;
    _numberPanDetectedCalled = 0;
  }

  CGFloat const gestureMinimumTranslation = 20.0;
  CGPoint translation = [pan translationInView:self.view];
  CGPoint velocity = [pan velocityInView:self.view];
  MSPanDirection panDirection = MSPanDirectionNone;
  MSPanWay panWay = MSPanWayNone;
  _numberPanDetectedCalled++;

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
      panWay = MSPanWayHorizontal;
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
      panWay = MSPanWayVertical;
    }
  }


  if (_numberPanDetectedCalled == 2) {
    _lastPanningWay = panWay;
  }

  if (panWay != _lastPanningWay) {
    return;
  }

  if (pan.state == UIGestureRecognizerStateEnded) {
    [self handleEndedPanWithDirection:panDirection translation:translation velocity:velocity];
  }
  else {
    NSLog(@"handle pan with direction %d", panDirection);
   [self handlePanWithDirection:panDirection translation:translation velocity:velocity];
  }
}

- (void)handleEndedPanWithDirection:(MSPanDirection)direction translation:(CGPoint)translation velocity:(CGPoint)velocity
{
  const CGFloat horizontalThreshold = _visibleViewController.view.frame.size.width / 2;
  const CGFloat verticalThreshold = _visibleViewController.view.frame.size.height / 2;

  if (fabs(translation.x) > horizontalThreshold) {
    if (direction == MSPanDirectionLeft && _visibleViewController.rightViewController) {
      [self goToViewController:_visibleViewController.rightViewController];
    }
    else if (direction == MSPanDirectionRight && _visibleViewController.leftViewController) {
      [self goToViewController:_visibleViewController.leftViewController];
    }
  }
  else if (fabs(translation.y) > verticalThreshold) {
    if (direction == MSPanDirectionUp && _visibleViewController.bottomViewController) {
      [self goToViewController:_visibleViewController.bottomViewController];
    }
    else if (direction == MSPanDirectionDown && _visibleViewController.topViewController) {
      [self goToViewController:_visibleViewController.topViewController];
    }
  }
}

- (void)goToViewController:(MSCartesianChildViewController *)newController
{
  NSLog(@"goto view controller CALLED");
  [UIView animateWithDuration:0.5 animations:^{
    CGRect frame = self.view.frame;
    frame.origin = newController.view.frame.origin;
    self.view.frame = frame;
  }                completion:^(BOOL finished) {
    if (finished) {
      _visibleViewController = newController;
    }
  }];
}

- (void)handlePanWithDirection:(MSPanDirection)direction translation:(CGPoint)translation velocity:(CGPoint)velocity
{
  if ((direction == MSPanDirectionRight && _visibleViewController.leftViewController == nil) ||
    (direction == MSPanDirectionLeft && _visibleViewController.rightViewController == nil) ||
    (direction == MSPanDirectionUp && _visibleViewController.bottomViewController == nil) ||
    (direction == MSPanDirectionDown && _visibleViewController.topViewController == nil)) {
    return;
  }

  /*
  if ((_lastPanningWay == MSWayPanHorizontal && (direction == MSPanDirectionUp || direction == MSPanDirectionDown)) ||
    (_lastPanningWay == MSWayPanVertical && (direction == MSPanDirectionRight || direction == MSPanDirectionLeft))) {
    return;
  }
  */

  if (direction == MSPanDirectionRight || direction == MSPanDirectionLeft) {
    translation.y = 0;
  }
  else if (direction == MSPanDirectionUp || direction == MSPanDirectionDown) {
    translation.x = 0;
  }
  else {
    return;
  }

  NSLog(@"direction %d ... applying translation %f %f", direction, translation.x, translation.y);

  CGRect frame = self.view.frame;
  CGPoint newOrigin;
  newOrigin.x = _positionBeforePan.x + translation.x;
  newOrigin.y = _positionBeforePan.y + translation.y;
  frame.origin = newOrigin;
  self.view.frame = frame;
}

- (void)changeCurrentViewControllerAfterPanDirection:(MSPanDirection)panDirection
{
  NSInteger direction = panDirection;
  CGFloat maxX = self.view.frame.size.width;
  CGFloat maxY = self.view.frame.size.height;
  switch (direction) {
    case MSPanDirectionRight:
      [self changeCurrentViewControllerWithController:_visibleViewController.leftViewController finishAnimationAtPoint:CGPointMake(maxX, 0)];
      break;
    case MSPanDirectionLeft:
      [self changeCurrentViewControllerWithController:_visibleViewController.rightViewController finishAnimationAtPoint:CGPointMake(-maxX, 0)];
      break;
    case MSPanDirectionUp:
      [self changeCurrentViewControllerWithController:_visibleViewController.bottomViewController finishAnimationAtPoint:CGPointMake(0, -maxY)];
      break;
    case MSPanDirectionDown:
      [self changeCurrentViewControllerWithController:_visibleViewController.topViewController finishAnimationAtPoint:CGPointMake(0, maxY)];
      break;
    default:
      break;
  }
}

- (void)changeCurrentViewControllerWithController:(MSCartesianChildViewController *)newController finishAnimationAtPoint:(CGPoint)pointForAnimation
{
  if (newController == nil) {
    return;
  }

  // add new
  [self addChildViewController:newController];
  newController.view.frame = self.view.bounds;
  [self.view insertSubview:newController.view belowSubview:_visibleViewController.view];
  [newController didMoveToParentViewController:self];

  [UIView animateWithDuration:1.0 animations:^{

    CGRect newRect = _visibleViewController.view.frame;
    newRect.origin = pointForAnimation;
    _visibleViewController.view.frame = newRect;

  }                completion:^(BOOL finished) {
    if (finished) {
      // remove old
      [_visibleViewController willMoveToParentViewController:self];
      [_visibleViewController.view removeFromSuperview];
      [_visibleViewController removeFromParentViewController];
      _visibleViewController = newController;
    }
  }];

}

@end