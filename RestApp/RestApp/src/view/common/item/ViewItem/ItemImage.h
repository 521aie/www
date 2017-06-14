//
//  ItemImage.h
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"
#import "ImageRemoveHandle.h"

@interface ItemImage : UIView<ItemBase,UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIImageView *imgBtn;
@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic) NSString* filePath;

@property (nonatomic) id<ImageRemoveHandle> delegate;
@property (nonatomic, strong) NSString* objId;

- (void)initView:(NSString *)filePath;
-(IBAction)onDelClick:(id)sender;

@end
