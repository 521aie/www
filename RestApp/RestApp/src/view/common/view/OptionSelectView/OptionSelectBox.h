//
//  OptionSelectBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "INameItem.h"
#import "JsonHelper.h"
#import "EditItemBase.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "OptionSelectItemCell.h"
#import "PopupBoxViewController.h"

@protocol OptionSelectClient <NSObject>

- (BOOL)selectOption:(id<INameItem>)data editItem:(id)editItem;

@end

@class AppController;
@interface OptionSelectBox : PopupBoxViewController<INavigateEvent, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) id<INameItem> selectData;
@property (nonatomic, strong) id<OptionSelectClient> target;
@property (nonatomic, strong) OptionSelectItemCell *currentSelectItem;
@property (nonatomic, strong) id editItem;

+ (void)initOptionSelectBox:(UIViewController *)appController;

- (void)selectItem:(OptionSelectItemCell *)item;

+ (void)show:(NSString *)title list:(NSArray *)list target:(id<OptionSelectClient>)target editItem:(id)editItem;

@end
