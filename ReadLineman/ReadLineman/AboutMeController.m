//
//  AboutMeController.m
//  ReadLineman
//
//  Created by spring sky on 14-5-16.
//  Copyright (c) 2014年 spring sky. All rights reserved.
//

#import "AboutMeController.h"

@interface AboutMeController ()

@end

@implementation AboutMeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
