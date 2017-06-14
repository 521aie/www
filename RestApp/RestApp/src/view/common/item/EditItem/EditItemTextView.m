//
//  ShopCodeView.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemTextView.h"
#import "NSString+Estimate.h"

@implementation EditItemTextView

- (void)awakeFromNib
{
    self.delegate = self;
    
    float left = 3,top =-8,hegiht = 50;
    self.placeholderLabel = [[UILabel alloc] initWithFrame:
                             CGRectMake(left, top ,CGRectGetWidth(self.frame)-2*left, hegiht)];
    self.placeholderLabel.font = [UIFont systemFontOfSize:13];
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.placeholderLabel];
}

- (void)initPlaceHolder:(NSString *)placeHolder
{
    self.placeholder = placeHolder;
    self.placeholderLabel.text = placeHolder;
}

- (void)initData:(NSString *)data
{
    self.text = data;
    if ([NSString isNotBlank:self.text]) {
        self.placeholderLabel.hidden = YES;
    } else if ([NSString isNotBlank:self.placeholder]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([NSString isNotBlank:self.text]) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([NSString isBlank:self.placeholder]) {
        self.placeholderLabel.hidden = YES;
    }
    if ([NSString isNotBlank:self.text]) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end

