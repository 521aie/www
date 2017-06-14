//
//  SampleListView.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "Platform.h"
#import "ColumnHead.h"
#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "NameValueCell.h"
#import "SampleListView.h"
#import "NavigateTitle2.h"
#import "INameValueItem.h"
#import "FooterListView.h"

@implementation SampleListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    
}

-(void) showAddEvent
{
    [self.delegate showAddEvent:self.event];
}

-(void) showSortEvent
{
    [self.delegate sortEvent:@"sortinit" ids:nil];
}

-(void) showHelpEvent
{
    if([self.delegate respondsToSelector:@selector(showHelpEvent:)]) {
        [self.delegate showHelpEvent:self.event];
    }
}

-(void) initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:64];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.mainGrid.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT-64;
    self.mainGrid.frame = frame;
}

- (void)initDelegate:(id<ISampleListEvent>) delegateTemp event:(NSString*) eventTemp title:(NSString*) titleNameTemp foots:(NSArray*) arr
{
    self.delegate=delegateTemp;
    self.event=eventTemp;
    self.titleName=titleNameTemp;
    self.titleBox.lblTitle.text=titleNameTemp;
    self.title  = titleNameTemp;
    [self.footView initDelegate:self btnArrs:arr];
    self.footView.hidden=NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }

    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        cell.lblVal.hidden=tableView.editing;
        cell.img.hidden=tableView.editing;
        if (![item respondsToSelector:@selector(hiddenValueLabel)] || [item hiddenValueLabel] == NO) {
        
            cell.lblVal.text=[item obtainItemValue];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count) {
        [self.mainGrid reloadData];
    } else {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: row];
        [self.delegate showEditNVItemEvent:self.event withObj:item];
    }
}

@end
