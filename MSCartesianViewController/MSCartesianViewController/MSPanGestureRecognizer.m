//
//  Created by marco on 30/03/13.
//
//
//


#import "MSPanGestureRecognizer.h"

@interface MSPanGestureRecognizer ()
@property(nonatomic, assign) NSUInteger minNumberTouchesLeft;
@property(nonatomic, assign) NSUInteger minNumberTouchesRight;
@property(nonatomic, assign) NSUInteger minNumberTouchesUp;
@property(nonatomic, assign) NSUInteger minNumberTouchesDown;
@end

@implementation MSPanGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
  if (self = [super initWithTarget:target action:action]) {
    self.delegate = self;
    _minNumberTouchesUp = 1;
    _minNumberTouchesRight = 1;
    _minNumberTouchesLeft = 1;
    _minNumberTouchesDown = 1;
  }
  return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
  CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
  BOOL isVertical = fabs(velocity.y) > fabs(velocity.x);
  if (isVertical) {
    if (velocity.y < 0) {
      if (gestureRecognizer.numberOfTouches < _minNumberTouchesDown) {
        return NO;
      }
    }
    else {
      if (gestureRecognizer.numberOfTouches < _minNumberTouchesUp) {
        return NO;
      }
    }
  }
  else {
    if (velocity.x > 0) {
      if (gestureRecognizer.numberOfTouches < _minNumberTouchesLeft) {
        return NO;
      }
    }
    else {
      if (gestureRecognizer.numberOfTouches < _minNumberTouchesRight) {
        return NO;
      }
    }
  }

  return YES;
}

- (MSPanDirection)direction
{
  CGPoint velocity = [self velocityInView:self.view.window];
  if (fabs(velocity.y) > fabs(velocity.x)) {
    if (velocity.y > 0) {
      return MSPanDirectionUp;
    }
    else {
      return MSPanDirectionDown;
    }
  }
  else {
    if (velocity.x > 0) {
      return MSPanDirectionLeft;
    }
    else {
      return MSPanDirectionRight;
    }
  }
}


- (MSPanWay)way
{
  CGPoint velocity = [self velocityInView:self.view.window];
  if (fabs(velocity.y) > fabs(velocity.x)) {
    return MSPanWayVertical;
  }
  else {
    return MSPanWayHorizontal;
  }
}

@end
