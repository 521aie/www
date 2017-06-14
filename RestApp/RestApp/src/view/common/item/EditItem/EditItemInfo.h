//
//  EditItemText.h
//  RestApp
//
//  Created by zxh on 14-4-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditItemInfo : UIView
{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblInfo;
@property (nonatomic, strong) IBOutlet UIView *line;

- (void)initData:(NSString*)data;

@end
