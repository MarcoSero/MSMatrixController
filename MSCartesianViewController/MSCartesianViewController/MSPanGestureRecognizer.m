//
//  Created by marco on 30/03/13.
//
//
//


#import "MSPanGestureRecognizer.h"

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

- (void)setRecognizerState:(UIGestureRecognizerState)state
{
  self.state = state;
}

@end
