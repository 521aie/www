//
//  BigImageCell.h
//  RestApp
//
//  Created by zxh on 14-5-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageRemoveHandle.h"
#import "Base.h"

@interface BigImageCell : UITableViewCell<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UILabel *lblName;


@property (nonatomic, strong) id obj;
@property (nonatomic) id<ImageRemoveHandle> delegate;

- (IBAction)btnDelEvent:(id)sender;
@end
