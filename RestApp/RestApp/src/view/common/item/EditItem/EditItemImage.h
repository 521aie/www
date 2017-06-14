//
//  EditItemImage.h
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemImageEvent.h"
@interface EditItemImage : EditItemBase<UIActionSheetDelegate>

@property (nonatomic, strong)  UIView *view;
@property (nonatomic, strong)  UIView *borderView;
@property (nonatomic, strong)  UILabel *lblName;
@property (nonatomic, strong)  UIButton *btnAdd;
@property (nonatomic, strong)  UIButton *btnDel;
@property (nonatomic, strong)  UIImageView *imgAdd;
@property (nonatomic, strong)  UILabel *lblAdd;
@property (nonatomic, strong)  UIImageView *img;
@property (nonatomic, strong)  UIImageView *imgDel;
@property (nonatomic, strong)  UITextView *lblDetail;
@property (nonatomic, strong)  UIView *line;
@property (nonatomic, strong) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic, assign) BOOL changed;

- (void)initLabel:(NSString*)label withHit:(NSString *)hit delegate:(id<IEditItemImageEvent>)delegate;

- (void)initView:(NSString *)filePath path:(NSString *)path;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (NSString *)getImageFilePath;
@end
