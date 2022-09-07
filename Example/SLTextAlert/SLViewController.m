//
//  SLViewController.m
//  SLTextAlert
//
//  Created by sunlei on 09/07/2022.
//  Copyright (c) 2022 sunlei. All rights reserved.
//

#import "SLViewController.h"
#import "SLAlertViewController.h"

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertView:(id)sender {
    NSString *title = @"温馨提示";
    NSString *message = @"人脸采集失败，是否重新采集";
    [self showRealNameAlertViewWithTitle:title message:message buttonClick:^(SLAlertAction *action) {
    } cancelButtonClick:^(SLAlertAction *action) {
    }];
}

- (void)showRealNameAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonClick:(void(^)(SLAlertAction *action))btnClickBlock cancelButtonClick:(void(^)(SLAlertAction *action))cancelBtnClickBlock {
    
    SLAlertViewController *alertVC = [SLAlertViewController alertControllerWithTitle:title message:message messageAttribute:nil];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    SLAlertAction *cancel = [SLAlertAction actionWithTitle:@"取消" handler:^(SLAlertAction *action) {
        if (cancelBtnClickBlock) {
            cancelBtnClickBlock(action);
        }
    }];
    [alertVC addAction:cancel];
    
    SLAlertAction *OK = [SLAlertAction actionWithTitle:@"确定" handler:^(SLAlertAction *action) {
        if (btnClickBlock) {
            btnClickBlock(action);
        }
    }];
    [alertVC addAction:OK];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

@end
