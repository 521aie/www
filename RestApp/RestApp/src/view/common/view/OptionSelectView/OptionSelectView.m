//
//  OptionSelectView.m
//  RestApp
//
//  Created by xueyu on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MemberSearchBar.h"
#import "NSString+Estimate.h"
#import "AppController.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "Platform.h"
#import "AlertBox.h"
#import "OptionSelectView.h"
#import "UIView+Sizes.h"
#import "StoresView.h"
#import "UIHelper.h"

@implementation OptionSelectView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    self.isSearch = NO;
}


- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
}

-(void)initMainView{
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.searchBar.delegateTmp = self;

}
- (void)initWithData:(NSString *)title list:(NSArray *)list Placeholder:(NSString *)placeholder

{
    [bgView removeFromSuperview];
    NSString *str;
    self.dataList = list;
    self.searchDatas = [NSMutableArray arrayWithArray:list];
    [self.searchBar setSearchBarPlaceholder:placeholder];
    if (self.event == 1) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        [self.searchBar.searchBtn setTitle:NSLocalizedString(@"查询", nil) forState:UIControlStateNormal];
        [self.titleBox initWithName:NSLocalizedString(@"请选择", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.titleBox.lblLeft.text = NSLocalizedString(@"关闭", nil);
        [self showDHSearchBar];
    }else{
        [self configLeftNavigationBar:@"ico_cancel.png" leftButtonName:NSLocalizedString(@"关闭", nil)];
        if ([self.target isKindOfClass:[StoresView class]]) {
            if ([self.editItem isKindOfClass:[NSString class]]) {
                str = (NSString *)self.editItem;
                if ([ObjectUtil isEmpty:list]) {
                    if ([str isEqualToString:@"brand"]) {
                        self.tipStr =  NSLocalizedString(@"连锁总部还未添加过品牌", nil);
                        [self initPlaceholderView];
                    }else if ([str isEqualToString:@"branch"]) {
                        self.tipStr =  NSLocalizedString(@"连锁总部还未添加过分公司", nil);
                        [self initPlaceholderView];
                    }
                }else{
                    
                }
            }}
        [self.titleBox initWithName:NSLocalizedString(@"请选择", nil) backImg:Head_ICON_BACK moreImg:nil];
        [self.searchBar.searchBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        self.mainGrid.frame = CGRectMake(0, 64,SCREEN_WIDTH , self.navigationController.view.frame.size.height-64);
        self.searchBar.frame = CGRectMake(0, -50, SCREEN_WIDTH, 40);
        [self hideDHSearchBar];
    }
    self.titleBox.lblTitle.text = title;
    [self.mainGrid reloadData];
}

#pragma mark navigate event
- (void)leftNavigationButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightNavigationButtonAction:(id)sender{
   
    if (self.event == 1) {
        [self finishSelectOptionItem];
    }
  
}

- (void)finishSelectOptionItem
{
    if ([ObjectUtil isNotNull:self.selectData]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.target selectOption:self.selectData editItem:self.editItem];
    } else {
        [AlertBox show:NSLocalizedString(@"请选择一个选项哦!", nil)];
    }
}


#pragma mark init data
+ (void)show:(NSString *)title list:(NSArray *)list  selectData:(id<INameItem>)data  target:(id<OptionSelectClient>)target editItem:(id)editItem  Placeholder:(NSString *)placeholder  event:(int)event isPresentMode:(BOOL)isPresentMode
{
    
  OptionSelectView *optionSelectView = [[OptionSelectView alloc]initWithNibName:@"OptionSelectView" bundle:nil];
//    optionSelectView.isPresentMode = isPresentMode;
    optionSelectView.event = event;
    optionSelectView.target = target;
    optionSelectView.selectData = data;
    optionSelectView.editItem = editItem;
    optionSelectView.searchBar.textField.text = nil;
//    if (isPresentMode) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:optionSelectView];
        optionSelectView.title = title;
        optionSelectView.needHideOldNavigationBar = YES;
        [[(UIViewController *)target navigationController] presentViewController:nav animated:YES completion:nil];
//    }else{
//      [optionSelectView showMoveIn];
//    }
    [optionSelectView initWithData:title list:list Placeholder:placeholder];

}



- (void)initPlaceholderView
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self. mainGrid.frame.size.height-60)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.mainGrid addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 50, 120, 120)];
    imageView.image=[UIImage imageNamed:@"img_nobill"];
    [bgView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH - 40, 120)];
    label.text=self.tipStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [bgView addSubview:label];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.searchDatas]?self.searchDatas.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.event == 1 ? OPTION_SELECT_ITEM_CELL_HEIGHT : OPTION_SELECT_ITEM_CELL44_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionSelectItemCell *optionSelectItemCell;
    if (self.event == 1) {
        optionSelectItemCell = [tableView dequeueReusableCellWithIdentifier:OptionSelectItemCellIdentifier];
        if (!optionSelectItemCell) {
            optionSelectItemCell = [[NSBundle mainBundle] loadNibNamed:@"OptionSelectItemCell" owner:self options:nil].lastObject;
        } 
    }else{
        optionSelectItemCell = [tableView dequeueReusableCellWithIdentifier:OptionSelectCell44Identifier];
        if (!optionSelectItemCell) {
            optionSelectItemCell = [[NSBundle mainBundle] loadNibNamed:@"OptionSelectItemCell44" owner:self options:nil].lastObject;
            
        }

    }
     NSString *str;
      id<INameItem> data = (id<INameItem>)[self.searchDatas objectAtIndex:indexPath.row];

    BOOL isSelected = NO;
    if (self.selectData != nil && [[data obtainItemId] isEqualToString:[self.selectData obtainItemId]]) {
        isSelected = YES;
        self.currentSelectItem = optionSelectItemCell;
    }
    if (self.isSearch == NO) {
        if (self.event != 1 ) {
            if ([self.target isKindOfClass:[StoresView class]]) {
                if ([self.editItem isKindOfClass:[NSString class]]) {
                    str = (NSString *)self.editItem;
                }if ([str isEqualToString:@"branch"]){
                    optionSelectItemCell.data = data;
                    optionSelectItemCell.type = 1;
                    optionSelectItemCell.nameLbl.text = [self getName:[[data obtainItemValue] intValue]-1 name:[data obtainItemName]];
                    
                    optionSelectItemCell.optionSelectView = self;
                    [optionSelectItemCell setSelect:isSelected];
                }else{
                    [optionSelectItemCell initWithData:data isSelected:isSelected target:self];
                }
            }else{
                [optionSelectItemCell initWithData:data isSelected:isSelected target:self];
            }
        }else{
            [optionSelectItemCell initWithData:data isSelected:isSelected target:self];
        }
    }else{
        [optionSelectItemCell initWithData:data isSelected:isSelected target:self];
    }
    return optionSelectItemCell;
}

-(NSString*) getName:(int)level name:(NSString*)name
{
    if (level==0) {
        return name;
    }
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    for (int i=0; i<level; i++) {
        [result appendString:NSLocalizedString(@"▪︎", nil)];
    }
    [result appendString:@""];
    [result appendString:name];
    return [NSString stringWithString:result];
}

- (void)selectItem:(OptionSelectItemCell *)item
{
    NSString *str;
    if (self.currentSelectItem!=nil) {
        [self.currentSelectItem setSelect:NO];
    }
    self.currentSelectItem = item;
    [self.currentSelectItem setSelect:YES];
    self.selectData = item.data;
    if (self.event == 1) {
        return;
    }else{
        if ([self.target isKindOfClass:[StoresView class]]) {
            if ([self.editItem isKindOfClass:[NSString class]]) {
                str = (NSString *)self.editItem;
                if ([str isEqualToString:@"brand"]) {
                    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确定要将这些门店归入[%@]品牌旗下吗？", nil),[item.data obtainItemName]]];
                }else   if ([str isEqualToString:@"branch"]) {
                    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确定要将这些门店归入[%@]分公司旗下吗？", nil),[item.data obtainItemName]]];
                }
            }
        }
    }

}

#pragma mark - UIActionSheetDelagate协议
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if(buttonIndex==0) {
            [self backFrontView];
        }
    }else{
        if(buttonIndex==0) {
            [self backFrontView];
        }
    }
}
    
- (void)backFrontView
{
    if ([ObjectUtil isNotNull:self.selectData]) {
//        if (self.isPresentMode) {
            [self dismissViewControllerAnimated:YES completion:nil];
//        }else{
//            [self hideMoveOut];
//        }
        [self.target selectOption:self.selectData editItem:self.editItem];
    } else {
        [AlertBox show:NSLocalizedString(@"请选择一个选项哦!", nil)];
    }
}

#pragma mark  搜索查询
-(void)searchBarEventClick:(NSString *)keyWord sender:(id)sender{
    self.isSearch = YES;
    UIButton *btn;
    if ([sender isKindOfClass:[UIButton class]]) {
        btn = (UIButton *)sender;
        if (btn.tag == 100) {
            if (self.event != 1) {
                self.isSearch = NO;
                [self cancelSearchMode];
                self.searchDatas = [self.dataList mutableCopy];
                [self.mainGrid reloadData];
                return;
            }
        }
    }
        if ([NSString isBlank:keyWord]) {
            self.searchDatas = [self.dataList mutableCopy];
            [self.mainGrid reloadData];
            return;
        }
        [self.searchDatas removeAllObjects];
        for (id<INameItem>data in self.dataList) {
            if ([[data obtainItemName] rangeOfString:keyWord].location != NSNotFound) {
                [self.searchDatas addObject:data];
            }
        }
        [self.mainGrid reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.event != 1) {
        CGPoint point = scrollView.contentOffset;
        if (0 - point.y >= 44) {
            if (self.isSearchMode == NO) {
                [self.searchBar.textField becomeFirstResponder];
                [self showDHSearchBar];
            }
        }
    }
}

- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.searchBar.textField becomeFirstResponder];
        [self showDHSearchBar];
    }
}

- (void)cancelSearchMode
{
    if (self.isSearchMode) {
        self.searchBar.textField.text = @"";
        [self hideDHSearchBar];
        [SystemUtil hideKeyboard];
    }
}


- (void)showDHSearchBar
{
    self.isSearchMode = YES;
    self.searchBar.hidden = NO;
    self.searchBar.frame = CGRectMake(0,-50,SCREEN_WIDTH,40);
    self.mainGrid.frame = CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchBar.frame = CGRectMake(0,64,SCREEN_WIDTH,40);
    self.mainGrid.frame = CGRectMake(0,108,SCREEN_WIDTH,SCREEN_HEIGHT-108);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.searchBar.hidden = YES;
    self.searchBar.frame = CGRectMake(0,64,SCREEN_WIDTH,40);
    self.mainGrid.frame = CGRectMake(0,108,SCREEN_WIDTH,SCREEN_HEIGHT-108);
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchBar.frame = CGRectMake(0,-50,SCREEN_WIDTH,40);
    self.mainGrid.frame = CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
@end
