//
//  OptionSelectBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSString+Estimate.h"
#import "OptionSelectBox.h"
#import "AppController.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "Platform.h"
#import "AlertBox.h"

static OptionSelectBox *optionSelectBox;

@implementation OptionSelectBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    
    self.view.hidden = YES;
}

+ (void)initOptionSelectBox:(UIViewController *)appController
{
    optionSelectBox = (OptionSelectBox *)[appController.view viewWithTag:TAG_OPTIONSELECTBOX];
    if(!optionSelectBox) {
        optionSelectBox = [[OptionSelectBox alloc]initWithNibName:@"OptionSelectBox"bundle:nil];
        optionSelectBox.view.tag = TAG_OPTIONSELECTBOX;
        [appController.view addSubview:optionSelectBox.view];
    }
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"请选择", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblLeft.text = NSLocalizedString(@"关闭", nil);
}

- (void)initWithData:(NSString *)title list:(NSArray *)list
{
    self.dataList = list;
    self.selectData = nil;
    [self.titleBox setTitle:title];
    [self.mainGrid reloadData];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event == DIRECT_LEFT) {
        [self hideMoveOut];
    } else if (event == DIRECT_RIGHT) {
        [self finishSelectOptionItem];
    }
}

- (void)finishSelectOptionItem
{
    if ([ObjectUtil isNotNull:self.selectData]) {
        [self hideMoveOut];
        [self.target selectOption:self.selectData editItem:self.editItem];
    } else {
        [AlertBox show:NSLocalizedString(@"请选择一个选项哦!", nil)];
    }
}

+ (void)show:(NSString *)title list:(NSArray *)list target:(id<OptionSelectClient>)target editItem:(id)editItem
{
    optionSelectBox.target = target;
    optionSelectBox.editItem = editItem;
    [optionSelectBox initWithData:title list:list];
    [optionSelectBox showMoveIn];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.dataList]?self.dataList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OPTION_SELECT_ITEM_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionSelectItemCell *optionSelectItemCell = [tableView dequeueReusableCellWithIdentifier:OptionSelectItemCellIdentifier];
    if (!optionSelectItemCell) {
        optionSelectItemCell = [[NSBundle mainBundle] loadNibNamed:@"OptionSelectItemCell" owner:self options:nil].lastObject;
    }
    
    id<INameItem> data = (id<INameItem>)[self.dataList objectAtIndex:indexPath.row];
    BOOL isSelected = NO;
    if (self.selectData != nil && [[data obtainItemId] isEqualToString:[self.selectData obtainItemId]]) {
        isSelected = YES;
        self.currentSelectItem = optionSelectItemCell;
    }
    
    [optionSelectItemCell initWithData:data isSelected:isSelected delegate:self];
    return optionSelectItemCell;
}

- (void)selectItem:(OptionSelectItemCell *)item
{
    if (self.currentSelectItem!=nil) {
        [self.currentSelectItem setSelect:NO];
    }
    self.currentSelectItem = item;
    [self.currentSelectItem setSelect:YES];
    self.selectData = item.data;
}

@end
