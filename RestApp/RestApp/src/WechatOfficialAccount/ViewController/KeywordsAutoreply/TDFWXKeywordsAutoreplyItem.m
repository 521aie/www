//
//  TDFWXKeywordsAutoreplyItem.m
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXKeywordsAutoreplyItem.h"

@interface TDFWXKeywordsAutoreplyItem()
@property (strong, nonatomic) TDFWXKeywordsRuleModel *rule;
@end

@implementation TDFWXKeywordsAutoreplyItem
- (instancetype)initWithRule:(TDFWXKeywordsRuleModel *)rule {
    if (self = [super init]) {
        self.rule = rule;
    }
    
    return self;
}

- (NSString *)displayedKeywords {
    return self.rule.keywords;
}

- (NSString *)displayedRuleName {
    return self.rule.ruleName;
}

- (NSString *)displayedReplyTypeTitle {
    return self.rule.text ?: self.rule.cardName ?: self.rule.couponName;
}

- (UIImage *)displayedReplyTypeImage {
    switch (self.rule.contentType) {
        case TDFWXKeywordsReplyTypeCard:
            return [UIImage imageNamed:@"wx_card"];
        case TDFWXKeywordsReplyTypeText:
            return [UIImage imageNamed:@"wx_pure_text"];
        case TDFWXKeywordsReplyTypeCoupon:
            return [UIImage imageNamed:@"wx_card_sample"];
        default:
            return nil;
    }
}
@end
