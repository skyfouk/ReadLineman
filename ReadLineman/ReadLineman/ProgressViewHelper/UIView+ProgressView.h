//
//  UIView+ProgressView.h
//  GlacierFramework
//
//  Created by spring sky on 14-5-14.
//  Copyright (c) 2014年 spring sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (ProgressView)
- (void)showActivityForText:(NSString*) text;
- (void)showActivity;
- (void)showActivity:(bool)userInteractionEnabled;
- (void)removeActivity;
- (void)removeActivity:(bool)animated;
- (void)showActivityForFinish:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate;
- (void)showActivity:(NSString *)text forSeconds:(float)seconds userEnabled:(bool)enabled;
- (void)showActivityOnlyLabel:(NSString *)text forSeconds:(float)seconds;
@end
