//
//  TDFKBAuthListController.m
//  RestApp
//
//  Created by BK_G on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKBAuthListController.h"

#import "Masonry.h"

#import "TDFAddCouponCell.h"

#import "TDFKBAuthorizeController.h"

#import "TDFRootViewController+FooterButton.h"

#import "HelpDialog.h"

@interface TDFKBAuthListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TDFKBAuthListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"口碑功能", nil);
    
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTableView {

    _tableView = [[UITableView alloc]init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *bgWhiteV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 199)];
    
    bgWhiteV.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    [headView addSubview:bgWhiteV];
    
    self.tableView.tableHeaderView = headView;
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20,60,60)];
    imageView.image =[UIImage imageNamed:@"KBAction.png"];
    [headView addSubview:imageView];
    imageView.layer.masksToBounds =YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    UILabel *conTentLbl =[[UILabel alloc] initWithFrame:CGRectMake(11, 80, SCREEN_WIDTH-11-11, 120)];
    [headView addSubview: conTentLbl];
    conTentLbl.backgroundColor =[UIColor clearColor];
    conTentLbl.textAlignment = NSTextAlignmentLeft;
    conTentLbl.numberOfLines =0;
    conTentLbl.textColor =RGBA(123, 124, 126, 1);
    conTentLbl.font =[UIFont systemFontOfSize:14];
    conTentLbl.text =NSLocalizedString(@"商户要使用支付宝口碑相关功能，如支付宝支付、口碑营销（优惠券）等，首先需要开通口碑店，然后用开店绑定的支付宝扫描二维码进行授权，授权成功后成为二维火直连商户，就可以使用口碑相关功能了。", nil);
    
    //-------------------//
    
    __weak typeof(self) weakSelf = self;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    
    [self showHelpEvent];
}

-(void)showHelpEvent
{
    [HelpDialog showContent:NSLocalizedString(@"商户要使用支付宝口碑相关功能，如支付宝支付、口碑营销（优惠券）等，首先需要开通口碑店，然后用开店绑定的支付宝扫描二维码进行授权，授权成功后成为二维火直连商户，就可以使用口碑相关功能了。", nil) withTitle:NSLocalizedString(@"口碑功能", nil)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.dataArr[indexPath.row] objectForKey:@"type"] isEqualToString:@"1"]) {
        
        [self openKouBei];
    }
    else if ([[self.dataArr[indexPath.row] objectForKey:@"type"] isEqualToString:@"2"]) {
    
        [self kouBeiAuth];
    }
}

- (void)openKouBei {

    NSURL *url = [NSURL URLWithString:@"alipaym://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"“口碑商家”应用是支付宝口碑为各位商家提供的移动端管理工具，轻松完成支付宝收款，创建和管理线上门店，发布运营活动，帮助线下商家更好地吸引新用户、留住老用户、提升品牌影响力。您希望下载“口碑商家”应用吗？", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"安装应用", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/kou-bei-shang-jia/id796778475?mt=8"];
            
            [[UIApplication sharedApplication] openURL:url];
        }];
        
        [alertController addAction:confirmAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
        
        [viewController presentViewController:alertController animated:YES completion:nil];
    }

}

- (void)kouBeiAuth {

    TDFKBAuthorizeController *vc = [[TDFKBAuthorizeController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFAddCouponCell *cell = [[TDFAddCouponCell alloc]init];
    
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    
    cell.mainLabel.text = [self.dataArr[indexPath.row] objectForKey:@"mainLabel"];
    cell.imgView.image = [self.dataArr[indexPath.row] objectForKey:@"imgView"];
    cell.secondLabel.text = [self.dataArr[indexPath.row] objectForKey:@"secondLabel"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


#pragma mark - Getter&Setter

- (NSMutableArray *)dataArr {

    if (!_dataArr) {
        
        _dataArr = [NSMutableArray new];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:NSLocalizedString(@"开通口碑店", nil) forKey:@"mainLabel"];
        [dic setObject:[UIImage imageNamed:@"openKBShop.png"] forKey:@"imgView"];
        [dic setObject:NSLocalizedString(@"下载口碑APP，开通口碑店", nil) forKey:@"secondLabel"];
        [dic setObject:@"1" forKey:@"type"];
        
        BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
        
//        if (showRestApp) {
            
            [_dataArr addObject:dic];
//        }
        
        NSMutableDictionary *dic1 = [NSMutableDictionary new];
        
        [dic1 setObject:NSLocalizedString(@"口碑功能授权", nil) forKey:@"mainLabel"];
        [dic1 setObject:[UIImage imageNamed:@"KBFuntionAuth.png"] forKey:@"imgView"];
        [dic1 setObject:NSLocalizedString(@"用口碑开店绑定的支付宝扫描二维码授权", nil) forKey:@"secondLabel"];
        [dic1 setObject:@"2" forKey:@"type"];
        [_dataArr addObject:dic1];
    }
    
    return _dataArr;
}

@end




