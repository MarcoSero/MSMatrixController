//
//  Created by marco on 29/03/13.
//
//
//


#import <Foundation/Foundation.h>

@class MSCartesianChildViewController;


@interface MSCartesianMasterViewController : UIViewController

@property (weak, readonly, nonatomic) MSCartesianChildViewController *visibleViewController;
@property (strong, readonly, nonatomic) NSArray *childrenViewControllers;


- (void)setChildren:(NSArray *)children;

@end