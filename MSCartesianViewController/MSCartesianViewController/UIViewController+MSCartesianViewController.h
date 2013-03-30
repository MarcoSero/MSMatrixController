//
//  Created by marco on 30/03/13.
//
//
//


#import <Foundation/Foundation.h>

@class MSCartesianMasterViewController;

typedef struct {
  int row;
  int col;
} Position;

@interface UIViewController (MSCartesianViewController)

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger col;

@property (assign, readonly, nonatomic) Position position;

@property (weak, nonatomic) MSCartesianMasterViewController *masterViewController;
@property (weak, nonatomic) UIViewController *leftViewController;
@property (weak, nonatomic) UIViewController *rightViewController;
@property (weak, nonatomic) UIViewController *topViewController;
@property (weak, nonatomic) UIViewController *bottomViewController;


@end