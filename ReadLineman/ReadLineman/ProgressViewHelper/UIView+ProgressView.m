//
//  UIView+ProgressView.m
//  GlacierFramework
//
//  Created by spring sky on 14-5-14.
//  Copyright (c) 2014年 spring sky. All rights reserved.
//

#import "UIView+ProgressView.h"
#import "MBProgressHUD.h"

@implementation UIView (ProgressView)

- (MBProgressHUD *)showHUD
{
//    [[MBProgressHUD allHUDsForView:self] enumerateObjectsUsingBlock:^(MBProgressHUD * obj, NSUInteger idx, BOOL *stop) {
//        [obj removeFromSuperview];
//    }];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self
                                               animated:true];
    
    hud.removeFromSuperViewOnHide = true;
    return hud;
}

- (void)showActivity:(NSString *)text forSeconds:(float)seconds userEnabled:(bool)enabled
{
    MBProgressHUD * hud = [self showHUD];
    hud.userInteractionEnabled = !enabled;
    hud.labelText = text;
    [hud hide:true afterDelay:seconds];
}

- (void)showActivityOnlyLabel:(NSString *)text forSeconds:(float)seconds
{
    MBProgressHUD * hud = [self showHUD];
    hud.margin = 15.f;
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = false;
    [hud hide:true afterDelay:seconds];
}

- (void)showActivityForFinish:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate
{
    MBProgressHUD * hud = [self showHUD];
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/37x-Checkmark.png"]] autorelease];
	
	// Set custom view mode
	hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = delegate;
	hud.labelText = text;
    [hud hide:true afterDelay:1.5];
}

- (void)showActivityForText:(NSString*) text
{
    MBProgressHUD * hud = [self showHUD];
    hud.userInteractionEnabled = true;
    hud.labelText = text;
    hud.minShowTime = 3000.0f;
    [hud hide:true];
}

- (void)showActivity
{
    [self showActivity:@"Waiting..." forSeconds:10 userEnabled:false];
}

- (void)showActivity:(bool)userInteractionEnabled
{
    [self showActivity:@"Waiting..." forSeconds:10 userEnabled:userInteractionEnabled];
}

- (void)removeActivity
{
    [self removeActivity:true];
}

- (void)removeActivity:(bool)animated
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:self];
    if (hud)
    {
        [hud hide:animated];
    }
}
@end
