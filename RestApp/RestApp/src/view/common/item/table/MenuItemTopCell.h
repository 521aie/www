//
//  MenuItemTopCell.h
//  RestApp
//
//  Created by 果汁 on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleMenuVO.h"
#import "DHListSelectHandle.h"

@interface MenuItemTopCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *img;
@property (strong, nonatomic)  UILabel *lblName;
@property (strong, nonatomic)  UIView *imgView;
@property (strong, nonatomic)  UILabel *lblDetail;
@property (strong, nonatomic)  UILabel *lblImgName;
@property (strong, nonatomic)  UILabel *lblAccount;
@property (strong, nonatomic)  UIButton *btnMember;
@property (strong, nonatomic)  UILabel *lblOriginPrice;
@property (strong, nonatomic)  UILabel *lblRedLine;


@property (strong,nonatomic) SampleMenuVO* item;
@property (nonatomic,strong) id<DHListSelectHandle> delegate;
@property (strong, nonatomic)  UIImageView *lblIsChain;

+ (id)getInstance;
- (void)loadItem:(SampleMenuVO*)data;
- (void)loadItem:(SampleMenuVO*)data delegate:(id<DHListSelectHandle>) handle;
@end
