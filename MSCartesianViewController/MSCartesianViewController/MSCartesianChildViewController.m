//
//  Created by marco on 29/03/13.
//
//
//


#import "MSCartesianChildViewController.h"


@implementation MSCartesianChildViewController

- (void)setRow:(NSInteger)row
{
  _row = row;

  Position newPosition = _position;
  newPosition.row = row;
  _position = newPosition;
}

- (void)setCol:(NSInteger)col
{
  _col = col;
  Position newPosition = _position;
  newPosition.col = col;
  _position = newPosition;
}

@end