//
//  Created by marco on 30/03/13.
//
//
//


#import <Foundation/Foundation.h>

@class MSMatrixMasterViewController;

typedef struct {
  int row;
  int col;
} Position;

@interface UIViewController (MSMatrixController)

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger col;

@property (assign, readonly, nonatomic) Position position;

@property (weak, nonatomic) MSMatrixMasterViewController *matrixViewController;
@property (weak, nonatomic) UIViewController *leftViewController;
@property (weak, nonatomic) UIViewController *rightViewController;
@property (weak, nonatomic) UIViewController *topViewController;
@property (weak, nonatomic) UIViewController *bottomViewController;

@end