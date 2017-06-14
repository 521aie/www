//
//  TDFDHListPanel.m
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "SystemUtil.h"
#import "DHheadItem.h"
#import "ObjectUtil.h"
#import "TDFDHListPanel.h"
#import "DHSearchBar.h"
#import "ViewFactory.h"
#import "INameValueItem.h"
#import "IImageDataItem.h"
#import "DHImageCellItem.h"
#import "NSString+Estimate.h"
#import "NSMutableArray+DeepCopy.h"

@implementation TDFDHListPanel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (void) initMainView
{
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.isSearchList = NO;
    [self addSubview:self.mainGrid];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    [self initUI];
}

-(void) initUI
{
    self.dhSearchBar = [DHSearchBar createDHSearchBar:self];
    self.isSearchMode = NO;
    self.dhSearchBar.hidden = YES;
    [self addSubview:self.dhSearchBar];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:76];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SystemUtil hideKeyboard];
}

- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    self.delegate = delegate;
    self.headChangeEvent = headChangeEventP;
    self.detailChangeEvent = detailChangeEventP;
    
    [self initNotification];
}

- (void)initData:(NSMutableArray*)headListTemp map:(NSMutableDictionary*)detailMapTemp
{
    self.headList = headListTemp;
    self.detailMap = detailMapTemp;
    [self.mainGrid reloadData];
}

#pragma 通知相关.
- (void)initNotification
{
    if ([NSString isNotBlank:self.detailChangeEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:self.detailChangeEvent object:nil];
    }
    if ([NSString isNotBlank:self.headChangeEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headChange:) name:self.headChangeEvent object:nil];
    }
}

- (void)dataChange:(NSNotification *) notification
{
    NSMutableDictionary* dic= notification.object;
    self.headList = [dic objectForKey:@"head_list"];
    self.detailMap = [dic objectForKey:@"detail_map"];
    self.backHeadList = [self.headList deepCopy];
    self.backDetailMap = [self.detailMap mutableCopy];
    
    [self.mainGrid reloadData];
}

-(void)headChange:(NSNotification *) notification
{
    self.headList = notification.object;
    self.backHeadList = [self.headList deepCopy];
    
    [self.mainGrid reloadData];
}

- (void)initWithKeyword:(NSString *)keyword
{
    self.isSearchList = YES;
    self.headList=[NSMutableArray array];
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray *details=nil;
    NSMutableArray* arr=nil;
    BOOL isExist=NO;
    for (id<INameValueItem> item in self.backHeadList) {
        details= [self.backDetailMap objectForKey:[item obtainItemId]];
        isExist=NO;
        BOOL nameCheck=NO;
        BOOL spellCheck=NO;
        BOOL codeCheck=NO;
        
        if ([ObjectUtil isNotEmpty:details]) {
            for (id<IImageDataItem> detail in details) {
                nameCheck=[[detail obtainItemName] rangeOfString:keyword].location!=NSNotFound;
                spellCheck=[[detail obtainItemSpell] rangeOfString:[keyword uppercaseString]].location!=NSNotFound;
                codeCheck=[[detail obtainItemCode] rangeOfString:keyword].location!=NSNotFound;
                
                if (nameCheck || spellCheck || codeCheck) {
                    if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]) {
                        arr=[self.detailMap objectForKey:[item obtainItemId]];
                    }else{
                    arr=[self.detailMap objectForKey:[detail obtainHeadId]];
                    }
                    if (!arr) {
                        arr=[NSMutableArray array];
                    } else {
                        if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]){
                             [self.detailMap removeObjectForKey:[item obtainItemId]];
                        }
                        else{
                        [self.detailMap removeObjectForKey:[detail obtainHeadId]];
                        }
                    }
                    [arr addObject:detail];
                    if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]){
                        [self.detailMap setObject:arr forKey:[item obtainItemId]];
                    }else{
                        [self.detailMap setObject:arr forKey:[detail obtainHeadId]];
                    }
                    isExist=YES;
                }
            }
        }
        if (isExist) {
            [self.headList addObject:item];
        }
    }
    [self.headerItems removeAllObjects];
    [self.mainGrid reloadData];
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DHImageCellItem *detailItem = (DHImageCellItem *)[tableView dequeueReusableCellWithIdentifier:DHImageCellItemCellIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"DHImageCellItem" owner:self options:nil].lastObject;
    }
    detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.headList.count > indexPath.section) {
        id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
            if ([ObjectUtil isNotEmpty:details]) {
                id<IImageDataItem> item=[details objectAtIndex: indexPath.row];
                [detailItem loadItem:item];
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.headList.count > indexPath.section) {
        id<INameValueItem> item = [self.headList objectAtIndex:indexPath.section];
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            if (details != nil) {
                id<IImageDataItem> item=[details objectAtIndex: indexPath.row];
                [self.delegate selectObj:item];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<INameValueItem> item = [self.headList objectAtIndex:section];
    if (item != nil) {
        NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
        if (details != nil) {
            return details.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [self.headerItems addObject:headItem];
    if (self.headList.count > section) {
        id<INameValueItem> item = [self.headList objectAtIndex:section];
        [headItem initWithData:item];
    }
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DH_IMAGE_CELL_ITEM_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DH_HEAD_HEIGHT;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    if (0 - point.y >= DH_SEARCHBAR_HEIGHT) {
        if (self.isSearchMode == NO) {
            [self.dhSearchBar requestFocus];
            [self showDHSearchBar];
        }
    }
}

- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.dhSearchBar requestFocus];
        [self showDHSearchBar];
    }
}

- (void)cancelSearchMode
{
    if (self.isSearchMode) {
        self.dhSearchBar.txtKey.text = @"";
        [self initData:self.backHeadList map:self.backDetailMap];
        [self hideDHSearchBar];
        [SystemUtil hideKeyboard];
    }
}

- (void)showDHSearchBar
{
    self.isSearchMode = YES;
    self.dhSearchBar.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect dhListFrame = self.mainGrid.frame;
    CGRect dhSearchFrame = self.dhSearchBar.frame;
    CGRect viewFrame = self.frame;
    self.dhSearchBar.frame = CGRectMake(dhSearchFrame.origin.x, 0 - dhSearchFrame.size.height, dhSearchFrame.size.width, dhSearchFrame.size.height);
    self.dhSearchBar.frame = CGRectMake(dhSearchFrame.origin.x, 0, dhSearchFrame.size.width, dhSearchFrame.size.height);
    
    self.mainGrid.frame = CGRectMake(dhListFrame.origin.x, 0, dhListFrame.size.width, viewFrame.size.height);
    self.mainGrid.frame = CGRectMake(dhListFrame.origin.x, dhSearchFrame.size.height, dhListFrame.size.width, viewFrame.size.height - dhSearchFrame.size.height);
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.dhSearchBar.hidden = YES;
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect dhListFrame = self.mainGrid.frame;
    CGRect dhSearchFrame = self.dhSearchBar.frame;
    CGRect viewFrame = self.frame;
    self.dhSearchBar.frame = CGRectMake(dhSearchFrame.origin.x, 0, dhSearchFrame.size.width, dhSearchFrame.size.height);
    self.dhSearchBar.frame = CGRectMake(dhSearchFrame.origin.x, 0 - dhSearchFrame.size.height, dhSearchFrame.size.width, dhSearchFrame.size.height);
    
    self.mainGrid.frame = CGRectMake(dhListFrame.origin.x, dhSearchFrame.size.height, dhListFrame.size.width, viewFrame.size.height - dhSearchFrame.size.height);
    self.mainGrid.frame = CGRectMake(dhListFrame.origin.x, 0, dhListFrame.size.width, viewFrame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

@end
