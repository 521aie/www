//
//  EditItemRatio2.h
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditItemBase.h"
#import "EditItemChange.h"
#import "IEditItemRadioEvent.h"

@interface EditItemRadio2 : EditItemBase<EditItemChange>

@property (nonatomic, strong) id<IEditItemRadioEvent> delegate;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *imgOn;
@property (nonatomic, strong) IBOutlet UIImageView *imgOff;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;

- (void)initLabel:(NSString *)label withHit:(NSString *)hit;

- (void)initLabel:(NSString* )label withHit:(NSString *)hit delegate:(id<IEditItemRadioEvent>)delegate;

- (void)initLabel:(NSString *)label  withVal:(NSString *)data;

- (void)initShortData:(short)shortVal;

- (void)initData:(NSString *)data;

- (void)initHit:(NSString *)hit;

- (void)changeLabel:(NSString *)label withVal:(NSString *)data;

- (void)changeData:(NSString *)data;

- (IBAction)btnRatioClick:(id)sender;

- (NSString *)getStrVal;

- (BOOL)getVal;

@end
