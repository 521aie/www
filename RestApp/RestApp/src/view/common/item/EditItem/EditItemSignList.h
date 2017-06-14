//
//  EditItemList.h
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "EditItemChange.h"
#import "IEditItemListEvent.h"

@interface EditItemSignList : EditItemBase<EditItemChange>
{    
    NSArray *signArray;
}

@property (nonatomic, strong) id<IEditItemListEvent> delegate;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UITextField *lblVal;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;

@property (nonatomic, strong) IBOutlet UIImageView *imgMore;
@property (nonatomic, strong) IBOutlet UIImageView *imgLevel1;
@property (nonatomic, strong) IBOutlet UIImageView *imgLevel2;
@property (nonatomic, strong) IBOutlet UIImageView *imgLevel3;
@property (nonatomic, strong) IBOutlet UIImageView *imgLevel4;
@property (nonatomic, strong) IBOutlet UIImageView *imgLevel5;
@property (nonatomic, strong) IBOutlet UIButton *btn;
@property (nonatomic, strong) IBOutlet UIView *line;

- (IBAction)btnMoreClick:(id)sender;

- (void)initHit:(NSString *)_hit;

- (void)initLabel:(NSString*)label withHit:(NSString *)hit signImg:(NSString *)signImgName delegate:(id<IEditItemListEvent>) delegate;

- (void)initLabel:(NSString*)label withHit:(NSString *)hit signImg:(NSString *)signImgName isrequest:(BOOL)req delegate:(id<IEditItemListEvent>) delegate;

- (void)initRightLabel:(NSString*)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>) delegate;

//fillMode时使用.
- (void) initLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString*)data;

- (void) initData:(NSString *)dataLabel withVal:(NSString *)data;

//Change时使用.
- (void) changeLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString *)data;

- (void) changeData:(NSString *)dataLabel withVal:(NSString *)data;

//得到具体值.
-(NSString*) getStrVal;

@end
