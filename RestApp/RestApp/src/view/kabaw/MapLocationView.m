//
//  MapLocation.m
//  RestApp
//
//  Created by 刘红琳 on 15/11/30.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MapLocationView.h"
#import "KeyBoardUtil.h"
#import "UIHelper.h"
#import "NSString+Estimate.h"

#define kArrorHeight    10
#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50
#define kTitleWidth         240
#define kTitleHeight        20

#define BYSEARCH 1
#define BYPREESS 2

@interface MapLocationView ()<CLLocationManagerDelegate>
{
    CLLocationManager      *_locationmanager;
}
@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
@end

@implementation MapLocationView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initNavigate];
    self.dataArr = [[NSMutableArray alloc]init];
    self.annotationArr = [[NSMutableArray alloc]init];
    self.addressDic = [[NSMutableDictionary alloc] init];
    self.lblWarn.hidden = YES;
    self.tableView.hidden = YES;
    self.locationBtn.layer.borderWidth = 1;
    self.locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [KeyBoardUtil initWithTarget:self.searchBar];
    [self loadDataView];
    for (UIView *view in self.searchBar.subviews) {
        CGRect frame = view.frame;
        frame.size.width = SCREEN_WIDTH;
        view.frame = frame;
    }
}

-(void)loadDataView
{
    [self.titleBox initWithName:NSLocalizedString(@"地图定位", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"地图定位", nil);
    self.isFirst = YES;
    self.isLocation = NO;
    self.searchBar.text = @"";
    self.tableView.hidden = YES;
    self.longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    self.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    self.mapAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"mapAddress"];
    
    CLLocationDegrees longitude = [self.longitude doubleValue];
    CLLocationDegrees latitude = [self.latitude doubleValue];
    self.shoplongitude = [NSString stringWithFormat:@"%f",longitude];
    self.shopLatitude = [NSString stringWithFormat:@"%f",latitude];
   
    //创建地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.container.frame.size.height)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.userTrackingMode = 1;
    [self.container insertSubview:_mapView atIndex:0];
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.searchBar.delegate = self;
    UILongPressGestureRecognizer *Lpress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressClick:)];
    Lpress.delegate=self;
    Lpress.minimumPressDuration=1.0;
    Lpress.allowableMovement=50;
    [_mapView addGestureRecognizer:Lpress];
    
    int longtitude1 = [self.longitude intValue];
    int latitude1 = [self.latitude intValue];
    if(longtitude1 <1 && latitude1 <1)
    {
        //定位服务是否可用
        BOOL enable=[CLLocationManager locationServicesEnabled];
        if(!enable)
        {
            [MessageBox show:NSLocalizedString(@"地图定位功能需要打开您手机的GPS开关", nil) client:self];
            return;
        }
        [self startLocation];
    }else{
        self.clickType = BYPREESS;
        [_mapView removeAnnotations:_mapView.annotations];
        if ([NSString isBlank:self.mapAddress]) {
            [self reGeoCodeWithCooordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        }else{
            NSString *title;
            NSString *subtitle;
           BOOL orHanve = [self.mapAddress rangeOfString:@"{|$"].location!=NSNotFound;
            if (orHanve) {
                NSArray *array = [self.mapAddress componentsSeparatedByString:@"{|$"];
                title = array[0];
                subtitle = array[1];
            }else{
                title = self.mapAddress;
                subtitle = @"";
            }
            [self createAnnotationwithcoordinate:CLLocationCoordinate2DMake(latitude, longitude) title:title subTitle:subtitle];
        }
    }
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:SHOP_EDIT_VIEW];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
    }else{
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    if (self.backBlock) {
        self.backBlock(self.shoplongitude,self.shopLatitude,self.mapAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

#pragma mark- 长按时间相应
-(void)LongPressClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if (self.isFirst) {
            [_mapView removeAnnotations:_mapView.annotations];
        }
        CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
        self.clickType = BYPREESS;
        [self reGeoCodeWithCooordinate:touchMapCoordinate];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)startSearch
{
    [_mapView removeAnnotations:_mapView.annotations];
    self.clickType = BYSEARCH;
    self.isFirst = NO;
    //构造AMapInputTipsSearchRequest对象，设置输入提示查询请求参数
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = self.searchBar.text;
    tipsRequest.types = NSLocalizedString(@"餐饮服务|生活服务", nil);
    //发起输入提示查询搜索
    [_search AMapInputTipsSearch:tipsRequest];
    [self.tableView reloadData];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    [self.dataArr removeAllObjects];
    if(response.tips.count == 0) {
        [AlertBox show:NSLocalizedString(@"抱歉，未找到结果,有可能是未输入餐店所在的城市引起的", nil)];
        self.tableView.hidden = YES;
        return;
    }
    else {
        AMapTip* p = response.tips[0];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        for(AMapTip* p in response.tips){
            MAPointAnnotation* annotation = [[MAPointAnnotation alloc]init];
            annotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
            annotation.title = p.name;
            annotation.subtitle = p.district;
            [self.addressDic setObject:[NSString stringWithFormat:@"%@{|$%@",annotation.title,annotation.subtitle] forKey:p.name];
            [_mapView addAnnotation:annotation];
            [self .dataArr addObject:p.name];
        }
        [self.tableView reloadData];
    }
}
-(void)dismissWarn
{
    self.lblWarn.hidden = YES;
}

//逆地理编码
-(void)reGeoCodeWithCooordinate:(CLLocationCoordinate2D)cooordinate
{
    NSNumber *longitude =[NSNumber numberWithDouble:cooordinate.longitude];
    CGFloat longitude1 = [longitude floatValue];
     NSNumber *latitude =[NSNumber numberWithDouble:cooordinate.latitude];
    CGFloat latitude1 = [latitude floatValue];
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude1 longitude:longitude1];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        NSString *longitude = [NSString stringWithFormat:@"%.4f",request.location.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.4f",request.location.latitude];
        NSString *longitude1 = [NSString stringWithFormat:@"%.4f",[self.longitude doubleValue]];
        NSString *latitude1 = [NSString stringWithFormat:@"%.4f",[self.latitude doubleValue]];
        if (![longitude1 isEqualToString:longitude] && ![latitude1 isEqualToString:latitude]) {
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        }else{
            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_VIEW];
        }
        if (self.isLocation) {
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        }
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        self.shoplongitude = [NSString stringWithFormat:@"%f",request.location.longitude];
        self.shopLatitude = [NSString stringWithFormat:@"%f",request.location.latitude];
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        [self.addressDic setObject:[[NSString stringWithFormat:@"%@",response.regeocode.formattedAddress] stringByAppendingString:@"{|$"] forKey:response.regeocode.formattedAddress];
        [self createAnnotationwithcoordinate:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude) title:response.regeocode.formattedAddress subTitle:nil];
    }
}

//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    AMapGeocode *p = response.geocodes[0];
    self.shoplongitude = [NSString stringWithFormat:@"%f",p.location.longitude];
    self.shopLatitude = [NSString stringWithFormat:@"%f",p.location.latitude];
}

- (void)startLocation
{
    [_mapView removeAnnotations:_mapView.annotations];
    [UIHelper showHUD:NSLocalizedString(@"正在定位,请稍候", nil) andView:self.view andHUD:hud];
    self.array =[[NSMutableArray alloc]init];
    self.isloging=YES;
    self.isLocation=YES;
    [self.locMgr startUpdatingLocation];
}

- (AMapLocationManager *)locMgr {
    if (!_locMgr) {
        _locMgr = [[AMapLocationManager alloc] init];
        
        _locationmanager = [[CLLocationManager alloc] init];
        _locationmanager.delegate = self;
        [_locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        _locMgr.delegate = self;
        // 定位精度
        _locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locMgr;
}

//当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location&&self.isloging) {
        self.isloging=NO;
        [self.array addObject:location];
        [_locMgr stopUpdatingLocation];
    }
    CLLocation *location1;
    if (self.array.count != 0) {
        [hud hide:YES];
        location1 = [self.array lastObject];
        //取出当前位置的坐标
        _mapView.centerCoordinate = location1.coordinate;
        CLLocationDegrees latitude = location1.coordinate.latitude;
        CLLocationDegrees longitude = location1.coordinate.longitude;
        self.clickType = BYPREESS;
        [self reGeoCodeWithCooordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [hud hide:YES];
    NSString *errorMessage = [NSString stringWithFormat:@"%@",error];
    if ([errorMessage isEqualToString:@"Error Domain=kCLErrorDomain Code=1 \"(null)\""]) {
        [AlertBox show:NSLocalizedString(@"“二维火掌柜”已被禁止使用定位权限，请在您的手机设置中更改应用的权限", nil)];
        return;
    }
}

- (void)createAnnotationwithcoordinate:(CLLocationCoordinate2D)cooordinate title:(NSString *)title subTitle:(NSString *)subTitle {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate=cooordinate;
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subTitle;
//    [self.addressDic setObject:[[[NSString stringWithFormat:@"%@",title] stringByAppendingString:@"{|$"] stringByAppendingString:subTitle] forKey:title];
    
    [_mapView addAnnotation:pointAnnotation];
    [_mapView selectAnnotation:pointAnnotation animated:YES];
}

//实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。如下所示：
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= NO; //设置气泡可以弹出,默认为 NO
        annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO
        if (self.clickType == BYPREESS) {
            annotationView.pinColor = MAPinAnnotationColorRed;
        }else if (self.clickType == BYSEARCH){
            annotationView.pinColor = MAPinAnnotationColorPurple;
        }
        return annotationView;
    }
    return nil;
}

//当选中一个annotation views时调用此接口
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAPinAnnotationView *)view
{
    NSString *longitude = [NSString stringWithFormat:@"%f",view.annotation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",view.annotation.coordinate.latitude];
    if (![self.shoplongitude isEqualToString:longitude] && ![self.shopLatitude isEqualToString:latitude]) {
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        self.shoplongitude = longitude;
        self.shopLatitude = latitude;
    }

    if (self.isFirst == NO) {
        //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
        AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
        geo.address = view.annotation.title;
        //发起正向地理编码
        [_search AMapGeocodeSearch: geo];
    }
    
    if([view isKindOfClass:[MAPinAnnotationView class]]){
     view.pinColor = MAPinAnnotationColorRed;
     mapView.centerCoordinate = view.annotation.coordinate;
    if (self.annotationArr.count != 0) {
        for (MAPinAnnotationView * view1 in self.annotationArr) {
            if (![view1.annotation.subtitle isEqualToString:view.annotation.subtitle]) {
                view1.pinColor = MAPinAnnotationColorPurple;
            }
        }
    }
    [self.annotationArr addObject:view];
    }else{
        return;
    }
    if (self.calloutView == nil)
    {
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 260,50)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.f + view.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + view.calloutOffset.y);
    }
    [view addSubview:self.calloutView];
    NSString *title;
    NSString *subtitle;
    BOOL orHanve;
    if(self.isFirst)
    {
        if ([NSString isBlank:self.mapAddress]) {
               orHanve = [[self.addressDic objectForKey:view.annotation.title] rangeOfString:@"{|$"].location!=NSNotFound;
        }else{
                orHanve = [self.mapAddress rangeOfString:@"{|$"].location!=NSNotFound;
        }
    }else{
        orHanve = [[self.addressDic objectForKey:view.annotation.title] rangeOfString:@"{|$"].location!=NSNotFound;
    }
    
    if (orHanve) {
        NSArray *array;
        if (self.isFirst) {
            if ([NSString isBlank:self.mapAddress]) {
                  array = [[self.addressDic objectForKey:view.annotation.title]  componentsSeparatedByString:@"{|$"];
            }else{
            array = [self.mapAddress componentsSeparatedByString:@"{|$"];
            }
        }else{
            array = [[self.addressDic objectForKey:view.annotation.title]  componentsSeparatedByString:@"{|$"];
        }
        if (array.count == 1) {
           title = array[0];
            subtitle = nil;
        }else if (array.count == 2)
        {
            title = array[0];
            subtitle = array[1];
        }
    }else{
        title = self.mapAddress;
        subtitle = @"";
    }
    self.calloutView.titleLabel.text = title;
    self.calloutView.subtitleLabel.text = subtitle;
   
    if ([NSString isBlank:subtitle]) {
        self.calloutView.subtitleLabel.hidden = YES;
        
        CGRect Rect2 = [self.calloutView.titleLabel.text boundingRectWithSize:CGSizeMake(240, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGRect rect2 = self.calloutView.titleLabel.frame;
        rect2.size.height = Rect2.size.height;
        self.calloutView.titleLabel.frame = rect2;
       
        float height1 = Rect2.size.height;
        CGRect rect4 = self.calloutView.frame;
        rect4.size.height = height1 +10;
        self.calloutView.frame = rect4;
        self.calloutView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.f + view.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + view.calloutOffset.y);
        }else{
        self.calloutView.subtitleLabel.hidden = NO;
            
        self.calloutView.titleLabel.frame = CGRectMake(kPortraitMargin * 2, kPortraitMargin, kTitleWidth, kTitleHeight);
        self.calloutView.subtitleLabel.frame = CGRectMake(kPortraitMargin * 2, kPortraitMargin * 2 + kTitleHeight, kTitleWidth, kTitleHeight);
        
        CGRect Rect2 = [self.calloutView.titleLabel.text boundingRectWithSize:CGSizeMake(240, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGRect rect2 = self.calloutView.titleLabel.frame;
        rect2.size.height = Rect2.size.height;
        self.calloutView.titleLabel.frame = rect2;
        
        CGRect Rect = [self.calloutView.subtitleLabel.text boundingRectWithSize:CGSizeMake(240, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        CGRect rect3 = self.calloutView.subtitleLabel.frame;
        rect3.size.height = Rect.size.height;
        rect3.origin.y = rect2.size.height+8;
        self.calloutView.subtitleLabel.frame = rect3;
        
        float height1 = Rect2.size.height;
        float height2 = Rect.size.height;
       
        CGRect rect4 = self.calloutView.frame;
        rect4.size.height = height1 + height2+20;
        self.calloutView.frame = rect4;
        self.calloutView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.f + view.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + view.calloutOffset.y);
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAPinAnnotationView *)view
{
    if([view isKindOfClass:[MAPinAnnotationView class]]){
        view.pinColor = MAPinAnnotationColorPurple;
    }
    [self.calloutView removeFromSuperview];
}

- (IBAction)locationBtnClick:(id)sender {
    //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    if(!enable)
    {
        [MessageBox show:NSLocalizedString(@"地图定位功能需要打开您手机的GPS开关", nil) client:self];
        return;
    }

        [self startLocation];
}

//实现警告框确定协议
- (void)confirm
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
}

- (IBAction)narrowBtnClick:(id)sender {
    
    _mapView.zoomLevel -= 0.1;
}

- (IBAction)amplifyBtnClick:(id)sender {
    _mapView.zoomLevel += 0.1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self startSearch];
    self.tableView.hidden = YES;
    self.lblWarn.hidden = NO;
    [self performSelector:@selector(dismissWarn) withObject:nil afterDelay:3];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.tableView.hidden = YES;
    NSString *title;
    NSString *subtitle;
    BOOL orHanve = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mapAddress"] rangeOfString:@"{|$"].location!=NSNotFound;
    if (orHanve) {
        NSArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mapAddress"] componentsSeparatedByString:@"{|$"];
        title = array[0];
        subtitle = array[1];
    }else{
        title = [[NSUserDefaults standardUserDefaults] objectForKey:@"mapAddress"];
        subtitle = @"";
    }
    [self createAnnotationwithcoordinate:CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]) title:title subTitle:subtitle];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(self.searchBar.text.length == 0){
         [self.searchBar setShowsCancelButton:NO];;
        [self.searchBar resignFirstResponder];
        self.tableView.hidden = YES;
    }else{
        [self startSearch];
        self.searchBar.showsCancelButton = YES;
        [self.searchBar becomeFirstResponder];
        self.tableView.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([ObjectUtil isNotEmpty:self.dataArr]) {
        cell.textLabel.text=self.dataArr[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchBar.text = self.dataArr[indexPath.row];
    self.tableView.hidden = YES;
    [self.searchBar becomeFirstResponder];
    [self startSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
