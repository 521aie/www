//
//  EditItemTextView.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditItemTextView : UITextView<UITextViewDelegate>

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UILabel *placeholderLabel;

- (void)initPlaceHolder:(NSString *)placeHolder;

- (void)initData:(NSString *)data;

@end

