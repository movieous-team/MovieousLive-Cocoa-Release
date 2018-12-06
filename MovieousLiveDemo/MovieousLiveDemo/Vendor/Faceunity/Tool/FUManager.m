//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
#import "authpack.h"
#import "FULiveModel.h"
#import <sys/utsname.h>
#import <CoreMotion/CoreMotion.h>
#import "FUMusicPlayer.h"
#import "FUImageHelper.h"

@interface FUParamsSet : NSObject

@property (nonatomic, assign)               BOOL enableGesture;         /**设置是否开启手势识别，默认未开启*/
@property (nonatomic, assign)               BOOL enableMaxFaces;        /**设置人脸识别个数，默认为单人模式*/

@property (nonatomic, assign) BOOL skinDetectEnable ;   // 精准美肤
@property (nonatomic, assign) NSInteger blurShape;      // 美肤类型 (0、1、) 清晰：0，朦胧：1
@property (nonatomic, assign) double blurLevel;         // 磨皮(0.0 - 6.0)
@property (nonatomic, assign) double whiteLevel;        // 美白
@property (nonatomic, assign) double redLevel;          // 红润
@property (nonatomic, assign) double eyelightingLevel;  // 亮眼
@property (nonatomic, assign) double beautyToothLevel;  // 美牙

@property (nonatomic, assign) NSInteger faceShape;        //脸型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
@property (nonatomic, assign) double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, assign) double thinningLevel;       /**瘦脸 (0~1)*/
@property (nonatomic, assign) double enlargingLevel_new;  /**大眼 (0~1) --  新版美颜*/
@property (nonatomic, assign) double thinningLevel_new;   /**瘦脸 (0~1) --  新版美颜*/

@property (nonatomic, assign) double jewLevel;            /**下巴 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;       /**额头 (0~1)*/
@property (nonatomic, assign) double noseLevel;           /**鼻子 (0~1)*/
@property (nonatomic, assign) double mouthLevel;          /**嘴型 (0~1)*/
@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign) double selectedFilterLevel; /* 选中滤镜的 level*/
@property (nonatomic, strong)               NSString *selectedItem;     /**选中的道具名称*/
@property (nonnull, strong) NSString *selectedMusicFilter;

/****  美妆程度  ****/
@property (nonatomic, assign) double lipstick;          // 口红
@property (nonatomic, assign) double blush;             // 腮红
@property (nonatomic, assign) double eyebrow;           // 眉毛
@property (nonatomic, assign) double eyeShadow;         // 眼影
@property (nonatomic, assign) double eyeLiner;          // 眼线
@property (nonatomic, assign) double eyelash;           // 睫毛
@property (nonatomic, assign) double contactLens;       // 美瞳

- (void)updateWithFUManager:(FUManager *)manager;

@end

@implementation FUParamsSet

- (void)updateWithFUManager:(FUManager *)manager {
    self.selectedFilter        = manager.selectedFilter       ;
    self.selectedFilterLevel   = manager.selectedFilterLevel  ;
    self.selectedItem          = manager.selectedItem         ;
    self.selectedMusicFilter   = manager.selectedMusicFilter  ;
    self.skinDetectEnable      = manager.skinDetectEnable     ;
    self.blurShape             = manager.blurShape            ;
    self.blurLevel             = manager.blurLevel            ;
    self.whiteLevel            = manager.whiteLevel           ;
    self.redLevel              = manager.redLevel             ;
    self.eyelightingLevel      = manager.eyelightingLevel     ;
    self.beautyToothLevel      = manager.beautyToothLevel     ;
    self.faceShape             = manager.faceShape            ;
    self.enlargingLevel        = manager.enlargingLevel       ;
    self.thinningLevel         = manager.thinningLevel        ;
    self.enlargingLevel_new    = manager.enlargingLevel_new   ;
    self.thinningLevel_new     = manager.thinningLevel_new    ;
    self.jewLevel              = manager.jewLevel             ;
    self.foreheadLevel         = manager.foreheadLevel        ;
    self.noseLevel             = manager.noseLevel            ;
    self.mouthLevel            = manager.mouthLevel           ;
    self.lipstick              = manager.lipstick             ;
    self.blush                 = manager.blush                ;
    self.eyebrow               = manager.eyebrow              ;
    self.eyeShadow             = manager.eyeShadow            ;
    self.eyeLiner              = manager.eyeLiner             ;
    self.eyelash               = manager.eyelash              ;
    self.contactLens           = manager.contactLens          ;
    self.enableGesture         = manager.enableGesture        ;
    self.enableMaxFaces        = manager.enableMaxFaces       ;
}

@end

@interface FUManager ()
{
    //MARK: Faceunity
    int items[12];
    int frameID;
    
    NSDictionary *hintDic;
    
    NSDictionary *alertDic ;
    
    NSMutableArray<FUParamsSet *> *_paramsSets;
}

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) int deviceOrientation;
@end

static FUManager *shareManager = NULL;

@implementation FUManager {
    NSRecursiveLock *_renderLock;
}

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

+ (void)setDefaultRotationMode:(float)mode {
    [FURenderer setDefaultRotationMode:mode];
}

- (instancetype)init
{
    if (self = [super init]) {
        _renderLock = [NSRecursiveLock new];
        _selectedMusicFilter = @"noitem";
        _paramsSets = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
        
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        // 开启表情跟踪优化功能
        NSData *animModelData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"anim_model.bundle" ofType:nil]];
        int res0 = fuLoadAnimModel((void *)animModelData.bytes, (int)animModelData.length);
        NSLog(@"fuLoadAnimModel %@",res0 == 0 ? @"failure":@"success" );

        NSData *arModelData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ardata_ex.bundle" ofType:nil]];
        int res1 = fuLoadExtendedARData((void *)arModelData.bytes, (int)arModelData.length);
        NSLog(@"fuLoadExtendedARData %@",res1 == 0 ? @"failure":@"success" );
        
        NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
        int ret2 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
        NSLog(@"fuLoadTongueModel %@",ret2 == 0 ? @"failure":@"success" );
//
       [self setBeautyDefaultParameters];
        
        NSLog(@"faceunitySDK version:%@",[FURenderer getVersion]);
        
        hintDic = @{
                    @"future_warrior":@"张嘴试试",
                    @"jet_mask":@"鼓腮帮子",
                    @"sdx2":@"皱眉触发",
                    @"luhantongkuan_ztt_fu":@"眨一眨眼",
                    @"qingqing_ztt_fu":@"嘟嘴试试",
                    @"xiaobianzi_zh_fu":@"微笑触发",
                    @"xiaoxueshen_ztt_fu":@"吹气触发",
                    @"hez_ztt_fu":@"张嘴试试",
                    @"fu_lm_koreaheart":@"单手手指比心",
                    @"fu_zh_baoquan":@"双手抱拳",
                    @"fu_zh_hezxiong":@"双手合十",
                    @"fu_ztt_live520":@"双手比心",
                    @"ssd_thread_thumb":@"竖个拇指",
                    @"ssd_thread_six":@"比个六",
                    @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
                    };
        
        alertDic = @{
                     @"armesh_ex":@"AR面具高精度版",
                     };
        
        [self loadItemDataSource];
        
        // 初始化陀螺仪
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.5;// 1s刷新一次
        
        if ([self.motionManager isDeviceMotionAvailable]) {
            [self.motionManager startAccelerometerUpdates];
        }
        
        // 默认竖屏
        self.deviceOrientation = 0 ;
        fuSetDefaultOrientation(self.deviceOrientation) ;
        
        // 性能优先关闭
        self.performance = NO ;
    }
    
    return self;
}

- (void)setAsyncTrackFaceEnable:(BOOL)enable{
    [FURenderer setAsyncTrackFaceEnable:enable];
}

/** 根据证书判断权限
 *  有权限的排列在前，没有权限的在后
 */
- (void)loadItemDataSource {
    
    NSMutableArray *modesArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil]];
    
    NSInteger count = dataArray.count ;
    for (int i = 0 ; i < count; i ++) {
        NSDictionary *dict = dataArray[i] ;
        
        FULiveModel *model = [[FULiveModel alloc] init];
        NSString *itemName = dict[@"itemName"] ;
        model.title = itemName ;
        model.maxFace = [dict[@"maxFace"] integerValue] ;
        model.enble = NO;
        model.type = i;
        model.modules = dict[@"modules"] ;
        model.items = dict[@"items"] ;
        [modesArray addObject:model];
    }
    
    int module = fuGetModuleCode(0) ;
    
    if (!module) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:1];
    
        for (FULiveModel *model in modesArray) {
    
            model.enble = YES ;
            [_dataSource addObject:model] ;
        }
        
        return ;
    }
    
    int insertIndex = 0;
    _dataSource = [modesArray mutableCopy];

    for (FULiveModel *model in modesArray) {
        
        if ([model.title isEqualToString:@"背景分割"] || [model.title isEqualToString:@"手势识别"]) {
            if ([self isLiteSDK]) {
                continue ;
            }
        }
        
        for (NSNumber *num in model.modules) {
            
            BOOL isEable = module & [num intValue] ;
            
            if (isEable) {

                [_dataSource removeObject:model];

                model.enble = YES ;

                [_dataSource insertObject:model atIndex:insertIndex] ;
                insertIndex ++ ;

                break ;
            }
        }
    }
}

/*设置默认参数*/
- (void)setBeautyDefaultParameters {
    
    self.filtersDataSource = @[@"Origin", @"Delta", @"Electric", @"Slowlived", @"Tokyo", @"Warm"];
    
    self.beautyFiltersDataSource = @[@"origin", @"ziran", @"danya", @"fennen", @"qingxin", @"hongrun"];
    self.filtersCHName = @{@"origin" : @"原图", @"ziran":@"自然", @"danya":@"淡雅", @"fennen":@"粉嫩", @"qingxin":@"清新", @"hongrun":@"红润"};
    self.selectedFilter = @"danya" ;
    self.selectedFilterLevel = 0.5 ;
//    if (!self.selectedFilter) {
//        self.selectedFilter    = self.filtersDataSource[0] ;
//    }
    
    self.skinDetectEnable       = self.performance ? NO : YES ;// 精准美肤
    self.blurShape              = self.performance ? 1 : 0 ;   // 朦胧磨皮 1 ，清晰磨皮 0
    self.blurLevel              = 0.7 ; // 磨皮， 实际设置的时候 x6
    self.whiteLevel             = 0.2 ; // 美白
    self.redLevel               = 0.0 ; // 红润
    
    self.eyelightingLevel       = self.performance ? 0 : 0.7 ; // 亮眼
    self.beautyToothLevel       = self.performance ? 0 : 0.7 ; // 美牙
    
    self.faceShape              = self.performance ? 3 :4 ;   // 脸型
    self.enlargingLevel         = 0.4 ; // 大眼
    self.thinningLevel          = 0.4 ; // 瘦脸
    
    self.enlargingLevel_new     = 0.4 ; // 大眼
    self.thinningLevel_new      = 0.4 ; // 瘦脸
    self.jewLevel               = 0.3 ; // 下巴
    self.foreheadLevel          = 0.3 ; // 额头
    self.noseLevel              = 0.5 ; // 鼻子
    self.mouthLevel             = 0.4 ; // 嘴
    
    /****  美妆程度  ****/
    self.lipstick = 1.0 ;
    self.blush = 1.0 ;
    self.eyebrow = 1.0 ;
    self.eyeShadow = 1.0 ;
    self.eyeLiner = 1.0 ;
    self.eyelash = 1.0 ;
    self.contactLens = 1.0 ;
    
    self.enableGesture = NO;
    self.enableMaxFaces = NO;
}

-(NSArray<FULiveModel *> *)dataSource {
    
    return _dataSource ;
}


- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem];
    
    [self loadMusicItem:self.selectedMusicFilter];
    
    /**加载美颜道具*/
    [self loadFilter];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[2] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            
            [FURenderer destroyItem:items[2]];
            
            items[2] = 0;
        }
    }
}

/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setEnableMaxFaces:(BOOL)enableMaxFaces
{
    if (_enableMaxFaces == enableMaxFaces) {
        return;
    }
    
    _enableMaxFaces = enableMaxFaces;
    
    if (_enableMaxFaces) {
        [FURenderer setMaxFaces:4];
    }else{
        [FURenderer setMaxFaces:1];
    }
    
}

/**销毁全部道具*/
- (void)destoryItems
{
    [FURenderer destroyAllItems];
    NSLog(@"---- destroy all items ~");
    /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
    
    /**销毁道具后，清除context缓存*/
    [FURenderer OnDeviceLost];

    /**销毁道具后，重置默认参数*/
    [self setBeautyDefaultParameters];
}

/**
 获取item的提示语

 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return hintDic[item];
}

- (NSString *)alertForItem:(NSString *)item {
    return alertDic[item] ;
}

- (void)loadAnimojiFaxxBundle {
    /**先创建道具句柄*/
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa.bundle" ofType:nil];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    /**销毁老的道具句柄*/
    if (items[3] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[3]];
    }
    
    /**将刚刚创建的句柄存放在items[3]中*/
    items[3] = itemHandle;
}

- (void)destoryAnimojiFaxxBundle {
    
    /**销毁老的道具句柄*/
    if (items[3] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[3]];
        items[3] = 0 ;
    }
}

#pragma -Faceunity Load Data
/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
{
    
    self.selectedItem = itemName ;

    int destoryItem = items[1];

    if (itemName != nil && ![itemName isEqual: @"noitem"]) {
        /**先创建道具句柄*/
        NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        
        int itemHandle = [FURenderer itemWithContentsOfFile:path];

        // 人像驱动 设置 3DFlipH
        BOOL isPortraitDrive = [itemName hasPrefix:@"picasso_e"];
        BOOL isAnimoji = [itemName hasSuffix:@"_Animoji"];
        
        if (isPortraitDrive || isAnimoji) {
            [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(1)];
            [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(1)];
        }

    	if ([itemName isEqualToString:@"luhantongkuan_ztt_fu"]) {
        	[FURenderer itemSetParam:itemHandle withName:@"flip_action" value:@(1)];
    	}
        
        /**将刚刚创建的句柄存放在items[1]中*/
        items[1] = itemHandle;
    }else{
        /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[1]设为0*/
        items[1] = 0;
    }
    NSLog(@"faceunity: load item");

    /**后销毁老道具句柄*/
    if (destoryItem != 0)
    {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:destoryItem];
    }
}

/**加载美妆道具*/
- (void)loadMakeupItemWithType:(NSInteger)typeIndex itemName:(NSString *)itemName {
    
    typeIndex += 4;
    
    int destoryItem = items[typeIndex];
    
    if (itemName != nil && ![itemName isEqual: @"noitem"]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        
        items[typeIndex] = [FURenderer itemWithContentsOfFile:path];
    }else{
        items[typeIndex] = 0;
    }
    NSLog(@"faceunity: load item");
    /**后销毁老道具句柄*/
    if (destoryItem != 0)
    {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:destoryItem];
    }
}

/**设置美发参数**/
- (void)setHairColor:(int)colorIndex {
    [FURenderer itemSetParam:items[1] withName:@"Index" value:@(colorIndex)]; // 发色
}
- (void)setHairStrength:(float)strength {
    [FURenderer itemSetParam:items[1] withName:@"Strength" value: @(strength)]; // 发色
}


/**加载美颜道具*/
- (void)loadFilter
{
    if (items[0] == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
        items[0] = [FURenderer itemWithContentsOfFile:path];
    }
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    if (items[2] != 0) {
        
        NSLog(@"faceunity: destroy gesture");
        
        [FURenderer destroyItem:items[2]];
        
        items[2] = 0;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
    
    items[2] = [FURenderer itemWithContentsOfFile:path];
}

- (unsigned long)saveParamsSet {
    FUParamsSet *paramsSet = [FUParamsSet new];
    [paramsSet updateWithFUManager:self];
    [_paramsSets addObject:paramsSet];
    return _paramsSets.count - 1;
}

- (void)updateSavedParamsSet:(unsigned long)index {
    if (index >= _paramsSets.count) {
        return;
    }
    FUParamsSet *paramsSet = _paramsSets[index];
    [paramsSet updateWithFUManager:self];
}

- (void)restoreParamsSet:(unsigned long)index {
    if (index >= _paramsSets.count) {
        return;
    }
    FUParamsSet *paramsSet = _paramsSets[index];
    self.selectedFilter        = paramsSet.selectedFilter       ;
    self.selectedFilterLevel   = paramsSet.selectedFilterLevel  ;
    self.selectedItem          = paramsSet.selectedItem         ;
    self.selectedMusicFilter   = paramsSet.selectedMusicFilter  ;
    self.skinDetectEnable      = paramsSet.skinDetectEnable     ;
    self.blurShape             = paramsSet.blurShape            ;
    self.blurLevel             = paramsSet.blurLevel            ;
    self.whiteLevel            = paramsSet.whiteLevel           ;
    self.redLevel              = paramsSet.redLevel             ;
    self.eyelightingLevel      = paramsSet.eyelightingLevel     ;
    self.beautyToothLevel      = paramsSet.beautyToothLevel     ;
    self.faceShape             = paramsSet.faceShape            ;
    self.enlargingLevel        = paramsSet.enlargingLevel       ;
    self.thinningLevel         = paramsSet.thinningLevel        ;
    self.enlargingLevel_new    = paramsSet.enlargingLevel_new   ;
    self.thinningLevel_new     = paramsSet.thinningLevel_new    ;
    self.jewLevel              = paramsSet.jewLevel             ;
    self.foreheadLevel         = paramsSet.foreheadLevel        ;
    self.noseLevel             = paramsSet.noseLevel            ;
    self.mouthLevel            = paramsSet.mouthLevel           ;
    self.lipstick              = paramsSet.lipstick             ;
    self.blush                 = paramsSet.blush                ;
    self.eyebrow               = paramsSet.eyebrow              ;
    self.eyeShadow             = paramsSet.eyeShadow            ;
    self.eyeLiner              = paramsSet.eyeLiner             ;
    self.eyelash               = paramsSet.eyelash              ;
    self.contactLens           = paramsSet.contactLens          ;
    self.enableGesture         = paramsSet.enableGesture        ;
    self.enableMaxFaces        = paramsSet.enableMaxFaces       ;
    [self loadItems];
}

/**设置美颜参数*/
- (void)setBeautyParams {
    
    [FURenderer itemSetParam:items[0] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[0] withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:items[0] withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:items[0] withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:items[0] withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    
    [FURenderer itemSetParam:items[0] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    
    [FURenderer itemSetParam:items[0] withName:@"eye_enlarging" value:self.faceShape == 4 ? @(self.enlargingLevel_new) : @(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"cheek_thinning" value:self.faceShape == 4 ? @(self.thinningLevel_new) : @(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:items[0] withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:items[0] withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:items[0] withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    
    //滤镜名称需要小写
    [FURenderer itemSetParam:items[0] withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:items[0] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
    
    /**  美妆  **/
    if (items[4] != 0) {
        [FURenderer itemSetParam:items[4] withName:@"makeup_intensity" value:@(self.lipstick)]; // 口红
    }
    if (items[5] != 0) {
        [FURenderer itemSetParam:items[5] withName:@"makeup_intensity" value:@(self.blush)]; // 腮红
    }
    if (items[6] != 0) {
        [FURenderer itemSetParam:items[6] withName:@"makeup_intensity" value:@(self.eyebrow)]; // 眉毛
    }
    if (items[7] != 0) {
        [FURenderer itemSetParam:items[7] withName:@"makeup_intensity" value:@(self.eyeShadow)]; // 眼影
    }
    if (items[8] != 0) {
        [FURenderer itemSetParam:items[8] withName:@"makeup_intensity" value:@(self.eyeLiner)]; // 眼线
    }
    if (items[9] != 0) {
        [FURenderer itemSetParam:items[9] withName:@"makeup_intensity" value:@(self.eyelash)]; // 睫毛
    }
    if (items[10] != 0) {
        [FURenderer itemSetParam:items[10] withName:@"makeup_intensity" value:@(self.contactLens)]; // 美瞳
    }
}

/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    [_renderLock lock];
	// 在未识别到人脸时根据重力方向设置人脸检测方向
    if (![FURenderer isTracking]) {

        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;

        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }

        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;

            fuSetDefaultOrientation(self.deviceOrientation) ;
        }
    }
    
    /**设置美颜参数*/
    [self setBeautyParams];
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    [_renderLock unlock];
    return buffer;
}

/**将道具绘制到pixelBuffer*/
- (void)renderItems:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height {
    [_renderLock lock];
    // 在未识别到人脸时根据重力方向设置人脸检测方向
    if (![FURenderer isTracking]) {
        
        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;
        
        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }
        
        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;
            
            fuSetDefaultOrientation(self.deviceOrientation) ;
        }
    }
    
    /**设置美颜参数*/
    [self setBeautyParams];
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    [[FURenderer shareRenderer] renderFrame:y u:u v:v ystride:ystride ustride:ustride vstride:vstride width:width height:height frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    frameID += 1;
    [_renderLock unlock];
    return;
}

- (void)set3DFlipH {
    
    [FURenderer itemSetParam:items[1] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"isFlipExpr" value:@(1)];
}

- (void)setLoc_xy_flip {
    
    [FURenderer itemSetParam:items[1] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"loc_y_flip" value:@(1)];
}

- (void)loadMusicItem:(NSString *)itemName {
    
    self.selectedMusicFilter = itemName ;
    
    int destoryItem = items[11];
    
    if (itemName != nil && ![itemName isEqual: @"noitem"]) {
        /**先创建道具句柄*/
        NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        
        int itemHandle = [FURenderer itemWithContentsOfFile:path];
        /**将刚刚创建的句柄存放在items[11]中*/
        items[11] = itemHandle;
    }else{
        /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[11]设为0*/
        items[11] = 0;
    }
    NSLog(@"faceunity: load item");
    
    /**后销毁老道具句柄*/
    if (destoryItem != 0)
    {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:destoryItem];
    }
}

- (void)musicFilterSetMusicTime {
    
    [FURenderer itemSetParam:items[1] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//需要加50ms的延迟
}

- (void)setMusicTime:(NSTimeInterval)time {
    [FURenderer itemSetParam:items[11] withName:@"music_time" value:@(time * 1000 + 50)];//需要加50ms的延迟
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = frameSize.width - centerX;
    centerX = centerX / frameSize.width;
    
    centerY = frameSize.height - centerY;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks
{
    int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange
{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}


- (NSString *)getPlatformtype {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
