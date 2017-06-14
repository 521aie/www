//
//    Data|10.h
//
//    Create by 瑞旺 宋 on 16/5/2017
//    Copyright © 2017. All rights reserved.
//

//    Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TDFWXKeywordsReplyType) {
    TDFWXKeywordsReplyTypeText = 1,
    TDFWXKeywordsReplyTypeCard = 2,
    TDFWXKeywordsReplyTypeCoupon = 3,
};

@interface TDFWXKeywordsRuleModel : NSObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * cardId;
@property (nonatomic, strong) NSString * cardName;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, strong) NSString * couponId;
@property (nonatomic, strong) NSString * couponName;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * ruleName;
@property (nonatomic, strong) NSString * text;
@end
