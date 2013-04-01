
#import "MSPanGestureRecognizer.h"

@implementation MSPanGestureRecognizer

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
