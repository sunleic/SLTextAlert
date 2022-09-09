//
//  SLAlertViewController.m
//  自定义警告框
//
//  Created by sunlei on 09/07/2022.
//  Copyright (c) 2022 sunlei. All rights reserved.
//

#import "SLAlertViewController.h"

//#define kDefaultButtonColor [UIColor colorWithRed:0.09 green:0.52 blue:1.00 alpha:1.00]
//#define kDefaultTextColor [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1]
//#define kTitleFontSize 18
//#define kMessageFontSize 16

@implementation SLAlertAttributeModel

@end

@interface SLHighLightButton : UIButton

@property (strong, nonatomic) UIColor *highlightedColor;

@end

@implementation SLHighLightButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.highlightedColor;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = nil;
        });
    }
}

@end

@interface SLAlertAction ()

@property (copy, nonatomic) void(^actionHandler)(SLAlertAction *action);

@end

@implementation SLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SLAlertAction *action))handler {
    SLAlertAction *instance = [SLAlertAction new];
    instance -> _title = title;
    instance.enabled = YES;
    instance.actionHandler = handler;
    return instance;
}

@end


@interface SLAlertViewController ()<UITextViewDelegate> {
    UIView *_shadowView;
    UIView *_contentView;
    
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    UIColor *_titleColor;
    CGFloat _titleFontSize;
    UIColor *_messageColor;
    CGFloat _messageFontSize;
    
    UIColor *_buttonColor;
    CGFloat _buttonFontSize;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *messageTV;
@property (nonatomic, strong) UIView *separatorLine;
@property (strong, nonatomic) NSMutableArray *mutableActions;
@property (nonatomic, strong) UIStackView *buttonStack;

@property (nonatomic, strong) NSMutableArray <SLAlertAttributeModel *> *messageAttributeModels;

@end

@implementation SLAlertViewController

#pragma mark -- public

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message alertStyle:(SLAlertControllerStyle)preferredStyle {
    
    SLAlertViewController *instance = [SLAlertViewController new];
    instance->_titleString = title;
    instance->_message = message;
    instance->_preferredStyle = preferredStyle;
    
    //
    CGFloat scaleWidth = 0.96;
    if (preferredStyle == SLAlertControllerStyleAlert) {
        scaleWidth = 0.75;
    }
    instance->_contentViewWidth = [UIScreen mainScreen].bounds.size.width * scaleWidth;
    
    return instance;
}

// 添加动作
- (void)addAction:(SLAlertAction *)action {
    [self.mutableActions addObject:action];
}

// 添加消息的富文本属性
- (void)addMessageAttribute:(NSArray <SLAlertAttributeModel *>*)attributeModels {
    [self.messageAttributeModels addObjectsFromArray:attributeModels];
}

#pragma mark -- VC生命周期方法

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

// 默认设置
- (void)defaultSetting {
    _contentMargin = UIEdgeInsetsMake(20, 20, 0, 20);
    _contentViewWidth = [UIScreen mainScreen].bounds.size.width * 0.75;
    _buttonHeight = 50;
    
    _titleColor = [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1];
    _titleFontSize = 20;
    
    _messageColor = [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1];
    _messageFontSize = 18;
    
    _buttonColor = [UIColor colorWithRed:0.09 green:0.52 blue:1.00 alpha:1.00];
    _buttonFontSize = 18;
    
    _titleAlignment = NSTextAlignmentCenter;
    _messageAlignment = NSTextAlignmentCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatContainerView];
    [self creatAllButtons];
    
    self.titleLabel.text = self.titleString;
    self.messageTV.attributedText = [self getMessageAttributeStringWithPlainString:self.message];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //更新标题的frame
    [self updateTitleLabelFrame];
    
    // 更新message的frame
    [self updateMessageTVFrame];
    
    //更新按钮的frame
    [self updateAllButtonsFrame];
    
    //更新分割线的frame
    [self updateAllSeparatorLineFrame];
    
    //更新弹出框的frame
    [self updateShadowAndContentViewFrame];
    
    //显示弹出动画
    [self showAppearAnimation];
}

#pragma mark -- 生产富文本

// 内容富文本
- (NSMutableAttributedString *)getMessageAttributeStringWithPlainString:(NSString *)message {
    // 设置属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.messageAlignment;
    // 设置行间距
    paragraphStyle.paragraphSpacing = 2; // 段落间距
    paragraphStyle.lineSpacing = 5;      // 行间距
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName:_messageColor,
        NSFontAttributeName:[UIFont systemFontOfSize:_messageFontSize],
        NSParagraphStyleAttributeName:paragraphStyle,
    };
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:message attributes:attributes];
    
    for (SLAlertAttributeModel *model in self.messageAttributeModels) {
        [attrStr addAttributes:model.attribute range:model.range];
    }
    
    return attrStr;
}

#pragma mark - 创建内部视图

// 阴影层
- (void)creatContainerView {
    // 阴影层
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewWidth, 0)];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    _shadowView.layer.shadowRadius = 10;
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 8);
    
    [self.view addSubview:_shadowView];
    
    // 内容容器层
    _contentView = [[UIView alloc] initWithFrame:_shadowView.bounds];
    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.layer.cornerRadius = 10;
    _contentView.clipsToBounds = YES;
    
    [_shadowView addSubview:_contentView];
}

// 创建所有按钮
- (void)creatAllButtons {
    
    NSMutableArray *btnArr = @[].mutableCopy;
    for (int i = 0; i < self.actions.count; i++) {
        
        SLAlertAction *action = self.actions[i];
        
        SLHighLightButton *btn = [SLHighLightButton new];
        btn.enabled = action.enabled;
        btn.tag = 10 + i;
        btn.backgroundColor = [UIColor whiteColor];
        
        if (action.enabled) {
            btn.highlightedColor = [UIColor colorWithWhite:0.97 alpha:1];
            [btn setTitleColor:_buttonColor forState:UIControlStateNormal];
        } else {
            btn.highlightedColor = [UIColor clearColor];
            UIColor *disableColor = [UIColor colorWithRed:0.59 green:0.56 blue:0.53 alpha:1.00];
            [btn setTitleColor:disableColor forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:_buttonFontSize];
        
        [btn setTitle:action.title forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnArr addObject:btn];
    }
    
    _buttonStack = [[UIStackView alloc] initWithArrangedSubviews:btnArr];
    _buttonStack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    _buttonStack.spacing = 0.5f;
    [_contentView addSubview:_buttonStack];
}

#pragma mark -- 更新视图布局

- (void)updateTitleLabelFrame {
    
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    CGFloat titleHeight = 0.0;
    if (self.titleString.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        titleHeight = size.height;
        self.titleLabel.frame = CGRectMake(_contentMargin.left, _contentMargin.top, labelWidth, size.height);
    }
}

- (void)updateMessageTVFrame {
    
    CGFloat messageTVWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    // 更新message的frame
    CGFloat messageHeight = 0.0;
    CGFloat messageY = self.titleString.length ? CGRectGetMaxY(_titleLabel.frame) + 5 : _contentMargin.top;
    if (self.message.length) {
        CGSize size = [self.messageTV sizeThatFits:CGSizeMake(messageTVWidth, CGFLOAT_MAX)];
        messageHeight = size.height;
        self.messageTV.frame = CGRectMake(_contentMargin.left, messageY, messageTVWidth, size.height);
    }
}

- (void)updateAllButtonsFrame {
    
    if (!self.actions.count) {
        return;
    }
    
    CGFloat firstButtonY = [self getActionButtonY];
    if ((self.preferredStyle == SLAlertControllerStyleAlert && self.actions.count > 2) || self.preferredStyle == SLAlertControllerStyleActionSheet) {
        _buttonStack.frame = CGRectMake(0, firstButtonY, _contentViewWidth, _buttonHeight * self.actions.count);
        _buttonStack.axis = UILayoutConstraintAxisVertical;
    } else {
        _buttonStack.frame = CGRectMake(0, firstButtonY, _contentViewWidth, _buttonHeight);
        _buttonStack.axis = UILayoutConstraintAxisHorizontal;
    }
    _buttonStack.alignment = UIStackViewAlignmentFill;
    _buttonStack.distribution = UIStackViewDistributionFillEqually;
}

- (void)updateAllSeparatorLineFrame {
    self.separatorLine.hidden = self.actions.count == 0;
    self.separatorLine.frame = CGRectMake(0, CGRectGetMinY(self.buttonStack.frame) - 0.5, _contentViewWidth, 0.5);
}

- (void)updateShadowAndContentViewFrame {
    
    CGFloat firstButtonY = [self getActionButtonY];
    
    CGFloat allButtonHeight;
    if (!self.actions.count) {
        allButtonHeight = 0;
    } else {
        if (self.preferredStyle == SLAlertControllerStyleAlert) {
            if (self.actions.count < 3) {
                allButtonHeight = _buttonHeight;
            } else {
                allButtonHeight = _buttonHeight * self.actions.count;
            }
        } else {
            allButtonHeight = _buttonHeight * self.actions.count;
        }
    }
    
    //更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = firstButtonY + allButtonHeight;
    _shadowView.frame = frame;
    
    if (self.preferredStyle == SLAlertControllerStyleAlert) {
        _shadowView.center = self.view.center;
    } else {
        _shadowView.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height + _shadowView.frame.size.height/2.f);
    }
    _contentView.frame = _shadowView.bounds;
}

- (CGFloat)getActionButtonY {
    
    CGFloat actionButtonY = 0.0;
    if (self.titleString.length) {
        actionButtonY = CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.message.length) {
        actionButtonY = CGRectGetMaxY(self.messageTV.frame);
    }
    actionButtonY += actionButtonY > 0 ? 15 : 0;
    
    return actionButtonY;
}

#pragma mark -- 按钮事件响应

- (void)didClickButton:(UIButton *)sender {
    SLAlertAction *action = self.actions[sender.tag - 10];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    
    [self showDisappearAnimation];
}

#pragma mark -- show && hide actions

- (void)showAppearAnimation {
    if (self.preferredStyle == SLAlertControllerStyleAlert) {
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_shadowView.transform = CGAffineTransformIdentity;
            self->_shadowView.alpha = 1;
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
            if (@available(iOS 11.0, *)) {
                self->_shadowView.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height - self->_shadowView.frame.size.height/2.f - self.view.safeAreaInsets.bottom);
            } else {
                // Fallback on earlier versions
                self->_shadowView.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height - self->_shadowView.frame.size.height/2.f - 20);
            }

        } completion:nil];
    }
}

- (void)showDisappearAnimation {
    if (self.preferredStyle == SLAlertControllerStyleAlert) {
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *subView in self->_contentView.subviews) {
                if ([subView isKindOfClass:[UITextView class]]) {
                    subView.hidden = YES;
                }
                subView.alpha = 0;
            }
            self->_contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    } else {
        
        [UIView animateWithDuration:0.25 animations:^{
            self->_shadowView.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height + self->_shadowView.frame.size.height/2.f);
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

#pragma mark -- getter

- (NSString *)title {
    return [super title];
}

- (NSMutableArray *)mutableActions {
    if (!_mutableActions) {
        _mutableActions = [NSMutableArray array];
    }
    return _mutableActions;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = _titleColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:_titleFontSize];
        _titleLabel.text = self.titleString;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITextView *)messageTV {
    if (!_messageTV) {
        _messageTV = [UITextView new];
        _messageTV.editable = NO;
        _messageTV.scrollEnabled = NO;
        _messageTV.textColor = _messageColor;
        _messageTV.font = [UIFont systemFontOfSize:_messageFontSize];
        _messageTV.delegate = self;
        _messageTV.showsVerticalScrollIndicator = NO;
        _messageTV.showsHorizontalScrollIndicator = NO;
        [_contentView addSubview:_messageTV];
    }
    return _messageTV;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        [_contentView addSubview:_separatorLine];
    }
    return _separatorLine;
}

- (NSArray<SLAlertAction *> *)actions {
    return [NSArray arrayWithArray:self.mutableActions];
}

- (NSMutableArray<SLAlertAttributeModel *> *)messageAttributeModels {
    if (!_messageAttributeModels) {
        _messageAttributeModels = [NSMutableArray arrayWithCapacity:0];
    }
    return _messageAttributeModels;
}

#pragma mark -- setters

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageTV.attributedText = [self getMessageAttributeStringWithPlainString:message];;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleAlignment = titleAlignment;
    _titleLabel.textAlignment = titleAlignment;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    _messageTV.textAlignment = messageAlignment;
}

#pragma mark -- textView delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    [self showDisappearAnimation];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange API_AVAILABLE(ios(9.0)) {
    [self showDisappearAnimation];
    
    return YES;
}

@end
