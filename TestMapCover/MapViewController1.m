//
//  MapViewController1.m
//  TestMapCover
//
//  Created by 卢大维 on 15/3/31.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import "MapViewController1.h"
#import <MapKit/MapKit.h>
#import "Masonry.h"
#import "CWMyOverlayView.h"
#import "CWMyPolyLineRenderer.h"
#import "Util.h"

@interface MapViewController1 ()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) NSDictionary *dataInfo,*data;
@property (nonatomic,strong) UIImageView *indexView;

@end

@implementation MapViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
    }];
    
    UIButton *button = [UIButton new];
    [button setTitle:@"×" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:40];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
#if 0
    UIImage *indexImage = [UIImage imageNamed:@"index"];
    CGFloat imgWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)*0.5;
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = indexImage;
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(imgWidth);
        make.height.mas_equalTo(imgWidth*indexImage.size.height/indexImage.size.width);
    }];
#else
    UIImage *indexImage = [UIImage imageNamed:@"index1"];
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = indexImage;
    [self.view addSubview:imgView];
    self.indexView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
#endif
    
    
    [self initDataInfo];
    [self initData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.indexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.bounds.size.width*self.indexView.image.size.height/self.indexView.image.size.width);
    }];
}

-(void)addAreasToMap
{
    NSArray *areas = [self.data objectForKey:@"areas"];
    for (NSDictionary *area in areas) {
        NSArray *items = [area objectForKey:@"items"];
        
        CLLocationCoordinate2D * points = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * items.count);
        
        for (NSInteger i=0; i<items.count; i++) {
            NSDictionary *point = [items objectAtIndex:i];
            
            points[i] = CLLocationCoordinate2DMake([[point objectForKey:@"y"] doubleValue], [[point objectForKey:@"x"] doubleValue]);
        }
        
        MKPolygon *line = [MKPolygon polygonWithCoordinates:points count:items.count];
        NSDictionary *data = [self dataFromDataInfoWithCode:[area objectForKey:@"code"] text:[[area objectForKey:@"symbols"] objectForKey:@"text"]];

        line.title = [data objectForKey:@"color"];
        line.subtitle = [data objectForKey:@"is_stripe"];
        free(points);
        
        [self.mapView addOverlay:line];
    }
}

-(void)addLinesToMap
{
//    NSArray *areas = [self.data objectForKey:@"lines"];
    /********* 目前没有，暂时不处理 *********/
    
//    for (NSDictionary *area in areas) {
//        NSArray *items = [area objectForKey:@"items"];
//        
//        CLLocationCoordinate2D * points = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * items.count);
//        
//        for (NSInteger i=0; i<items.count; i++) {
//            NSDictionary *point = [items objectAtIndex:i];
//            
//            points[i] = CLLocationCoordinate2DMake([[point objectForKey:@"y"] doubleValue], [[point objectForKey:@"x"] doubleValue]);
//        }
//        
//        MKPolygon *line = [MKPolygon polygonWithCoordinates:points count:items.count];
//        line.subtitle = [self colorStringFromDataInfoWithCode:[area objectForKey:@"code"] text:[[area objectForKey:@"symbols"] objectForKey:@"text"]];
//        free(points);
//        
//        [self.mapView addOverlay:line];
//    }
}

-(void)addLine_symbolsToMap
{
    NSArray *areas = [self.data objectForKey:@"line_symbols"];
    for (NSDictionary *area in areas) {
        
        if ([[area objectForKey:@"code"] integerValue] != 38) {
            continue;
        }
        
        NSArray *items = [area objectForKey:@"items"];
        
        CLLocationCoordinate2D * points = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * items.count);
        
        for (NSInteger i=0; i<items.count; i++) {
            NSDictionary *point = [items objectAtIndex:i];
            
            points[i] = CLLocationCoordinate2DMake([[point objectForKey:@"y"] doubleValue], [[point objectForKey:@"x"] doubleValue]);
        }
        
        MKPolyline *line = [MKPolyline polylineWithCoordinates:points count:items.count];
//        line.subtitle = [self colorStringFromDataInfoWithCode:[area objectForKey:@"code"] text:[[area objectForKey:@"symbols"] objectForKey:@"text"]];
        free(points);
        
        [self.mapView addOverlay:line];
    }
}

-(void)addSymbolsToMap
{
    NSArray *areas = [self.data objectForKey:@"symbols"];
    for (NSDictionary *area in areas) {
        
        MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake([[area objectForKey:@"y"] doubleValue], [[area objectForKey:@"x"] doubleValue]);
        ann.title = [area objectForKey:@"text"];
        
        [self.mapView addAnnotation:ann];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addAreasToMap];
    
    [self addLine_symbolsToMap];
    
//    [self addSymbolsToMap];
}

-(NSDictionary *)dataFromDataInfoWithCode:(NSString *)code text:(NSString *)colorText
{
    NSMutableDictionary *finalData = [NSMutableDictionary dictionary];
    
    NSArray *blendent = [[self.dataInfo objectForKey:@"legend"] objectForKey:@"blendent"];
    for (NSDictionary *dict in blendent) {
        if ([[[dict objectForKey:@"val"] objectForKey:@"v"] integerValue] == [code integerValue]) {
            NSArray *colors = [dict objectForKey:@"colors"];
            
            [finalData setObject:[[dict objectForKey:@"is_stripe"] boolValue]?@"1":@"0" forKey:@"is_stripe"];
            
            for (NSDictionary *colorDict in colors) {
                
                NSArray *val = [colorDict objectForKey:@"val"];
                if (colorText.integerValue >= [val.firstObject integerValue] && colorText.integerValue < [val.lastObject integerValue]) {
                    [finalData setObject:[colorDict objectForKey:@"color"] forKey:@"color"];
                }
            }
        }
    }
    
    return finalData;
}

-(void)initDataInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"24小时降水量预报" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    
    self.dataInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

-(void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51da13e2d273292f5710aece155c86b2ee02f4e8" ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    
    self.data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MKMapDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        CWMyOverlayRenderer *routineView = [[CWMyOverlayRenderer alloc] initWithPolygon:overlay];
        routineView.fillColor = [[Util colorFromRGBString:[overlay title]] colorWithAlphaComponent:0.7];
        
        renderer = routineView;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
            CWMyPolyLineRenderer * routineView = [[CWMyPolyLineRenderer alloc] initWithPolyline:overlay];
            routineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];//[[self colorFromRGBString:[overlay subtitle]] colorWithAlphaComponent:0.7];
            routineView.lineWidth = 1.5;
            renderer = routineView;
    }
    
    return renderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *annIdentifier = @"annIdentifier";
        
        MKAnnotationView *poiAnnotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:annIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = [UIImage imageNamed:@"map_anni_point"];
        //        poiAnnotationView.centerOffset = CGPointMake(0, -(poiAnnotationView.image.size.height/2));
        //
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        //        [poiAnnotationView addGestureRecognizer:tap];
        
        return poiAnnotationView;
    }
    
    return nil;
}

@end
