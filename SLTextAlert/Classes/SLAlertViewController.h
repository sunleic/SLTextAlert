//
//  SLAlertViewController.h
//  自定义警告框
//
//  Created by fengye on 16/8/24.
//  Copyright © 2016年 fengye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAlertAttributeModel.h"

@interface SLAlertAction : NSObject

@property (nonatomic, readonly) NSString *title;

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SLAlertAction *action))handler;

@end


@interface SLAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<SLAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray <SLAlertAttributeModel *> *messageAttributeModels;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message messageAttribute:(NSArray <SLAlertAttributeModel *> *)attributeModels;
- (void)addAction:(SLAlertAction *)action;

@end
