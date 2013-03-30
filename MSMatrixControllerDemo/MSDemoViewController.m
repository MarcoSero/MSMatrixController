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
  _goLeftButton.enabled = (BOOL)self.leftViewController;
  _goRightButton.enabled = (BOOL)self.rightViewController;
  _goUpButton.enabled = (BOOL)self.topViewController;
  _goDownButton.enabled = (BOOL)self.bottomViewController;
}

- (IBAction)goLeft:(id)sender
{
  [self.masterViewController goLeft];
}

- (IBAction)goRight:(id)sender
{
  [self.masterViewController goRight];
}

- (IBAction)goUp:(id)sender
{
  [self.masterViewController goUp];
}

- (IBAction)goDown:(id)sender
{
  [self.masterViewController goDown];
}

@end
