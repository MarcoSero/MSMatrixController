//
//  MSDemoViewController.m
//  MSMatrixController
//
//  Created by Marco Sero on 30/03/13.
//  Copyright (c) 2013 Marco Sero. All rights reserved.
//

#import "MSDemoViewController.h"
#import "UIViewController+MSMatrixController.h"
#import "MSMatrixMasterViewController.h"

@interface MSDemoViewController ()
@property(weak, nonatomic) IBOutlet UIButton *goUpButton;
@property(weak, nonatomic) IBOutlet UIButton *goLeftButton;
@property(weak, nonatomic) IBOutlet UIButton *goRightButton;
@property(weak, nonatomic) IBOutlet UIButton *goDownButton;
@end

@implementation MSDemoViewController

- (void)viewDidLoad
{
  _goLeftButton.hidden = !(BOOL)self.leftViewController;
  _goRightButton.hidden = !(BOOL)self.rightViewController;
  _goUpButton.hidden = !(BOOL)self.topViewController;
  _goDownButton.hidden = !(BOOL)self.bottomViewController;
}

- (IBAction)goLeft:(id)sender
{
  [self.masterViewController moveLeftAnimated:NO];
}

- (IBAction)goRight:(id)sender
{
  [self.masterViewController moveRightAnimated:NO];
}

- (IBAction)goUp:(id)sender
{
  [self.masterViewController moveUpAnimated:NO];
}

- (IBAction)goDown:(id)sender
{
  [self.masterViewController moveDownAnimated:NO];
}

@end
