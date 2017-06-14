//
//  TDFWXKeywordsAutoreplyItem.h
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"
#import "TDFWXKeywordsRuleModel.h"

@interface TDFWXKeywordsAutoreplyItem : DHTTableViewItem
@property (strong, nonatomic, readonly) NSString *displayedRuleName;
@property (strong, nonatomic, readonly) NSString *displayedKeywords;
@property (strong, nonatomic, readonly) NSString *displayedReplyTypeTitle;
@property (strong, nonatomic, readonly) UIImage *displayedReplyTypeImage;

- (instancetype)initWithRule:(TDFWXKeywordsRuleModel *)rule;
@end
