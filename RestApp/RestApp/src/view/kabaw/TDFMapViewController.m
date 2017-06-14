//
//  TDFMapViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2017/3/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MessageBox.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "NSString+Estimate.h"


@interface TDFMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,MessageBoxClient,CLLocationManagerDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    CLLocationManager      *_locationmanager;
}
@property (strong, nonatomic) AMapLocationManager *locMgr;
@property (nonatomic ,strong) MACircle  *crile ;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@property (strong, nonatomic) NSString *mapAddress;
@property (nonatomic, strong) TDFTakeOutSettings* takeOutSet;

@end

@implementation TDFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor  = [UIColor clearColor];
    self.title  = @"地图定位";
    [self configNavigationBar:NO];
    [self initSearch];
    [self initMainView];
    [self  addLocationView];
    [self addLevelButton];
}

#pragma navigate
- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

- (void)rightNavigationButtonAction:(id)sender
{
    self.fileBlock(self.takeOutSet);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configIteam:(TDFTakeOutSettings *)vo
{
    self.takeOutSet  = vo ;
    self.longitude  =  [NSString stringWithFormat:@"%@",vo.longitude];
    self.latitude  =  [NSString stringWithFormat:@"%@",vo.latitude];
    self.mapAddress  =  [NSString  stringWithFormat:@"%@",vo.mapAddress];
}

- (void)initMainView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.logoCenter  = CGPointMake(100, 20);//隐藏高德地图logo
    CLLocationDegrees longitude = [self.longitude doubleValue];
    CLLocationDegrees latitude = [self.latitude doubleValue];
    CLLocationCoordinate2D  coordinate  =  CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView setCenterCoordinate: coordinate];
    _mapView.delegate  =self;
    [_mapView setZoomLevel:13 animated:YES];
    [self.view addSubview: _mapView];
    if (self.longitude.integerValue  <1  &&  self.latitude.integerValue <1) {
        [self btnStartLocation];
    }
    else
    {
        if ([NSString  isBlank:self.mapAddress]) {
             [self reGeoCodeWithCooordinate:coordinate];
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
        [self createAnnotationwithcoordinate:coordinate title:title subTitle:subtitle];
      }
    }
    CGFloat radio  = (CGFloat )self.takeOutSet.maxRange;
    [_mapView  removeOverlays:_mapView.overlays];
   [self cirleWithcoordinate:coordinate radius:radio];

}

- (void) initSearch
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

- (void)createAnnotationwithcoordinate:(CLLocationCoordinate2D)cooordinate title:(NSString *)title subTitle:(NSString *)subTitle {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = cooordinate;
    pointAnnotation.title =  title;
    pointAnnotation.subtitle = subTitle;
    [_mapView addAnnotation:pointAnnotation];
    [_mapView  selectAnnotation:pointAnnotation animated:YES];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO
        annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO
        annotationView.draggable = YES; //设置标注可以拖动,默认为 NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer  *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 5.f;
        circleRenderer.strokeColor  = RGBA(201, 219, 241, 0.6);
        circleRenderer.fillColor      =  RGBA(201, 219, 241, 0.6);
        return circleRenderer;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
//    NSLog(@"%f",mapView.zoomLevel);
}

- (void)addLocationView
{
    UIButton *locationButton  = [[UIButton  alloc] init ];
    [self.view addSubview:locationButton];
    [locationButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.size.mas_equalTo (CGSizeMake(124, 30));
    }];
   
    [locationButton setBackgroundImage:[UIImage imageNamed:@"btn_white_large"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"btn_grey_large"]  forState:UIControlStateHighlighted];
    [locationButton setTitle:@"  使用当前位置" forState: UIControlStateNormal ];
    UIColor  *color  =  RGBA(120, 119,119, 1);
    [locationButton  setTitleColor:color forState:UIControlStateNormal];
    locationButton.titleLabel.font  = [UIFont systemFontOfSize:12];
    locationButton.titleLabel.textAlignment   = NSTextAlignmentRight;
    locationButton.layer.borderWidth = 1;
    locationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [locationButton  addTarget:self action:@selector(btnStartLocation) forControlEvents:UIControlEventTouchUpInside];
    UIImageView  *backImg  = [[UIImageView  alloc]  init ];
    [self.view  addSubview:backImg];
    [backImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.bottom.equalTo (self.view.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    backImg.image  = [UIImage imageNamed:@"location"];
}

- (void)addLevelButton
{
    UIImageView  *bgImg  = [[ UIImageView  alloc] init];
    [self.view  addSubview:bgImg];
    [bgImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right).with.offset(-40);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.size.mas_equalTo (CGSizeMake(30,75));
    }];
    [bgImg  setImage:[UIImage imageNamed:@"mapBac.png"]];
    UIButton  *amplifyBtn  = [[UIButton  alloc] init ];
     [self.view addSubview:amplifyBtn];
    [amplifyBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImg.mas_top).with.offset(2);
        make.left.equalTo(bgImg.mas_left);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [amplifyBtn  addTarget:self action:@selector(enlargeClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView  *amplifyIco  = [[UIImageView  alloc] init ];
    [self.view addSubview:amplifyIco];
    [amplifyIco mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amplifyBtn.mas_top).with.offset(12);
        make.left.equalTo(amplifyBtn.mas_left).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [amplifyIco setImage:[UIImage imageNamed:@"amplification.png"]];
    UIView *lineView  = [[UIView  alloc] init];
    [self.view addSubview:lineView];
    [lineView   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amplifyBtn.mas_left).with.offset(4);
        make.top.equalTo(amplifyIco.mas_bottom).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(24, 1));
    }];
    lineView.backgroundColor   = [UIColor lightGrayColor];
    UIButton * shrinkBtn = [[UIButton  alloc] init ];
    [self.view addSubview:shrinkBtn];
    [shrinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amplifyBtn.mas_left);
        make.top.equalTo(lineView.mas_bottom).with.offset(1);
        make.size.mas_equalTo (CGSizeMake(32, 32));
    }];
    [shrinkBtn addTarget:self action:@selector(shrinkClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView  *shrinkIco  = [[UIImageView  alloc] init ];
    [self.view addSubview:shrinkIco];
    [shrinkIco mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shrinkBtn.mas_top).with.offset(2);
        make.left.equalTo(shrinkBtn.mas_left).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [shrinkIco setImage:[UIImage imageNamed:@"narrow.png"]];
}


- (void)btnStartLocation
{
    [self configLocationCompetence];
    [self startLocation];
}

- (void)startLocation
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView  removeOverlays:_mapView.overlays];
    [self  showProgressHudWithText:NSLocalizedString(@"正在定位,请稍候", nil)];
    [self.locMgr startUpdatingLocation];
}

#pragma 定位权限开启
- (void)configLocationCompetence
{
    BOOL enable=[CLLocationManager locationServicesEnabled];
    if(!enable)
    {
        [MessageBox show:NSLocalizedString(@"地图定位功能需要打开您手机的GPS开关", nil) client:self];
        return;
    }
}

- (void)confirm
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
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

#pragma mark  --lcoationDelegate

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location) {
           [self.progressHud  hideAnimated: YES];
         [_locMgr stopUpdatingLocation];
        _mapView.centerCoordinate = location.coordinate;
        CLLocationDegrees latitude = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        [self reGeoCodeWithCooordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    }

    
}

    
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.progressHud hideAnimated:YES];
    NSString *errorMessage = [NSString stringWithFormat:@"%@",error];
    if ([errorMessage isEqualToString:@"Error Domain=kCLErrorDomain Code=1 \"(null)\""]) {
        [AlertBox show:NSLocalizedString(@"“二维火掌柜”已被禁止使用定位权限，请在您的手机设置中更改应用的权限", nil)];
        return;
    }
}

//逆地理编码
-(void)reGeoCodeWithCooordinate:(CLLocationCoordinate2D)cooordinate
{
    NSNumber *longitude =[NSNumber numberWithDouble:cooordinate.longitude];
    CGFloat longitude1 = [longitude floatValue];
    NSNumber *latitude =[NSNumber numberWithDouble:cooordinate.latitude];
    CGFloat latitude1 = [latitude floatValue];

    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude1 longitude:longitude1];
    regeo.requireExtension = YES;
    [_search AMapReGoecodeSearch:regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode !=  nil) {
      
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
         [self createAnnotationwithcoordinate:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude) title:response.regeocode.formattedAddress subTitle:nil];
        [self cirleWithcoordinate:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude)  radius:self.takeOutSet.maxRange];
       
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [AlertBox show:error.localizedDescription];
}

#pragma 画圆
- (void)cirleWithcoordinate:(CLLocationCoordinate2D)cooordinate radius:(CGFloat) radius
{
   self.crile  = [MACircle   circleWithCenterCoordinate:cooordinate radius:radius];
   [_mapView addOverlay:self.crile];
}

#pragma mark buttonClick
- (void)enlargeClick:(UIButton  *)button
{
     _mapView.zoomLevel += 0.1;
}

- (void)shrinkClick:(UIButton  *)button
{
    _mapView.zoomLevel -= 0.1;
}

@end
