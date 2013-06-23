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

#define defaultAlphaHiddenControllers 0.0

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
  [self setControllers:controllers withFrame:self.view.frame];
}

#pragma mark - Public methods

- (void)setVisibleController:(UIViewController *)controller
{
  _visibleViewController = controller;
}

- (void)insertControllers:(NSArray *)controllers shift:(MSDirection)direction
{
  UIViewController *currentVisibleViewController = _visibleViewController;
  
  NSMutableArray *currentControllers = [NSMutableArray arrayWithArray:_viewControllers];
  
  for (UIViewController *controller in controllers) {
    if (controller.row < 0) {
      controller.row = 0;
    }
    
    if (controller.col < 0) {
      controller.col = 0;
    }
    
    switch (direction) {
      case MSShiftHorizontal: {
        for (UIViewController *child in currentControllers) {
          if ((child.row == controller.row) && (child.col >= controller.col)) {
            child.col += 1;
          }
        }
        break;
      }
      default: {
        for (UIViewController *child in currentControllers) {
          if ((child.col == controller.col) && (child.row >= controller.row)) {
            child.row += 1;
          }
        }
        break;
      }
    }
    
    [currentControllers addObject:controller];
  }
  
  [self setControllers:currentControllers withFrame:[[UIScreen mainScreen] applicationFrame]];
 
  _visibleViewController = currentVisibleViewController;
}

- (void)insertController:(UIViewController *)controller shift:(MSDirection)direction
{
  [self insertControllers:@[controller] shift:direction];
}

- (void)resetPositions:(NSArray *)viewControllers {
  
  UIViewController *currentVisibleViewController = _visibleViewController;
  [self setControllers:viewControllers withFrame:[[UIScreen mainScreen] applicationFrame]];
  _visibleViewController = currentVisibleViewController;
  
}

- (void)removeController:(UIViewController *)controller
{
  [self removeControllers:@[controller]];
}

- (void)removeControllers:(NSArray *)controllers {
  UIViewController *currentVisibleViewController = _visibleViewController;
  
  NSMutableArray *currentControllers = [NSMutableArray arrayWithArray:_viewControllers];
  [currentControllers removeObjectsInArray:controllers];
  
  for (UIViewController *viewController in controllers) {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
  }
  
  [self setControllers:currentControllers withFrame:[[UIScreen mainScreen] applicationFrame]];
  
  _visibleViewController = currentVisibleViewController;
}

- (void)removeController:(UIViewController *)controller shift:(MSDirection)direction animated:(BOOL)animated 
{
  UIViewController *rightViewController = controller.rightViewController;
  UIViewController *leftViewController = controller.leftViewController;
  UIViewController *topViewController = controller.topViewController;
  UIViewController *bottomViewController = controller.bottomViewController;
  
  switch (direction) {
    case MSShiftHorizontal: {
      
      // No left or right view controller, just remove it
      if (!leftViewController && !rightViewController) {
        [self removeController:controller];
      } else {
      // Adjacent view controllers exist, need to adjust their postion
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:_viewControllers];
        [controllers removeObject:controller];
        
        for (UIViewController *child in controllers) {
          if ((child.row == controller.row) && (child.col >= controller.col)) {
            child.col -= 1;
          }
        }
        
        if (!animated) {
          [controller willMoveToParentViewController:nil];
          [controller.view removeFromSuperview];
          [controller removeFromParentViewController];
          [self resetPositions:controllers];
        } else {
          
          if (rightViewController) {
            [self moveRightAnimated:YES withCompletion:^{
              
              [controller willMoveToParentViewController:nil];
              [controller.view removeFromSuperview];
              [controller removeFromParentViewController];
              
              [self setControllers:controllers withFrame:[[UIScreen mainScreen] applicationFrame]];
              CGRect newFrame = self.view.frame;
              newFrame.origin.x += [[UIScreen mainScreen] applicationFrame].size.width;
              self.view.frame = newFrame;
              _visibleViewController = rightViewController;
            }];
            
          } else {
            [self moveLeftAnimated:YES withCompletion:^{
              
              [controller willMoveToParentViewController:nil];
              [controller.view removeFromSuperview];
              [controller removeFromParentViewController];
              [self setControllers:controllers withFrame:[[UIScreen mainScreen] applicationFrame]];
              _visibleViewController = leftViewController;
            }];
            
          }
        }
      } 
      break;
    }
    case MSShiftVertical: {
      
      // No top or bottom view controller, just remove it
      if (!topViewController && !bottomViewController) {
        [self removeController:controller];
      } else {
      // Adjacent view controllers exist, need to adjust their postion
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:_viewControllers];
        [controllers removeObject:controller];
        
        for (UIViewController *child in controllers) {
          if ((child.col == controller.col) && (child.row >= controller.row)) {
            child.row -= 1;
          }
        }
        
        if (!animated) {
          [controller willMoveToParentViewController:nil];
          [controller.view removeFromSuperview];
          [controller removeFromParentViewController];
          [self resetPositions:controllers];
        } else {
          if (bottomViewController) {
            [self moveDownAnimated:YES withCompletion:^{
              
              [controller willMoveToParentViewController:nil];
              [controller.view removeFromSuperview];
              [controller removeFromParentViewController];
              
              [self setControllers:controllers withFrame:[[UIScreen mainScreen] applicationFrame]];
              
              CGRect newFrame = self.view.frame;
              newFrame.origin.y += [[UIScreen mainScreen] applicationFrame].size.height;
              self.view.frame = newFrame;
              
              _visibleViewController = bottomViewController;
            }];
          } else {
            [self moveUpAnimated:YES withCompletion:^{
              
              [controller willMoveToParentViewController:nil];
              [controller.view removeFromSuperview];
              [controller removeFromParentViewController];
              [self setControllers:controllers withFrame:[[UIScreen mainScreen] applicationFrame]];
              _visibleViewController = topViewController;
              
            }];
          }
        }

      } 
      break;
    }
    default:
      break;
  }

}

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

- (void)goToViewController:(UIViewController *)controller way:(MSPanWay)way animated:(BOOL)animated completion:(void (^)(void))completion
{
  [self goToViewController:controller translation:CGPointZero velocity:CGPointZero way:way animated:animated completion:completion];
}

- (void)moveController:(UIViewController *)controller toPosition:(Position)position
{
  UIViewController *currentVisibleViewController = _visibleViewController;
 
  controller.row = position.row;
  controller.col = position.col;
  
  [self setControllers:_viewControllers withFrame:[[UIScreen mainScreen] applicationFrame]];
  
  _visibleViewController = currentVisibleViewController;
}

#pragma mark - Private methods

- (CGFloat)alphaHiddenControllers
{
  if (!_alphaHiddenControllers) {
    _alphaHiddenControllers = defaultAlphaHiddenControllers;
  }
  
  return _alphaHiddenControllers;
}

- (void)setControllers:(NSArray *)controllers withFrame:(CGRect)frame
{
  _viewControllers = controllers;
  
  NSInteger maxRows = 0;
  NSInteger maxCols = 0;
  CGFloat screenWidth = frame.size.width;
  CGFloat screenHeight = frame.size.height;
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
  
  _maxRow = maxRows;
  _maxCol = maxCols;
  
  CGSize contentSize = CGSizeMake(screenWidth * (maxCols + 1), screenHeight * (maxRows + 1));
  CGRect newFrame = self.view.frame;
  newFrame.size = contentSize;
  self.view.frame = newFrame;
  
  for (UIViewController *child in _viewControllers) {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
  }
  
  _panGestureRecognizer = [[MSPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
  [self.view addGestureRecognizer:_panGestureRecognizer];
  
  _visibleViewController = [_viewControllers objectAtIndex:0];
}

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
  _visibleViewController.view.alpha = self.alphaHiddenControllers + fabsf(1 - alphaValue);
  for (UIViewController *destination in _destinationControllersInWay) {
    destination.view.alpha = self.alphaHiddenControllers + alphaValue;
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
    if (!self.parentViewController) {
      frameForVisibleViewController.origin.y = -newController.view.frame.origin.y + 20;
    } else {
      frameForVisibleViewController.origin.y = -newController.view.frame.origin.y;
    }
    self.view.frame = frameForVisibleViewController;

    if (_visibleViewController != newController) {
      _visibleViewController.view.alpha = self.alphaHiddenControllers;
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