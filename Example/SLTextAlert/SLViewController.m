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
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alert2Btns:(id)sender {
    SLAlertViewController *alertVC = [SLAlertViewController alertControllerWithTitle:@"温馨提示" message:@"人脸采集失败，是否重新采集" alertStyle:SLAlertControllerStyleAlert];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    SLAlertAction *cancel = [SLAlertAction actionWithTitle:@"取消" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:cancel];

    SLAlertAction *OK = [SLAlertAction actionWithTitle:@"确定" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:OK];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)alert3Btns:(id)sender {
    SLAlertViewController *alertVC = [SLAlertViewController alertControllerWithTitle:@"温馨提示" message:@"人脸采集失败，是否重新采集" alertStyle:(SLAlertControllerStyleAlert)];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    SLAlertAction *action1 = [SLAlertAction actionWithTitle:@"取消" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:action1];
    
    SLAlertAction *action2 = [SLAlertAction actionWithTitle:@"确定" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:action2];
    
    SLAlertAction *action3 = [SLAlertAction actionWithTitle:@"确定1" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:action3];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)attributeStringAction:(id)sender {
    
    NSString *message = @"电话：4008800114\n座机：010-82760152\n邮箱：sfrz_iam@cnpc.com.cn";
    SLAlertViewController *alertVC = [SLAlertViewController alertControllerWithTitle:@"温馨提示" message:message alertStyle:SLAlertControllerStyleAlert];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    SLAlertAttributeModel *model = [SLAlertAttributeModel new];
    model.attribute = @{NSLinkAttributeName:[NSURL URLWithString:@"tel://4008800114"], NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    model.range = [message rangeOfString:@"4008800114"];
    
    SLAlertAttributeModel *model1 = [SLAlertAttributeModel new];
    model1.attribute = @{NSLinkAttributeName:[NSURL URLWithString:@"tel://010-82760152"], NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    model1.range = [message rangeOfString:@"010-82760152"];
    [alertVC addMessageAttribute:@[model, model1]];

    SLAlertAction *cancel = [SLAlertAction actionWithTitle:@"确定" handler:^(SLAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)actionSheet:(id)sender {
    SLAlertViewController *alertVC = [SLAlertViewController alertControllerWithTitle:@"温馨提示" message:@"人脸采集失败，是否重新采集" alertStyle:SLAlertControllerStyleActionSheet];
//    alertVC.messageAlignment = NSTextAlignmentCenter;
    
    SLAlertAction *action1 = [SLAlertAction actionWithTitle:@"确定" handler:^(SLAlertAction *action) {
    }];
    [alertVC addAction:action1];
    
    SLAlertAction *action2 = [SLAlertAction actionWithTitle:@"取消" handler:^(SLAlertAction *action) {
    }];
    action2.enabled = NO;
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)origin_alert:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"展示内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    action.enabled = NO;
    [alertVC addAction:action];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定1" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVC addAction:action1];

//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定1" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertVC addAction:action2];

    [self presentViewController:alertVC animated:YES completion:^{
    }];
}


- (IBAction)origin_actionSheet:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"展示内容" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    action.enabled = NO;
    [alertVC addAction:action];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定1" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVC addAction:action1];

//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定1" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertVC addAction:action2];

    [self presentViewController:alertVC animated:YES completion:^{
    }];
}

@end
