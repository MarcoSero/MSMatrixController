//
//  Created by marco on 29/03/13.
//
//
//


#import <Foundation/Foundation.h>

typedef struct {
  int row;
  int col;
} Position;

@interface MSCartesianChildViewController : UIViewController

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger col;

@property (assign, readonly, nonatomic) Position position;

@property (weak, nonatomic) MSCartesianChildViewController *leftViewController;
@property (weak, nonatomic) MSCartesianChildViewController *rightViewController;
@property (weak, nonatomic) MSCartesianChildViewController *topViewController;
@property (weak, nonatomic) MSCartesianChildViewController *bottomViewController;

@end