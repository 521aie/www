//
//  ZmTableCell.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
#import "ISampleListEvent.h"
#import "EditItemList.h"
typedef enum
{
    ITEM_MODE_NO=0,       //隐藏.
    ITEM_MODE_DEL=1,      //删除模式
    ITEM_MODE_EDIT=2      //编辑模式.
    
}ITEM_SHOW_MODE;

@interface ZmTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EditItemList *edititemList;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UIImageView *imgAct;
@property (nonatomic, strong) IBOutlet UIButton *btnAct;

@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> obj;
@property (nonatomic, strong) NSString* event;
@property (nonatomic) NSInteger itemMode;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event itemMode:(NSInteger)itemMode;

-(IBAction) btnDelClick:(id)sender;

@end
