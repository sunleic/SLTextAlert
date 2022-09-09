//
//  SLAlertViewController.h
//  自定义警告框
//
//  Created by sunlei on 09/07/2022.
//  Copyright (c) 2022 sunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLAlertControllerStyle) {
    SLAlertControllerStyleActionSheet = 0,
    SLAlertControllerStyleAlert
} API_AVAILABLE(ios(9.0));

typedef void(^SLAttributeClick)(NSRange range);

@interface SLAlertAttributeModel : NSObject

@property (nonatomic, strong) NSDictionary *attribute;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) SLAttributeClick attributeClickBlock;

@end

@interface SLAlertAction : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SLAlertAction *action))handler;

@end


@interface SLAlertViewController : UIViewController

@property (nonatomic, strong, readonly) NSArray<SLAlertAction *> *actions;
@property (nonatomic, assign, readonly) SLAlertControllerStyle preferredStyle;

@property (nonatomic, copy, readonly) NSString *titleString;
@property (nonatomic, copy, readonly) NSString *message;

// 设置标题对齐方式
@property (nonatomic, assign) NSTextAlignment titleAlignment;
// 设置消息内容对齐方式
@property (nonatomic, assign) NSTextAlignment messageAlignment;


/// 初始化弹框对象
/// @param title 标题
/// @param message 消息内容
/// @param preferredStyle 弹出框样式
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message alertStyle:(SLAlertControllerStyle)preferredStyle;

/// 添加动作
/// @param action 动作对象
- (void)addAction:(SLAlertAction *)action;

/// 给消息内容添加富文本属性
/// @param attributeModels 富文本属性对象
- (void)addMessageAttribute:(NSArray <SLAlertAttributeModel *>*)attributeModels;

@end
