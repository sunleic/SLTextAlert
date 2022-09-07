//
//  SLAlertAttributeModel.h
//  sacurity
//
//  Created by sunlei on 2022/9/6.
//  Copyright © 2022 zx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAlertAttributeModel : NSObject

@property (nonatomic, strong) NSDictionary *attribute;
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
