// MSMatrixMasterViewController.m
//
// Copyright (c) 2013 Marco Sero (http://www.marcosero.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSMatrixMasterViewController.h"
#import "MSMatrixView.h"
#import "MSPanGestureRecognizer.h"

#define alphaHiddenControllers 0.0

@interface MSMatrixMasterViewController ()
@property(strong, nonatomic) MSPanGestureRecognizer *panGestureRecognizer;
@property(assign, nonatomic) CGPoint positionBeforePan;
@property(assign, nonatomic) MSPanWay lastPanningWay;
@property(strong, nonatomic) NSMutableArray *destinationControllersInWay;
@end

@implementation MSMatrixMasterViewController

- (id)initWithFrame:(CGRect)frame
{
  self = [super init];
  if (self) {
    self.view = [[MSMatrixView alloc] initWithFrame:frame];
    return self;
  }
  return nil;
}

- (void)setControllers:(NSArray *)controllers
{
  _viewControllers = controllers;

  NSInteger maxRows = 0;
  NSInteger maxCols = 0;
  CGFloat screenWidth = self.view.frame.size.width;
  CGFloat screenHeight = self.view.frame.size.height;
  for (UIViewController *child in _viewControllers) {

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

  for (UIViewController *child in _viewControllers) {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
  }

  _panGestureRecognizer = [[MSPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
  [self.view addGestureRecognizer:_panGestureRecognizer];

  _visibleViewController = [_viewControllers objectAtIndex:0];
}

#pragma mark - Public methods

- (void)moveLeftAnimated:(BOOL)animated
{
  [self moveLeftAnimated:animated withCompletion:nil];
}

- (void)moveRightAnimated:(BOOL)animated
{
  [self moveRightAnimated:animated withCompletion:nil];
}

- (void)moveUpAnimated:(BOOL)animated
{
  [self moveUpAnimated:animated withCompletion:nil];
}

- (void)moveDownAnimated:(BOOL)animated
{
  [self moveDownAnimated:animated withCompletion:nil];
}

- (void)moveLeftAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
  [self goToViewController:_visibleViewController.leftViewController way:MSPanWayHorizontal animated:animated completion:completion];
}

- (void)moveRightAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
  [self goToViewController:_visibleViewController.rightViewController way:MSPanWayHorizontal animated:animated completion:completion];
}

- (void)moveUpAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
  [self goToViewController:_visibleViewController.topViewController way:MSPanWayVertical animated:animated completion:completion];
}

- (void)moveDownAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
  [self goToViewController:_visibleViewController.bottomViewController way:MSPanWayVertical animated:animated completion:completion];
}

- (UIViewController *)getControllerAtPosition:(Position)position
{
  NSPredicate *positionPredicate = [NSPredicate predicateWithFormat:@"row == %d AND col == %d", position.row, position.col];
  NSArray *viewControllersWithMatchedPosition = [_viewControllers filteredArrayUsingPredicate:positionPredicate];
  if (viewControllersWithMatchedPosition.count == 0) {
    return nil;
  }
  return [viewControllersWithMatchedPosition objectAtIndex:0];
}

#pragma mark - Private methods

- (void)panDetected:(MSPanGestureRecognizer *)pan
{
  if (pan.state == UIGestureRecognizerStateBegan) {
    _positionBeforePan = self.view.frame.origin;
    _lastPanningWay = pan.way;
    [self setDestinationControllersWithWay:pan.way];
  }
  else if (pan.state == UIGestureRecognizerStateChanged) {
    [self handlePanWithDirection:pan.direction way:pan.way velocity:[pan velocityInView:self.view] translation:[pan translationInView:self.view]];
  }
  else if (pan.state == UIGestureRecognizerStateEnded) {
    [self handleEndedPanWithDirection:pan.direction way:pan.way velocity:[pan velocityInView:self.view] translation:[pan translationInView:self.view]];
  }
}

- (void)setDestinationControllersWithWay:(MSPanWay)way
{
  _destinationControllersInWay = [NSMutableArray array];
  if (way == MSPanWayHorizontal) {
    if (_visibleViewController.leftViewController) {
      [_destinationControllersInWay addObject:_visibleViewController.leftViewController];
    }
    if (_visibleViewController.rightViewController) {
      [_destinationControllersInWay addObject:_visibleViewController.rightViewController];
    }
  }
  else {
    if (_visibleViewController.topViewController) {
      [_destinationControllersInWay addObject:_visibleViewController.topViewController];
    }
    if (_visibleViewController.bottomViewController) {
      [_destinationControllersInWay addObject:_visibleViewController.bottomViewController];
    }
  }
}

- (void)handlePanWithDirection:(MSPanDirection)direction way:(MSPanWay)way velocity:(CGPoint)velocity translation:(CGPoint)translation
{
  if (_lastPanningWay != way) {
    return;
  }

  if (way == MSPanWayHorizontal) {
    translation.y = 0;
  }
  else if (way == MSPanWayVertical) {
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

  CGFloat movedPoints = 0;
  CGFloat totalPoints = 0;

  if (way == MSPanWayHorizontal) {
    totalPoints = _visibleViewController.view.frame.size.width;
    movedPoints = fabsf(translation.x);
  }
  else if (way == MSPanWayVertical) {
    totalPoints = _visibleViewController.view.frame.size.height;
    movedPoints = fabsf(translation.y);
  }

  float alphaValue = movedPoints / totalPoints;
  _visibleViewController.view.alpha = alphaHiddenControllers + fabsf(1 - alphaValue);
  for (UIViewController *destination in _destinationControllersInWay) {
    destination.view.alpha = alphaHiddenControllers + alphaValue;
  }
}

- (void)handleEndedPanWithDirection:(MSPanDirection)direction way:(MSPanWay)way velocity:(CGPoint)velocity translation:(CGPoint)translation
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
    [self goToViewController:_visibleViewController translation:translation velocity:CGPointZero way:MSPanWayNone animated:YES completion:^{
    }];
    return;
  }

  if (way == MSPanWayHorizontal && way == _lastPanningWay && (overHorizontalThreshold || overVelocityXThreshold)) {
    if (direction == MSPanDirectionLeft) {
      NSLog(@"goto left controller");
      [self goToViewController:_visibleViewController.leftViewController translation:translation velocity:velocity way:MSPanWayHorizontal animated:YES completion:^{
      }];
      return;
    }
    else if (direction == MSPanDirectionRight) {
      NSLog(@"goto right controller");
      [self goToViewController:_visibleViewController.rightViewController translation:translation velocity:velocity way:MSPanWayHorizontal animated:YES completion:^{
      }];
      return;
    }
  }
  else if (way == MSPanWayVertical && way == _lastPanningWay && (overVerticalThreshold || overVelocityYThreshold)) {
    NSLog(@"Y axis");
    if (direction == MSPanDirectionUp) {
      NSLog(@"goto top controller");
      [self goToViewController:_visibleViewController.topViewController translation:translation velocity:velocity way:MSPanWayVertical animated:YES completion:^{
      }];
      return;
    }
    else if (direction == MSPanDirectionDown) {
      NSLog(@"goto bottom controller");
      [self goToViewController:_visibleViewController.bottomViewController translation:translation velocity:velocity way:MSPanWayVertical animated:YES completion:^{
      }];
      return;
    }
  }

  NSLog(@"go to original view controller");
  [self goToViewController:_visibleViewController translation:translation velocity:CGPointZero way:MSPanWayNone animated:YES completion:^{
  }];

}

- (void)goToViewController:(UIViewController *)controller way:(MSPanWay)way animated:(BOOL)animated completion:(void (^)(void))completion
{
  [self goToViewController:controller translation:CGPointZero velocity:CGPointZero way:way animated:animated completion:completion];
}

- (void)goToViewController:(UIViewController *)newController translation:(CGPoint)translation velocity:(CGPoint)velocity way:(MSPanWay)way animated:(BOOL)animated completion:(void (^)(void))completion
{
  [_delegate willMoveToViewController:newController atPosition:newController.position];

  NSTimeInterval velocityAnimation = INT_MAX;
  if (!animated) {
    velocityAnimation = 0;
  }
  else {
    if (translation.x == 0 && translation.y == 0 && velocity.x == 0 && velocity.y == 0) {
      velocityAnimation = 0.3;
    }

    else {
      if (way == MSPanWayHorizontal) {
        CGFloat points = fabsf(_visibleViewController.view.frame.size.width - (CGFloat)fabs(translation.x));
        CGFloat panVelocity = fabsf(velocity.x);
        if (panVelocity > 0) {
          velocityAnimation = points / panVelocity;
        }
      }
      else {
        CGFloat points = fabsf(translation.y);
        CGFloat panVelocity = fabsf(_visibleViewController.view.frame.size.height - (CGFloat)fabs(velocity.y));
        if (panVelocity > 0) {
          velocityAnimation = points / panVelocity;
        }
      }
      velocityAnimation = MAX(0.3, MIN(velocityAnimation, 0.7));
    }
  }

  [UIView animateWithDuration:velocityAnimation animations:^{
    CGRect frameForVisibleViewController = self.view.frame;
    frameForVisibleViewController.origin.x = -newController.view.frame.origin.x;
    frameForVisibleViewController.origin.y = -newController.view.frame.origin.y + 20;
    self.view.frame = frameForVisibleViewController;

    if (_visibleViewController != newController) {
      _visibleViewController.view.alpha = alphaHiddenControllers;
      newController.view.alpha = 1.0;
    }
    else {
      _visibleViewController.view.alpha = 1.0;
    }
  }                completion:^(BOOL finished) {
    if (finished) {
      // call UIKit view callbacks. not sure it's right
      [_visibleViewController viewDidDisappear:animated];
      [newController viewDidAppear:animated];

      _visibleViewController = newController;
      [_delegate didMoveToViewController:newController atPosition:newController.position];

      if (completion) {
        completion();
      }
    }
  }];
}

@end