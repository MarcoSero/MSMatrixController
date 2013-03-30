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

- (void)panDetected:(MSPanGestureRecognizer *)pan
{
  if (pan.state == UIGestureRecognizerStateBegan) {
    _positionBeforePan = self.view.frame.origin;
    _lastPanningWay = pan.way;
  }
  else if (pan.state == UIGestureRecognizerStateChanged) {
    [self handlePanWithDirection:pan.direction way:pan.way velocity:[pan velocityInView:self.view] translation:[pan translationInView:self.view]];
  }
  else if (pan.state == UIGestureRecognizerStateEnded) {
    [self handleEndedPanWithDirection:pan.direction translation:[pan translationInView:self.view] velocity:[pan velocityInView:self.view]];
  }
}

- (void)handlePanWithDirection:(MSPanDirection)direction way:(MSPanWay)way velocity:(CGPoint)velocity translation:(CGPoint)translation
{
  /*

if ((direction == MSPanDirectionRight && _visibleViewController.rightViewController == nil) ||
(direction == MSPanDirectionLeft && _visibleViewController.leftViewController == nil) ||
(direction == MSPanDirectionUp && _visibleViewController.topViewController == nil) ||
(direction == MSPanDirectionDown && _visibleViewController.bottomViewController == nil)) {
  return;
}
*/

  if (_lastPanningWay != way) {
    return;
  }

  if (direction == MSPanDirectionRight || direction == MSPanDirectionLeft) {
    translation.y = 0;
  }
  else if (direction == MSPanDirectionUp || direction == MSPanDirectionDown) {
    translation.x = 0;
  }
  else {
    return;
  }

  CGRect frame = self.view.frame;
  CGPoint newOrigin;
  newOrigin.x = _positionBeforePan.x + translation.x;
  newOrigin.y = _positionBeforePan.y + translation.y;
  frame.origin = newOrigin;
  self.view.frame = frame;
}

- (void)handleEndedPanWithDirection:(MSPanDirection)direction translation:(CGPoint)translation velocity:(CGPoint)velocity
{

  const CGFloat horizontalThreshold = _visibleViewController.view.frame.size.width / 4;
  const CGFloat verticalThreshold = _visibleViewController.view.frame.size.height / 4;
  const CGFloat velocityThreshold = 1000;

  BOOL nextControllerExists = NO;
  nextControllerExists |= direction == MSPanDirectionRight && _visibleViewController.rightViewController;
  nextControllerExists |= direction == MSPanDirectionLeft && _visibleViewController.leftViewController;
  nextControllerExists |= direction == MSPanDirectionUp && _visibleViewController.topViewController;
  nextControllerExists |= direction == MSPanDirectionDown && _visibleViewController.bottomViewController;

  BOOL overHorizontalThreshold = fabs(translation.x) > horizontalThreshold;
  BOOL overVerticalThreshold = fabs(translation.y) > verticalThreshold;
  BOOL overVelocityXThreshold = fabs(velocity.x) > velocityThreshold;
  BOOL overVelocityYThreshold = fabs(velocity.y) > velocityThreshold;


  if (!nextControllerExists) {
    [self goToViewController:_visibleViewController];
    return;
  }

  NSLog(@"velocity x %f y %f", velocity.x, velocity.y);

  if (overHorizontalThreshold || overVelocityXThreshold) {
    NSLog(@"X axis");
    if (direction == MSPanDirectionLeft) {
      NSLog(@"goto left controller");
      [self goToViewController:_visibleViewController.leftViewController];
    }
    else if (direction == MSPanDirectionRight) {
      NSLog(@"goto right controller");
      [self goToViewController:_visibleViewController.rightViewController];
    }
  }
  else if (overVerticalThreshold || overVelocityYThreshold) {
    NSLog(@"Y axis");
    if (direction == MSPanDirectionUp) {
      NSLog(@"goto top controller");
      [self goToViewController:_visibleViewController.topViewController];
    }
    else if (direction == MSPanDirectionDown) {
      NSLog(@"goto bottom controller");
      [self goToViewController:_visibleViewController.bottomViewController];
    }
  }
  else {
    NSLog(@"go to original view controller");
    [self goToViewController:_visibleViewController];
  }
}

- (void)goToViewController:(MSCartesianChildViewController *)newController
{
  [UIView animateWithDuration:0.5 animations:^{
    NSLog(@"old frame %@", self.view);
    CGRect frameForVisibleViewController = self.view.frame;
    frameForVisibleViewController.origin.x = -newController.view.frame.origin.x;
    frameForVisibleViewController.origin.y = -newController.view.frame.origin.y;
    self.view.frame = frameForVisibleViewController;
    NSLog(@"new frame %@", self.view);
  }                completion:^(BOOL finished) {
    if (finished) {
      _visibleViewController = newController;
      NSLog(@"visible view controller changed %@", _visibleViewController.view);
    }
  }];
}

@end