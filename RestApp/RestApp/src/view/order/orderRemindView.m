//
//  orderRemindView.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderRemindView.h"
#import "SmartOrderModel.h"
#import "ViewFactory.h"
#import "HeadNameItem.h"
#import "ServiceFactory.h"
#import "FuctionCustomAlertView.h"
#import "OrderRemindData.h"
#import "SystemUtil.h"
#import "orderRecommendView.h"
#import "JSONKit.h"
#import "HelpDialog.h"


@implementation orderRemindView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        model =controller;
        self.headArry =[[NSMutableArray alloc]init];
        self.dataArry =[[NSMutableArray alloc]init];
        self.oldarry =[[NSMutableDictionary alloc]init];
        service =[ServiceFactory Instance].orderService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initView];
    [self preData];
}

-(void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"提醒与推荐语设置", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"提醒与推荐语设置", nil);
}

-(void)initNotifation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
}
-(void) keyboardShown:(NSNotification*) notification {
    _initialTVHeight = _tabview.frame.size.height;
    
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    CGRect tvFrame = _tabview.frame;
    tvFrame.size.height = convertedFrame.origin.y-44;
    _tabview.frame = tvFrame;
}

-(void) keyboardHidden:(NSNotification*) notification {
    CGRect tvFrame = _tabview.frame;
    tvFrame.size.height = _initialTVHeight;
    [UIView beginAnimations:@"TableViewDown" context:NULL];
    [UIView setAnimationDuration:0.3f];
    _tabview.frame = tvFrame;
    [UIView commitAnimations];
    
}
-(void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {
    [model showView:SMARAT_ORDER_RECOMMEND_VIEW];
    [model.orderRecommendView preData];
    }
    else
    {
        [self save];
    }
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self  save];
}

-(void)initView
{
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.showsHorizontalScrollIndicator = NO;
    self.tabview.showsVerticalScrollIndicator = NO;
    self.tabview.delegate =self;
    self.tabview.dataSource =self;
    self.tabview.tableFooterView =[ViewFactory customerFooter:100];
    NSArray *arry =@[@"add"];
   // [self.footview showHelp:YES];
    //[self.footview initDelegate:self btnArrs:arry];
     //[self.footview.imgAdd setHidden:YES];
     //[self.footview.btnAdd setTitle:@"" forState:UIControlStateNormal];
     //[self.footview.btnAdd setBackgroundImage:[UIImage imageNamed:@"Initialize.png"] forState:UIControlStateNormal];
}

- (void)preData
{
    [self.titleBox initWithName:NSLocalizedString(@"提醒与推荐语设置", nil) backImg:Head_ICON_BACK moreImg:nil];
    [self.headArry removeAllObjects];
    NSArray *arry  =@[NSLocalizedString(@"菜肴类型点少推荐语", nil),NSLocalizedString(@"菜肴主料大类点少推荐语", nil),NSLocalizedString(@"菜肴具体主料点少推荐语", nil)];
    [self.headArry addObjectsFromArray:arry];
   
    [service getRemindInfo:self callback:@selector(getRemingData:)];
}

- (void)getRemingData:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }

   [self parsedata:result.content];
    
}

-(void)parsedata:(NSString *)content
{
    [self.dataArry removeAllObjects];
    [self.oldarry removeAllObjects];
    NSDictionary *map =[JsonHelper transMap:content];
    NSDictionary *data =map[@"data"];
    self.foodArry =[JsonHelper transList:data[@"foodTypeLabelConfigList"] objName:@"OrderRemindData"];
    self.majorArry =[JsonHelper transList:data[@"majorLabelConfigList"] objName:@"OrderRemindData"];
    self.minorArry =[JsonHelper transList:data[@"minorLabelConfigList"] objName:@"OrderRemindData"];
    [self.dataArry addObject:self.foodArry];
    [self.dataArry addObject:self.majorArry];
    [self.dataArry addObject:self.minorArry];
    [self.tabview reloadData];
    
    [self getolddata];
}

-(void)getolddata
{
    [self.oldarry removeAllObjects];
    for (OrderRemindData *iteam in self.foodArry) {
        [self.oldarry setObject:iteam.recommendText forKey:[NSString stringWithFormat:@"%ld",iteam.labelId]];
    }
    for (OrderRemindData *iteam in self.majorArry) {
        [self.oldarry setObject:iteam.recommendText forKey:[NSString stringWithFormat:@"%ld",iteam.labelId]];
    }
    for (OrderRemindData *iteam in self.minorArry) {
        [self.oldarry setObject:iteam.recommendText forKey:[NSString stringWithFormat:@"%ld",iteam.labelId]];
    }
  
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArry count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =self.dataArry[section];
    
    return  arry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    orderRemindCell *cell =[tableView dequeueReusableCellWithIdentifier:ORDERREMAINCELL];
    if (!cell ) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"orderRemindCell" owner:self options:nil].lastObject;
    }
    if (indexPath.row ==0) {
        [cell initHideHead:NO];
    }
    else
    {
        [cell initHideHead:YES];
    }
    NSArray *arry =self.dataArry[indexPath.section];
    OrderRemindData *iteam =arry[indexPath.row];
    [cell initTitlelbl:iteam.title];
    [cell initTextfild:iteam.recommendText];
    [cell initDelegate:self path:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    [headNameItem initWithName:self.headArry[section]];
    return headNameItem;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return REMAINCELLHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(void)ScrollViewTheViewWithPatch:(NSIndexPath *)patch title:(NSString *)title
{
     [self configNavigationBar:YES];
    NSArray *arry =self.dataArry[patch.section];
    OrderRemindData *iteam =arry[patch.row];
    iteam.recommendText =title;
    
    
   
}


-(void)popTanchView
{
    [SystemUtil hideKeyboard];
    FuctionCustomAlertView *tanchuView =[[FuctionCustomAlertView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4-20,self.view.frame.size.height-92, self.view.frame.size.width*3/4-40,30)];
    [tanchuView initWithContent:NSLocalizedString(@"标题字数限制在16字以内!", nil)];
    [self.view addSubview:tanchuView];
    [self performSelector:@selector(AlertShow:) withObject:tanchuView afterDelay:3];
    
}

-(void)AlertShow:( FuctionCustomAlertView*)view
{
    [view removeFromSuperview];
    
}

-(void)showAddEvent
{
    UIAlertView *altrt =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您希望恢复默认值吗？您设置过的数据将被更改", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [altrt show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
//        [service getRemindList:self callback:@selector(getRemingData:)];
        [service getRemindList:self callback:@selector(getRemingOldData:)];
    }

}

- (void)getRemingOldData:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:@"" data:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)save
{
    NSMutableArray *arry =[[NSMutableArray alloc]init];
    NSMutableDictionary *postDic =[[NSMutableDictionary alloc]init];
    
    [arry addObjectsFromArray:self.dataArry[0]];
    [arry addObjectsFromArray:self.dataArry[1]];
    [arry addObjectsFromArray:self.dataArry[2]];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    for (OrderRemindData *data in  arry) {
        [dict setObject:data.recommendText forKey:[NSString stringWithFormat:@"%ld",data.labelId]];
    }
    NSArray *keyArry =[dict allKeys];
    for (NSString *str in keyArry) {
        NSString *str1 =dict[str];
        NSString *str2 =self.oldarry [str];
        if (![str1 isEqualToString:str2]) {
            [postDic setObject:str1 forKey:str];
        }
    }
    
    NSString  *jsonstr =[postDic JSONString];
    [service  getRemindList:jsonstr target:self callback:@selector(getdata:)];
    
}
-(void)getdata:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:@"" data:nil];
    }
    [self .navigationController popViewControllerAnimated:YES];
    
    
}

-(void)showHelpEvent
{
    [HelpDialog show:@"orderRemind" ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ObjectUtil isNotEmpty:self.dic]) {
        self.delegate = self.dic[@"delegate"];
    }
}


@end
