//
//  ZeroCell.h
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameValueItemVO.h"

@interface ZeroCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) NameValueItemVO* obj;
@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblVarRightConstraint;

-(void) loadObj:(NameValueItemVO*)objTemp tag:(NSInteger)tag;

@end
